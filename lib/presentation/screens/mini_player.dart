import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:auramusic/application/music/music_bloc.dart';
import 'package:auramusic/core/data_structure.dart';
import 'package:auramusic/presentation/screens/play_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marquee/marquee.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:auramusic/presentation/core/style.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    bool isenteredtomostplayed = false;

    bool nextprevdone = true;
    return InkWell(
      onTap: () {
        // playing screen code have to be written here
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const PlayingScreen(),
        ));
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xFF0C113F),
          ),
          height: MediaQuery.of(context).size.height * 0.0738,
          child: player.builderCurrent(
            builder: (context, playing) {
              int id = int.parse(playing.audio.audio.metas.id!);
              BlocProvider.of<MusicBloc>(context)
                  .add(RecentAdding(playingIndex: id));
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.06,
                          width: MediaQuery.of(context).size.height * 0.06,
                          child: QueryArtworkWidget(
                            id: int.parse(playing.audio.audio.metas.id!),
                            type: ArtworkType.AUDIO,
                            artworkBorder: BorderRadius.circular(4),
                            nullArtworkWidget: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.asset(
                                'assets/images/Happier.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.02),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                height:
                                    MediaQuery.of(context).size.height * 0.025,
                                child: Marquee(
                                  text: player.getCurrentAudioTitle,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: songnamefontsize),
                                  velocity: 35,
                                  blankSpace: 20,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.008),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: Text(
                                    player.getCurrentAudioArtist,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: artistfontsize,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                            onTap: () async {
                              if (nextprevdone) {
                                nextprevdone = false;
                                await player.previous();
                                nextprevdone = true;
                              }
                            },
                            child: CircleAvatar(
                              backgroundColor: const Color(0xFF0C113F),
                              radius: MediaQuery.of(context).size.width * 0.05,
                              child: const Icon(
                                Icons.skip_previous,
                                color: Colors.white,
                                size: 30,
                              ),
                            )),
                        PlayerBuilder.isPlaying(
                          player: player,
                          builder: (context, isPlaying) {
                            return InkWell(
                                onTap: () {
                                  isPlaying = !isPlaying;
                                  player.playOrPause();
                                },
                                child: CircleAvatar(
                                  backgroundColor: const Color(0xFF0C113F),
                                  radius:
                                      MediaQuery.of(context).size.width * 0.05,
                                  child: Icon(
                                    isPlaying ? Icons.pause : Icons.play_arrow,
                                    color: Colors.white,
                                  ),
                                ));
                          },
                        ),
                        InkWell(
                            onTap: () async {
                              if (nextprevdone) {
                                nextprevdone = false;
                                await player.next();
                                nextprevdone = true;
                              }
                            },
                            child: CircleAvatar(
                              backgroundColor: const Color(0xFF0C113F),
                              radius: MediaQuery.of(context).size.width * 0.05,
                              child: const Icon(
                                Icons.skip_next,
                                color: Colors.white,
                                size: 30,
                              ),
                            )),
                      ],
                    ),
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(1),
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.height * 0.007,
                              right: MediaQuery.of(context).size.height * 0.007,
                            ),
                            child: PlayerBuilder.realtimePlayingInfos(
                              player: player,
                              builder: (context, infos) {
                                Duration currentpos = infos.currentPosition;
                                Duration total = infos.duration;
                                double currentposvalue =
                                    currentpos.inMilliseconds.toDouble();
                                double totalvalue =
                                    total.inMilliseconds.toDouble();
                                double value = currentposvalue / totalvalue;
                                if (!isenteredtomostplayed && value > 0.5) {
                                  int id =
                                      int.parse(playing.audio.audio.metas.id!);
                                  // currentsongfinder(id);
                                  BlocProvider.of<MusicBloc>(context)
                                      .add(MostPlayedAddEvent(songid: id));
                                  isenteredtomostplayed = true;
                                }

                                return LinearProgressIndicator(
                                  backgroundColor: const Color(0xFF0C113F),
                                  color: Colors.green,
                                  minHeight: 2.5,
                                  value: value,
                                );
                              },
                            ),
                          )))
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
