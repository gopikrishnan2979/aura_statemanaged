part of 'music_bloc.dart';

class MusicState {
//favorite state
  List<Songs> favorite;

//recent state
  List<Songs> recentList;

//Mostplayed
  List<Songs> mostPlayedList;

//currently playing states
  Songs? currentlyplaying;

//Playlist state
  List<EachPlaylist> playListobjects;
  int navIdx;

  MusicState(
      {required this.favorite,
      required this.recentList,
      required this.mostPlayedList,
      required this.playListobjects,
      required this.currentlyplaying,this.navIdx=0});
}

class MusicInitial extends MusicState {
  MusicInitial()
      : super(
            favorite: [],
            mostPlayedList: [],
            playListobjects: [],
            recentList: [],
            currentlyplaying: null);
}
