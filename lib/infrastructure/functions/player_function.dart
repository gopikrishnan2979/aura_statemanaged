import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:auramusic/core/data_structure.dart';
import 'package:auramusic/domain/songs/songs.dart';

//------------Playing the song model by converting it to audio files------------
Future<void> playAudio(
    {required List<Songs> songs, required int index}) async {
currentlyplaying = songs[index];
  player.stop();
  playinglistAudio = [];
  for (int i = 0; i < songs.length; i++) {
    playinglistAudio.add(Audio.file(
      songs[i].songurl!,
        metas: Metas(
          title: songs[i].songname,
          artist: songs[i].artist,
          id: songs[i].id.toString(),
        )));
  }

  //-------Making the audios play------
  await player.open(
      Playlist(
        audios: playinglistAudio,
        startIndex: index,
      ),
      showNotification: true,
      notificationSettings: const NotificationSettings(stopEnabled: false));
  player.setLoopMode(LoopMode.playlist);

}


//---------Finding currently playing song from the list---------
currentlyplayingfinder({required int playingId}) {

  for (Songs song in allsongs) {
    if (song.id == playingId) {
      currentlyplaying = song;
    }
  }

}
