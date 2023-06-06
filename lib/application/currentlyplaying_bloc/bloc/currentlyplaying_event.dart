part of 'currentlyplaying_bloc.dart';

class CurrentlyplayingEvent {}

class PlayingEvent extends CurrentlyplayingEvent {
  List<Songs> playlist;
  int playingIndex;
  PlayingEvent({required this.playingIndex, required this.playlist});
}

class CurrentlyplayFind extends CurrentlyplayingEvent {
  int id;
  CurrentlyplayFind({required this.id});
}
