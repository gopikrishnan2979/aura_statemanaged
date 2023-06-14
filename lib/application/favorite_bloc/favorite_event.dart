part of 'favorite_bloc.dart';

class FavoriteEvent {}

class GetAllFavorite extends FavoriteEvent {}

class FavoriteAddorRemove extends FavoriteEvent {
  late bool isRemoving;
  late bool isAdding;
  Songs song;
  FavoriteAddorRemove.add({required this.song}) {
    isAdding = true;
    isRemoving = false;
  }
  FavoriteAddorRemove.remove({required this.song}) {
    isAdding = false;
    isRemoving = true;
  }
}
