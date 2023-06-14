import 'package:auramusic/application/playlist_bloc/playlist_bloc.dart';
import 'package:auramusic/domain/songs/songs.dart';
import 'package:auramusic/infrastructure/functions/player_function.dart';
import 'package:auramusic/presentation/screens/mini_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlaylistInsidePart1 extends StatelessWidget {
  final int currentplaylistindex;
  const PlaylistInsidePart1({super.key, required this.currentplaylistindex});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaylistBloc, PlaylistState>(
      builder: (context, playliststate) {
        return Column(
          children: [
            SizedBox(
              child: Center(
                  child: Container(
                width: MediaQuery.of(context).size.height * 0.3,
                height: MediaQuery.of(context).size.height * 0.3,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/playlistbg.png'),
                        fit: BoxFit.cover)),
              )),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40.0, right: 40, top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        playliststate.playlist[currentplaylistindex].name,
                        style:
                            const TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      Text(
                        '${playliststate.playlist[currentplaylistindex].container.length} songs',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  playliststate.playlist[currentplaylistindex].container.isEmpty
                      ? const SizedBox()
                      : InkWell(
                          onTap: () {
                            List<Songs> playlist = playliststate
                                .playlist[currentplaylistindex].container;
                            playAudio(songs: playlist, index: 0);
                            showModalBottomSheet(
                                enableDrag: false,
                                context: context,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                backgroundColor: const Color(0xFF202EAF),
                                builder: (context) => const MiniPlayer());
                          },
                          child: const CircleAvatar(
                            radius: 30,
                            backgroundColor: Color(0xFF081DDF),
                            child: Icon(
                              Icons.play_arrow_rounded,
                              size: 50,
                            ),
                          ),
                        )
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
