import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:auramusic/database/recent/recently_played.dart';
import 'package:auramusic/screens/homescreen.dart';
import 'package:auramusic/screens/play_screen.dart';
import 'package:auramusic/screens/splash_screen.dart';
import 'package:auramusic/songs/songs.dart';

playAudio(List<Songs> songs, int index) async {
  currentlyplaying = songs[index];
  player.stop();
  playinglistAudio.clear();
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
}

currentlyplayingfinder(int? playingId) {
  for (Songs song in allsongs) {
    if (song.id == playingId) {
      currentlyplaying = song;
      break;
    }
  }
  recentadd(currentlyplaying!);
}
