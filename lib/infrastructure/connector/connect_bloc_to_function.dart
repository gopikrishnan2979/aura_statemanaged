import 'package:auramusic/application/music/music_bloc.dart';
import 'package:auramusic/domain/playlist/ui_model/playlist.dart';
import 'package:auramusic/infrastructure/database_functions/playlist/playlist_functions.dart';

// Future<FetchData> datafetching() async {

//   return data;
// }

Future<List<EachPlaylist>> playlist(
    {required PlaylistEvent event,
    required List<EachPlaylist> playlist}) async {
  List<EachPlaylist> newplaylists = [];
  if (event.iscreateing) {
    newplaylists = await playlistcreating(
        playlistName: event.newname!, playlists: playlist);
  } else if (event.isdeleting) {
    newplaylists =
        await playlistdelete(playlist: playlist, index: event.playlistIndex!);
  } else if (event.isrenaming) {
    newplaylists = await playlistrename(
        index: event.playlistIndex!,
        playlist: playlist,
        newname: event.newname!);
  } else if (event.isaddingsong) {
    newplaylists = await songAddToPlaylist(
        addingsong: event.songtooperation!,
        playlist: playlist,
        index: event.playlistIndex!);
  } else if (event.isremovingsong) {
    newplaylists = await songRemoveFromPlaylist(
        removingsong: event.songtooperation!,
        playlist: playlist,
        index: event.playlistIndex!);
  }
  return newplaylists;
}
