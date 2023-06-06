import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:auramusic/core/data_structure.dart';
import 'package:auramusic/infrastructure/database_functions/recent/recently_played.dart';
import 'package:auramusic/domain/songs/songs.dart';

Future<Songs> playAudio(
    {required List<Songs> songs, required int index}) async {
  Songs currentlyplaying = songs[index];
  player.stop();
  playinglistAudio = [];
  for (int i = 0; i < songs.length; i++) {
    playinglistAudio.add(Audio.file(songs[i].songurl!,
        metas: Metas(
          title: songs[i].songname,
          artist: songs[i].artist,
          id: songs[i].id.toString(),
        )));
  }
  await player.open(
      Playlist(
        audios: playinglistAudio,
        startIndex: index,
      ),
      showNotification: true,
      notificationSettings: const NotificationSettings(stopEnabled: false));
  player.setLoopMode(LoopMode.playlist);
  return currentlyplaying;
}

Songs? currentlyplayingfinder({required int playingId}) {
  for (Songs song in allsongs) {
    if (song.id == playingId) {
      return song;
    }
  }
  // List<Songs> recent =
  //     await recentadd(recentList: recentlist, song: currentlyplaying!);
}
