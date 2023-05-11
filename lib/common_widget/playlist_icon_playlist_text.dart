import 'package:auramusic/functions/universal_functions.dart';
import 'package:auramusic/screens/playlist_scrn.dart';
import 'package:auramusic/screens/splash_screen.dart';
import 'package:auramusic/songs/playlist.dart';
import 'package:flutter/material.dart';

class PlaylistIcon extends StatefulWidget {
  final EachPlaylist playlist;
  final int index;
  final int currentplaylistindex;
  const PlaylistIcon(
      {super.key,
      required this.playlist,
      required this.index,
      required this.currentplaylistindex});
  @override
  State<PlaylistIcon> createState() => _PlaylistIconState();
}

class _PlaylistIconState extends State<PlaylistIcon> {
  late bool isadded;
  @override
  void initState() {
    super.initState();
    isadded = widget.playlist.container.contains(allsongs[widget.index]);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          setState(() {
            addingOrRemoving();
          });
          playListNotifier.notifyListeners();
        },
        icon: isadded
            ? const Icon(
                Icons.remove,
                size: 30,
                color: Color(0xFF202EAF),
              )
            : const Icon(
                Icons.add,
                size: 30,
                color: Color.fromARGB(255, 255, 255, 255),
              ));
  }

  addingOrRemoving() {
    if (!playListNotifier.value[widget.currentplaylistindex].container
        .contains(allsongs[widget.index])) {
      playlistaddDB(allsongs[widget.index],
          playListNotifier.value[widget.currentplaylistindex].name);
      playListNotifier.value[widget.currentplaylistindex].container
          .add(allsongs[widget.index]);
      isadded = true;
    } else {
      playlistremoveDB(allsongs[widget.index], widget.playlist.name);
      playListNotifier.value[widget.currentplaylistindex].container
          .remove(allsongs[widget.index]);
      isadded = false;
    }
  }
}
