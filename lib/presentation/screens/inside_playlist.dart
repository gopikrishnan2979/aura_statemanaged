import 'package:auramusic/application/music/music_bloc.dart';
import 'package:auramusic/presentation/common_widget/inside_playlist_part1.dart';
import 'package:auramusic/presentation/common_widget/inside_playlist_part2.dart';
import 'package:auramusic/presentation/common_widget/listtilecustom.dart';
import 'package:auramusic/presentation/common_widget/playlist_icon_playlist_text.dart';
import 'package:auramusic/core/data_structure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';

class InsidePlaylist extends StatelessWidget {
  final int currentplaylistindex;
  const InsidePlaylist({super.key, required this.currentplaylistindex});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.centerLeft,
              colors: [Color(0xFF000000), Color(0xFF0B0E38), Color(0xFF202EAF)],
            ),
          ),
          child: BlocBuilder<MusicBloc, MusicState>(
            builder: (context, state) {
              return Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                    size: 30,
                                  )),
                              IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(9)),
                                      backgroundColor: const Color(0xFF0C113F),
                                      context: context,
                                      builder: (context) =>
                                          bottomsheetallsongs(context,state));
                                },
                                icon: const Icon(
                                  Icons.add_to_photos,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    PlaylistInsidePart1(
                        currentplaylistindex: currentplaylistindex),
                    state.playListobjects
                            [currentplaylistindex].container.isEmpty
                        ? const Expanded(
                            child: SizedBox(
                              child: Center(
                                child: Text(
                                  'No songs in playlist, add songs',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : PlaylistInsidePart2(
                            currentplaylistindex: currentplaylistindex,
                          )
                  ],
                );
            },
          ),
        ),
      ),
    );
  }

  bottomsheetallsongs(BuildContext context,MusicState state) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 240, 191, 135),
            Color.fromARGB(255, 255, 255, 255)
          ],
        ),
      ),
      height: MediaQuery.of(context).size.height * 0.6,
      child: ListView.builder(
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8),
            child: ListTileCustom(
              isgradient: false,
              index: index,
              context: context,
              leading: QueryArtworkWidget(
                size: 3000,
                quality: 100,
                artworkQuality: FilterQuality.high,
                artworkBorder: BorderRadius.circular(7),
                artworkFit: BoxFit.cover,
                id: allsongs[index].id,
                type: ArtworkType.AUDIO,
                nullArtworkWidget: ClipRRect(
                  borderRadius: BorderRadius.circular(7),
                  child: Image.asset(
                    'assets/images/Happier.png',
                  ),
                ),
              ),
              title: Text(
                allsongs[index].songname ?? 'Unknown',
                style: const TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                allsongs[index].artist != null
                    ? '${allsongs[index].artist}'
                    : 'Unknown',
                style: const TextStyle(overflow: TextOverflow.ellipsis),
              ),
              trailing2: PlaylistIcon(
                  playlist: state.playListobjects[currentplaylistindex],
                  index: index,
                  currentplaylistindex: currentplaylistindex),
              tilecolor: const Color(0xFFF5B265),
            ),
          );
        },
        itemCount: allsongs.length,
      ),
    );
  }
}
