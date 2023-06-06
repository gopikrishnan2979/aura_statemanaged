import 'package:auramusic/domain/fetchdata/fetchdata.dart';
import 'package:auramusic/domain/playlist/ui_model/playlist.dart';
import 'package:auramusic/domain/songs/songs.dart';
import 'package:auramusic/infrastructure/connector/connect_bloc_to_function.dart';
import 'package:auramusic/infrastructure/database_functions/favorite/fav_functions.dart';
import 'package:auramusic/infrastructure/database_functions/mostplayed/mostplayed_functions.dart';
import 'package:auramusic/infrastructure/functions/player_function.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'music_event.dart';
part 'music_state.dart';

class MusicBloc extends Bloc<MusicEvent, MusicState> {
  MusicBloc() : super(MusicInitial()) {
    //Add all musics
    on<GetAllSongs>((event, emit) async {
      FetchData data = await datafetching();
      return emit(MusicState(
          favorite: data.favorite,
          recentList: data.recent,
          mostPlayedList: data.mostplayed,
          playListobjects: data.playlists,
          currentlyplaying: state.currentlyplaying));
    });

    //Favorite functions
    on<FavoriteEvent>((event, emit) async {
      if (event.isAdding) {
        //Fav adding

        List<Songs> favorite = await addfavorite(event.song);
        return emit(MusicState(
            favorite: favorite,
            recentList: state.recentList,
            mostPlayedList: state.mostPlayedList,
            playListobjects: state.playListobjects,
            currentlyplaying: state.currentlyplaying));
      } else {
        //favremoving

        List<Songs> favorite = await removefavorite(event.song);
        return emit(MusicState(
            favorite: favorite,
            recentList: state.recentList,
            mostPlayedList: state.mostPlayedList,
            playListobjects: state.playListobjects,
            currentlyplaying: state.currentlyplaying));
      }
    });

    //Music playing Event
    on<PlayingEvent>((event, emit) async {
      Songs currentlyplaying =
          await playAudio(songs: event.playlist, index: event.playingIndex);
      return emit(MusicState(
          favorite: state.favorite,
          recentList: state.recentList,
          mostPlayedList: state.mostPlayedList,
          playListobjects: state.playListobjects,
          currentlyplaying: currentlyplaying));
    });

    //RecentAdding
    on<RecentAdding>((event, emit) async {
       result = await currentlyplayingfinder(
          recentlist: state.recentList,
          currentlyplaying: state.currentlyplaying,
          playingId: event.playingIndex);
      return emit(MusicState(
          favorite: state.favorite,
          recentList: result['recent'],
          mostPlayedList: state.mostPlayedList,
          playListobjects: state.playListobjects,
          currentlyplaying: result['currentlyplaying']));
    });

    //Playlist all events
    on<PlaylistEvent>((event, emit) async {
      List<EachPlaylist> resultlist =
          await playlist(event: event, playlist: state.playListobjects);
      return emit(MusicState(
          favorite: state.favorite,
          recentList: state.recentList,
          mostPlayedList: state.mostPlayedList,
          playListobjects: resultlist,
          currentlyplaying: state.currentlyplaying));
    });

    on<MostPlayedAddEvent>((event, emit) async {
      List<Songs> resultlist = await mostplayedaddtodb(
          id: event.songid, mostPlayedList: state.mostPlayedList);
      return emit(MusicState(
          favorite: state.favorite,
          recentList: state.recentList,
          mostPlayedList: resultlist,
          playListobjects: state.playListobjects,
          currentlyplaying: state.currentlyplaying));
    });

    on<NavigationEvent>((event, emit) {
      return emit(MusicState(
          favorite: state.favorite,
          recentList: state.recentList,
          mostPlayedList: state.mostPlayedList,
          playListobjects: state.playListobjects,
          currentlyplaying: state.currentlyplaying,navIdx: event.index));
    });
  }
}
