import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:auramusic/domain/songs/songs.dart';


//--------------------Allsong lists -------------------
List<Songs> allsongs = [];

//-----------------Currently playing audio list------------------
List<Audio> playinglistAudio = [];

//-----------------Currently playing song from the list----------------
late Songs currentlyplaying;

//-----------------Player object which is used to play the audios----------------
AssetsAudioPlayer player = AssetsAudioPlayer.withId('0');
