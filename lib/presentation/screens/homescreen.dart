import 'package:auramusic/application/music/music_bloc.dart';
import 'package:auramusic/presentation/common_widget/favoritewidget.dart';
import 'package:auramusic/presentation/common_widget/listtilecustom.dart';
import 'package:auramusic/presentation/core/style.dart';
import 'package:auramusic/presentation/screens/commonscreen/add_to_playlist.dart';
import 'package:auramusic/core/data_structure.dart';
import 'package:auramusic/presentation/screens/mini_player.dart';
import 'package:auramusic/presentation/screens/most_played_scrn.dart';
import 'package:auramusic/presentation/screens/recent_scrn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // double screenwidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
            backgroundColor: const Color(0xFF202EB0),
            body: BlocBuilder<MusicBloc, MusicState>(
              builder: (context, state) {
                if (state.currentlyplaying != null) {
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    showBottomSheet(
                        context: context,
                        backgroundColor: const Color(0xFF202EAF),
                        builder: (context) => const MiniPlayer());
                  });
                }
                return Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.centerLeft,
                      colors: [
                        Color(0xFF000000),
                        Color(0xFF0B0E38),
                        Color(0xFF202EAF)
                      ],
                    ),
                  ),
                  child: allsongs.isEmpty
                      ? songlistempty()
                      : Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 10, top: 15),
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 4.0, bottom: 4),
                                child: icontextheading(
                                    FontAwesomeIcons.layerGroup,
                                    'Library',
                                    context),
                              ),

                              Row(
                                // Library  row section
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (_) => BlocProvider.value(
                                          value: BlocProvider.of<MusicBloc>(
                                              context),
                                          child: const MostPlayedScrn(),
                                        ),
                                      ));
                                    },
                                    child: librarycard(
                                        context: context,
                                        imgsrc:
                                            'assets/images/mostplayedbg.png',
                                        title: 'Most Played'),
                                  ),
                                  InkWell(
                                    child: librarycard(
                                        context: context,
                                        imgsrc: 'assets/images/recentbg.png',
                                        title: 'Recent'),
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (_) => BlocProvider.value(
                                          value: BlocProvider.of<MusicBloc>(
                                              context),
                                          child: const RecentScrn(),
                                        ),
                                      ));
                                    },
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),

                              icontextheading(
                                  FontAwesomeIcons.music, 'Songs', context),
                              const SizedBox(
                                height: 10,
                              ),
                              // creates the list in homescreen
                              listtile(state, context),
                            ],
                          ),
                        ),
                );
              },
            )));
  }

  Widget icontextheading(icon, String title, context) {
    return Row(
      children: [
        FaIcon(icon, color: fontcolor),
        Padding(
          padding:
              EdgeInsets.only(left: MediaQuery.of(context).size.height * 0.01),
          child: Text(title,
              style: const TextStyle(color: fontcolor, fontSize: 19)),
        )
      ],
    );
  }

//Library
  Widget librarycard(
      {required context, required String imgsrc, required String title}) {
    return Card(
      shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              imgsrc,
              width: MediaQuery.of(context).size.width * 0.35,
            ),
          ),
          Positioned(
              bottom: 0,
              child: Container(
                decoration: const BoxDecoration(
                    color: Color(0xFF0C1242),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10))),
                width: MediaQuery.of(context).size.width * 0.35,
                height: MediaQuery.of(context).size.width * 0.1,
                child: Center(
                  child: Text(
                    title,
                    style:
                        const TextStyle(color: Color(0xFFE8E8E8), fontSize: 15),
                  ),
                ),
              ))
        ],
      ),
    );
  }

  songlistempty() {
    return const Center(
      child: Text(
        'No songs found (Check permission)',
        style: TextStyle(color: Colors.grey, fontSize: 20),
      ),
    );
  }

  listtile(MusicState state, BuildContext context) {
    return Expanded(
      child: ListView.builder(
        // physics: const NeverScrollableScrollPhysics(),
        // shrinkWrap: true,
        itemBuilder: (context, index) => InkWell(
            onTap: () {
              BlocProvider.of<MusicBloc>(context)
                  .add(PlayingEvent(playlist: allsongs, playingIndex: index));
            },
            child: ListTileCustom(
              context: context,
              index: index,
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
                  color: fontcolor,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                  fontSize: songnamefontsize,
                ),
              ),
              subtitle: Text(
                allsongs[index].artist != null
                    ? '${allsongs[index].artist}'
                    : 'Unknown',
                style: const TextStyle(
                    color: fontcolor,
                    overflow: TextOverflow.ellipsis,
                    fontSize: artistfontsize),
              ),
              trailing1: FavoriteButton(
                isfav: state.favorite.contains(allsongs[index]),
                currentSong: allsongs[index],
              ),
              trailing2: Theme(
                data: Theme.of(context)
                    .copyWith(cardColor: const Color(0xFF87BEFF)),
                child: PopupMenuButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  icon: const Icon(
                    Icons.more_vert,
                    color: fontcolor,
                  ),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 0,
                      child: Text(
                        'Add to playlist',
                        style: TextStyle(color: Colors.black),
                      ),
                    )
                  ],
                  onSelected: (value) =>
                      Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: BlocProvider.of<MusicBloc>(context),
                      child: AddToPlaylist(addingsong: allsongs[index]),
                    ),
                  )),
                ),
              ),
              tilecolor: const Color(0xFF939DF5),
            )),
        itemCount: allsongs.length,
      ),
    );
  }
}
