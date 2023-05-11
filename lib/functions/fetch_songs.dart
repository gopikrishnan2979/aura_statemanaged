
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:auramusic/database/favorite/dbmodel/fav_model.dart';
import 'package:auramusic/database/playlist/playlistmodel/playlist_model.dart';
import 'package:auramusic/screens/favorite.dart';
import 'package:auramusic/screens/most_played_scrn.dart';
import 'package:auramusic/screens/play_screen.dart';
import 'package:auramusic/screens/playlist_scrn.dart';
import 'package:auramusic/screens/recent_scrn.dart';
import 'package:auramusic/screens/splash_screen.dart';
import 'package:auramusic/songs/playlist.dart';
import 'package:auramusic/songs/songs.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';

class FetchSongs {
  final OnAudioQuery audioquerry = OnAudioQuery();
  requestPermission() async {
    PermissionStatus status = await Permission.storage.request();
    if (status.isGranted) {
      return true;
    } else {
      return false;
    }
  }

  songfetch() async {
    bool status = await requestPermission();
    if (status) {
      List<SongModel> fetchsongs = await audioquerry.querySongs(
          ignoreCase: true,
          orderType: OrderType.ASC_OR_SMALLER,
          sortType: null,
          uriType: UriType.EXTERNAL);
      for (SongModel element in fetchsongs) {
        if (element.fileExtension == "mp3") {
          allsongs.add(Songs(
              songname: element.displayNameWOExt,
              artist: element.artist,
              duration: element.duration,
              id: element.id,
              songurl: element.uri));
          playinglistAudio.add(Audio.file(element.uri!,
              metas: Metas(
                title: element.displayNameWOExt,
                artist: element.artist,
                id: element.id.toString(),
              )));
        }
      }
      await favfetch();
      await playlistfetch();
      await recentfetch();
      await mostplayedfetch();
    }
  }

  favfetch() async {
    List<FavModel
    > favsongcheck = [];
    Box<FavModel> favdb = await Hive.openBox('favorite');
    favsongcheck.addAll(favdb.values);
    for (var favs in favsongcheck) {
      int count = 0;
      for (var songs in allsongs) {
        if (favs.id == songs.id) {
          favorite.value.insert(0, songs);
          break;
        } else {
          count++;
        }
      }
      if (count == allsongs.length) {
        var key = favs.key;
        favdb.delete(key);
      }
    }
  }

  playlistfetch() async {
    Box<PlaylistClass> playlistdb = await Hive.openBox('playlist');
    for (PlaylistClass elements in playlistdb.values) {
      String playlistname = elements.playlistName;
      EachPlaylist playlistfetch = EachPlaylist(name: playlistname);
      for (int id in elements.items) {
        for (Songs songs in allsongs) {
          if (id == songs.id) {
            playlistfetch.container.add(songs);
            break;
          }
        }
      }
      playListNotifier.value.add(playlistfetch);
    }
  }

  mostplayedfetch() async {
    Box<int> mostplayedDb = await Hive.openBox('mostplayed');
    if (mostplayedDb.isEmpty) {
      for (Songs song in allsongs) {
        mostplayedDb.put(song.id, 0);
      }
    } else {
      List<List<int>> mostplayedTemp = [];
      for (Songs song in allsongs) {
        int count = mostplayedDb.get(song.id)!;
        mostplayedTemp.add([song.id, count]);
      }
      for (int i = 0; i < mostplayedTemp.length - 1; i++) {
        for (int j = i + 1; j < mostplayedTemp.length; j++) {
          if (mostplayedTemp[i][1] < mostplayedTemp[j][1]) {
            List<int> temp = mostplayedTemp[i];
            mostplayedTemp[i] = mostplayedTemp[j];
            mostplayedTemp[j] = temp;
          }
        }
      }
      List<List<int>> temp = [];
      for (int i = 0; i < mostplayedTemp.length && i < 10; i++) {
        temp.add(mostplayedTemp[i]);
      }
      mostplayedTemp = temp;
      for (List<int> element in mostplayedTemp) {
        for (Songs song in allsongs) {
          if (element[0] == song.id && element[1] > 3) {
            mostPlayedList.value.add(song);
          }
        }
      }
    }
  }

  recentfetch() async {
    Box<int> recentDb = await Hive.openBox('recent');
    List<Songs> recenttemp = [];
    for (int element in recentDb.values) {
      for (Songs song in allsongs) {
        if (element == song.id) {
          recenttemp.add(song);
          break;
        }
      }
    }
    recentList.value = recenttemp.reversed.toList();
  }
}
