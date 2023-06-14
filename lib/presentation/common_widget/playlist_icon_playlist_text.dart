import 'package:auramusic/application/playlist_bloc/playlist_bloc.dart';
import 'package:auramusic/core/data_structure.dart';
import 'package:auramusic/domain/playlist/ui_model/playlist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class PlaylistIcon extends StatelessWidget {
  final EachPlaylist playlist;
  final int index;
  final int currentplaylistindex;
  PlaylistIcon(
      {super.key,
      required this.playlist,
      required this.index,
      required this.currentplaylistindex});
  late bool isadded;

  @override
  Widget build(BuildContext context) {
    isadded = playlist.container.contains(allsongs[index]);

    return BlocBuilder<PlaylistBloc, PlaylistState>(
      builder: (context, state) {
        return IconButton(
            onPressed: () {
              addingOrRemoving(state, context);
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
      },
    );
  }

  addingOrRemoving(PlaylistState playliststate, BuildContext context) {
    if (!playliststate.playlist[currentplaylistindex].container
        .contains(allsongs[index])) {
      BlocProvider.of<PlaylistBloc>(context).add(PlaylistI.songAdding(
          song: allsongs[index],
          playlistIndex: currentplaylistindex,));
      isadded = true;
    } else {
      BlocProvider.of<PlaylistBloc>(context).add(PlaylistI.songRemoving(
          song: allsongs[index],
          playlistIndex: currentplaylistindex,));
      isadded = false;
    }
  }
}
