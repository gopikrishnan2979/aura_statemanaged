part of 'music_bloc.dart';

class MusicEvent {}

class GetAllSongs extends MusicEvent {}

class FavoriteEvent extends MusicEvent {
  bool isRemoving;
  bool isAdding;
  Songs song;
  FavoriteEvent(
      {required this.song, this.isAdding = false, this.isRemoving = false});
}

class PlayingEvent extends MusicEvent {
  List<Songs> playlist;
  int playingIndex;
  PlayingEvent({required this.playlist, required this.playingIndex});
}

class RecentAdding extends MusicEvent {
  int playingIndex;
  RecentAdding({required this.playingIndex});
}

class MostPlayedAddEvent extends MusicEvent {
  int songid;
  MostPlayedAddEvent({required this.songid});
}

class PlaylistEvent extends MusicEvent {
  Songs? songtooperation;
  int? playlistIndex;
  String? newname;
  late bool iscreateing;
  late bool isrenaming;
  late bool isdeleting;
  late bool isaddingsong;
  late bool isremovingsong;
  PlaylistEvent.createnew({required this.newname}) {
    iscreateing = true;
    isdeleting = false;
    isrenaming = false;
    isaddingsong = false;
    isremovingsong = false;
  }
  
  PlaylistEvent.isrenaming({
    required this.newname,
    required this.playlistIndex,
  }) {
    iscreateing = false;
    isdeleting = false;
    isrenaming = true;
    isaddingsong = false;
    isremovingsong = false;
  }

  PlaylistEvent.isdeleting({required this.playlistIndex}) {
    iscreateing = false;
    isdeleting = true;
    isrenaming = false;
    isaddingsong = false;
    isremovingsong = false;
  }

  PlaylistEvent.songAddorRemove(
      {required this.songtooperation,
      required this.playlistIndex,
      required this.isaddingsong,
      required this.isremovingsong}) {
    iscreateing = true;
    isdeleting = false;
    isrenaming = false;
  }
}

class NavigationEvent extends MusicEvent {
  int index;
  NavigationEvent({required this.index});
}
