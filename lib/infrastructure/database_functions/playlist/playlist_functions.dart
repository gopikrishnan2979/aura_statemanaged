import 'package:auramusic/domain/playlist/hiveplaylistmodel/playlist_model.dart';
import 'package:auramusic/domain/playlist/ui_model/playlist.dart';
import 'package:auramusic/domain/songs/songs.dart';
import 'package:hive_flutter/hive_flutter.dart';

//create a playlist
Future<List<EachPlaylist>> playlistcreating(
    {required String playlistName,
    required List<EachPlaylist> playlists}) async {
  playlists.add(EachPlaylist(name: playlistName));
  Box<PlaylistClass> playlistdb = await Hive.openBox('playlist');
  playlistdb.put(playlistName, PlaylistClass(playlistName: playlistName));
  return playlists;
}

//playlist deleting
Future<List<EachPlaylist>> playlistdelete(
    {required List<EachPlaylist> playlist, required int index}) async {
  Box<PlaylistClass> playlistdb = await Hive.openBox('playlist');
  playlistdb.delete(playlist[index].name);
  playlist.removeAt(index);
  return playlist;
}

//playlist renaming
Future<List<EachPlaylist>> playlistrename(
    {required int index,
    required List<EachPlaylist> playlist,
    required String newname}) async {
  String key = playlist[index].name;
  Box<PlaylistClass> playlistdb = await Hive.openBox('playlist');
  PlaylistClass updating = playlistdb.get(key)!;
  updating.playlistName = newname;
  playlistdb.put(key, updating);
  playlist[index].name = newname;
  return playlist;
}

//Songs adding to playlist
Future<List<EachPlaylist>> songAddToPlaylist(
    {required Songs addingsong,
    required List<EachPlaylist> playlist,
    required int index}) async {
  Box<PlaylistClass> playlistdb = await Hive.openBox('playlist');
  String key = playlist[index].name;
  playlist[index].container.add(addingsong);
  PlaylistClass updateingPlaylist = playlistdb.get(key)!;
  updateingPlaylist.items.add(addingsong.id);
  playlistdb.put(key, updateingPlaylist);
  return playlist;
}

//song remove from playlist
Future<List<EachPlaylist>> songRemoveFromPlaylist(
    {required Songs removingsong,
    required List<EachPlaylist> playlist,
    required int index}) async {
  Box<PlaylistClass> playlistdb = await Hive.openBox('playlist');
  String key = playlist[index].name;
  PlaylistClass updateplaylist = playlistdb.get(key)!;
  int itemidx = 0;
  for (int i = 0; i < updateplaylist.items.length; i++) {
    if (updateplaylist.items[i] == removingsong.id) {
      itemidx = i;
    }
  }
  updateplaylist.items.removeAt(itemidx);
  playlistdb.put(key, updateplaylist);
  return playlist;
}
