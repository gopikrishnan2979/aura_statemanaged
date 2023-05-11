import 'package:auramusic/functions/player_function.dart';
import 'package:auramusic/screens/mini_player.dart';
import 'package:auramusic/screens/playlist_scrn.dart';
import 'package:flutter/material.dart';

class PlaylistInsidePart1 extends StatelessWidget {
  final int currentplaylistindex;
  const PlaylistInsidePart1({super.key, required this.currentplaylistindex});

  @override
  Widget build(BuildContext context) {
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
                    playListNotifier.value[currentplaylistindex].name,
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Text(
                    '${playListNotifier.value[currentplaylistindex].container.length} songs',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
              playListNotifier.value[currentplaylistindex].container.isEmpty
                  ? const SizedBox()
                  : InkWell(
                      onTap: () {
                        playAudio(
                            playListNotifier
                                .value[currentplaylistindex].container,
                            0);
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
  }
}
