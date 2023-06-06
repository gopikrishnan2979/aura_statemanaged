import 'package:hive_flutter/hive_flutter.dart';
part 'playlist_model.g.dart';

@HiveType(typeId: 1)
class PlaylistClass extends HiveObject {
  @HiveField(0)
  String playlistName;

  @HiveField(1)
  List<int> items = [];
  PlaylistClass({required this.playlistName});
}
