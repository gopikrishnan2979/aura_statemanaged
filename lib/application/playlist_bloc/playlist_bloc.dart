import 'package:auramusic/domain/playlist/ui_model/playlist.dart';
import 'package:auramusic/domain/songs/songs.dart';
import 'package:auramusic/infrastructure/database_functions/playlist/playlist_functions.dart';
import 'package:auramusic/infrastructure/functions/fetch_songs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'playlist_event.dart';
part 'playlist_state.dart';


//-----------------------------------------Playlist Bloc----------------------------------------------------
class PlaylistBloc extends Bloc<PlaylistEvent, PlaylistState> {
  PlaylistBloc() : super(PlaylistState(playlist: [])) {
    on<PlaylistFetch>((event, emit) async {
      List<EachPlaylist> playlistdata = await playlistfetch();
      return emit(PlaylistState(playlist: playlistdata));
    });

    //--------------------------------Playlist creation,deletion and renaming-------------------------------------------

    on<PlaylistE>((event, emit) async {
      if (event.iscreateing) {
        //Playlist creation

        List<EachPlaylist> playlistdata = await playlistcreating(
            playlistName: event.newname!, playlists: state.playlist);
        return emit(PlaylistState(playlist: playlistdata));
      } else if (event.isdeleting) {
        //Playlist deletion

        List<EachPlaylist> playlistdata = await playlistdelete(
            playlist: state.playlist, index: event.playlistIndex!);
        return emit(PlaylistState(playlist: playlistdata));
      } else {
        //Playlist renaming

        List<EachPlaylist> playlistdata = await playlistrename(
            index: event.playlistIndex!,
            playlist: state.playlist,
            newname: event.newname!);
        return emit(PlaylistState(playlist: playlistdata));
      }
    });

    //--------------------------------Playlist song adding and removing----------------------------------------------

    on<PlaylistI>((event, emit) async {
      if (event.isadding) {
        //Song adding to the playlist

        List<EachPlaylist> playlistdata = await songAddToPlaylist(
            addingsong: event.song,
            playlist: state.playlist,
            index: event.playlistIndex);
        return emit(PlaylistState(playlist: playlistdata));
      } else {
        //Song remove from playlist

        List<EachPlaylist> playlistdata = await songRemoveFromPlaylist(
            removingsong: event.song,
            playlist: state.playlist,
            index: event.playlistIndex);
        return emit(PlaylistState(playlist: playlistdata));
      }
    });
  }
}
