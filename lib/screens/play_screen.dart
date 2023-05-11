import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:auramusic/common_widget/favoritewidget.dart';
import 'package:auramusic/common_widget/playscrnwidget/playscrn_widget.dart';
import 'package:auramusic/database/mostplayed/mostplayed_functions.dart';
import 'package:auramusic/functions/player_function.dart';
import 'package:auramusic/screens/commonscreen/add_to_playlist.dart';
import 'package:auramusic/screens/favorite.dart';
import 'package:auramusic/screens/homescreen.dart';
import 'package:auramusic/screens/splash_screen.dart';
import 'package:auramusic/songs/songs.dart';
import 'package:flutter/material.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:marquee/marquee.dart';
import 'package:on_audio_query/on_audio_query.dart';

Songs? currentlyplaying;
List<Audio> playinglistAudio = [];
bool isRepeatmode = false;

class PlayingScreen extends StatefulWidget {
  const PlayingScreen({super.key});

  @override
  State<PlayingScreen> createState() => _PlayingScreenState();
}

class _PlayingScreenState extends State<PlayingScreen> {
  bool isenteredtomostplayed = false;
  bool nextprevdone = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0B0E38),
      child: SafeArea(
          child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.centerLeft,
              colors: [Color(0xFF000000), Color(0xFF0B0E38), Color(0xFF202EAF)],
            ),
          ),
          child: allsongs.isEmpty
              ? const Center(
                  child: Text(
                    'No songs found',
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                )
              : player.builderCurrent(
                  builder: (context, playing) {
                    int id = int.parse(playing.audio.audio.metas.id!);
                    currentlyplayingfinder(id);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                  size: 30,
                                )),
                          ),
                        ),
                        SizedBox(
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.07),
                            child: const Text(
                              'Playing',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: SizedBox(
                            child: Center(
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.38,
                                width:
                                    MediaQuery.of(context).size.height * 0.38,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      MediaQuery.of(context).size.height *
                                          0.19),
                                  child: QueryArtworkWidget(
                                    size: 3000,
                                    quality: 100,
                                    keepOldArtwork: true,
                                    artworkQuality: FilterQuality.high,
                                    artworkBorder: BorderRadius.circular(10),
                                    artworkFit: BoxFit.cover,
                                    id: int.parse(
                                        playing.audio.audio.metas.id!),
                                    type: ArtworkType.AUDIO,
                                    nullArtworkWidget: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                        'assets/images/playingbg.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.065,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, left: 30, right: 30, bottom: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 30,
                                width: MediaQuery.of(context).size.width,
                                child: Center(
                                  child: Marquee(
                                    text: player.getCurrentAudioTitle,
                                    pauseAfterRound: const Duration(seconds: 3),
                                    velocity: 50,
                                    blankSpace: 30,
                                    style: const TextStyle(
                                        fontSize: 25.0, color: Colors.white),
                                  ),
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.01),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    player.getCurrentAudioArtist
                                                .toString()
                                                .split(" ")[0]
                                                .length >
                                            20
                                        ? '<Unknown>'
                                        : player.getCurrentAudioArtist
                                            .toString()
                                            .split(" ")[0],
                                    style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            setState(() {
                                              player.toggleShuffle();
                                            });
                                          },
                                          icon: FaIcon(
                                            FontAwesomeIcons.shuffle,
                                            size: 28,
                                            color: player.isShuffling.value
                                                ? const Color(0xFF00FF57)
                                                : Colors.white,
                                          )),
                                      IconButton(
                                          onPressed: () {
                                            setState(() {
                                              if (isRepeatmode == false) {
                                                isRepeatmode = true;
                                                player.setLoopMode(
                                                    LoopMode.single);
                                              } else {
                                                isRepeatmode = false;
                                                player.setLoopMode(
                                                    LoopMode.playlist);
                                              }
                                            });
                                          },
                                          icon: Icon(
                                            Icons.repeat,
                                            size: 35,
                                            color: isRepeatmode
                                                ? const Color(0xFF00FF57)
                                                : Colors.white,
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                              player.builderRealtimePlayingInfos(
                                builder: (context, infos) {
                                  Duration currentposition =
                                      infos.currentPosition;
                                  Duration totalduration = infos.duration;
                                  double currentposvalue =
                                      currentposition.inMilliseconds.toDouble();
                                  double totalvalue =
                                      totalduration.inMilliseconds.toDouble();
                                  double value = currentposvalue / totalvalue;
                                  if (!isenteredtomostplayed && value > 0.5) {
                                    mostplayedaddtodb(currentlyplaying!.id);
                                    isenteredtomostplayed = true;
                                  }
                                  return ProgressBar(
                                    timeLabelTextStyle:
                                        const TextStyle(color: Colors.white),
                                    baseBarColor: Colors.black,
                                    bufferedBarColor: Colors.black,
                                    progressBarColor: Colors.white,
                                    thumbColor: Colors.white,
                                    thumbRadius: 8,
                                    thumbGlowRadius: 20,
                                    progress: currentposition,
                                    total: totalduration,
                                    onSeek: (duration) {
                                      player.seek(duration);
                                    },
                                  );
                                },
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.only(top: 15.0),
                                      child: FavoriteButton(
                                          size: 35,
                                          isfav: favorite.value
                                              .contains(currentlyplaying),
                                          currentSong: currentlyplaying!)),
                                  IconButton(
                                      onPressed: () async {
                                        if (nextprevdone) {
                                          nextprevdone = false;
                                          await player.previous();
                                          nextprevdone = true;
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.skip_previous_rounded,
                                        size: 50,
                                        color: Colors.white,
                                      )),
                                  const PlayPause(),
                                  IconButton(
                                      onPressed: () async {
                                        if (nextprevdone) {
                                          nextprevdone = false;
                                          await player.next();
                                          nextprevdone = true;
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.skip_next_rounded,
                                        size: 50,
                                        color: Colors.white,
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: IconButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) => AddToPlaylist(
                                                addingsong: currentlyplaying!),
                                          ));
                                        },
                                        icon: const Icon(
                                          Icons.playlist_add_rounded,
                                          size: 40,
                                          color: Colors.white,
                                        )),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
        ),
      )),
    );
  }
}
