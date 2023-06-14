import 'package:auramusic/domain/songs/songs.dart';
import 'package:auramusic/infrastructure/database_functions/favorite/fav_functions.dart';
import 'package:auramusic/infrastructure/functions/fetch_songs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

//------------------------------------------Favorite bloc------------------------------------

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  FavoriteBloc() : super(FavoriteState(favorite: [])) {

    //Favorite fetching-------------------------
    on<GetAllFavorite>((event, emit) async {
      List<Songs> fav = await favfetch();
      return emit(FavoriteState(favorite: fav));
    });

    //Favorite adding and removing-----------------------------
    on<FavoriteAddorRemove>((event, emit) async {
      List<Songs> fav = [];
      if (event.isAdding) {
        fav = await addfavorite(event.song,state.favorite);
      } else if (event.isRemoving) {
        fav = await removefavorite(event.song,state.favorite);
      }
      return emit(FavoriteState(favorite: fav));
    });
  }
}
