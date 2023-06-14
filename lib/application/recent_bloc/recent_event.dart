part of 'recent_bloc.dart';

class RecentEvent {}

class RecentFetch extends RecentEvent{

}

class RecentAdd extends RecentEvent{
  int songid;
  RecentAdd({required this.songid});
}
