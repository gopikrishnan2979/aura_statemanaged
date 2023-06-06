part of 'mostplayed_bloc.dart';

class MostPlayedEvent {}

class MostPlayedFetch extends MostPlayedEvent {}

class MostPlayedAdd extends MostPlayedEvent {
  int songid;
  MostPlayedAdd({required this.songid});
}
