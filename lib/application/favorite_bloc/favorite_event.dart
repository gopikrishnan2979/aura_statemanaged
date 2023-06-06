part of 'favorite_bloc.dart';

class FavoriteEvent {}

class GetAllFavorite extends FavoriteEvent {}

class FavoriteAddorRemove extends FavoriteEvent {
  bool isRemoving;
  bool isAdding;
  Songs song;
  FavoriteAddorRemove(
      {required this.song, this.isAdding = false, this.isRemoving = false});
}
