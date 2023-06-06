part of 'recent_bloc.dart';

class RecentEvent {}

class RecentFetch extends RecentEvent{

}

class RecentAdd extends RecentEvent{
  Songs song;
  RecentAdd({required this.song});
}
