
import 'package:auramusic/database/playlist/playlistmodel/playlist_model.dart';
import 'package:auramusic/screens/playlist_scrn.dart';
import 'package:auramusic/songs/playlist.dart';
import 'package:auramusic/songs/songs.dart';
import 'package:hive_flutter/hive_flutter.dart';

//calling from navigator screen
Future playlistcreating(playlistName) async {
  playListNotifier.value.add(EachPlaylist(name: playlistName));
  Box<PlaylistClass> playlistdb = await Hive.openBox('playlist');
  playlistdb.add(PlaylistClass(playlistName: playlistName));
  playlistdb.close();
}

Future playlistaddDB(Songs addingsong, String playlistName) async {
  Box<PlaylistClass> playlistdb = await Hive.openBox('playlist');
  for (PlaylistClass element in playlistdb.values) {
    if (element.playlistName == playlistName) {
      var key = element.key;
      PlaylistClass updateplaylist = PlaylistClass(playlistName: playlistName);
      updateplaylist.items.addAll(element.items);
      updateplaylist.items.add(addingsong.id);
      playlistdb.put(key, updateplaylist);
      break;
    }
  }
  playlistdb.close();
}

Future playlistremoveDB(Songs removingsong, String playlistName) async {
  Box<PlaylistClass> playlistdb = await Hive.openBox('playlist');
  for (PlaylistClass element in playlistdb.values) {
    if (element.playlistName == playlistName) {
      var key = element.key;
      PlaylistClass updateplaylist = PlaylistClass(playlistName: playlistName);
      for (int item in element.items) {
        if (item == removingsong.id) {
          continue;
        }
        updateplaylist.items.add(item);
      }
      playlistdb.put(key, updateplaylist);
      break;
    }
  }
  playListNotifier.notifyListeners();
}

Future playlistdelete(int index) async {
  String playlistname = playListNotifier.value[index].name;
  Box<PlaylistClass> playlistdb = await Hive.openBox('playlist');
  for (PlaylistClass element in playlistdb.values) {
    if (element.playlistName == playlistname) {
      var key = element.key;
      playlistdb.delete(key);
      break;
    }
  }
  playListNotifier.value.removeAt(index);
  playListNotifier.notifyListeners();
}

Future playlistrename(int index, String newname) async {
  String playlistname = playListNotifier.value[index].name;
  Box<PlaylistClass> playlistdb = await Hive.openBox('playlist');
  for (PlaylistClass element in playlistdb.values) {
    if (element.playlistName == playlistname) {
      var key = element.key;
      element.playlistName = newname;
      playlistdb.put(key, element);
    }
  }
  playListNotifier.value[index].name = newname;
  playListNotifier.notifyListeners();
}
