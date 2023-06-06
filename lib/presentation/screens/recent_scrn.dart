import 'package:auramusic/application/music/music_bloc.dart';
import 'package:auramusic/presentation/common_widget/favoritewidget.dart';
import 'package:auramusic/presentation/common_widget/listtilecustom.dart';
import 'package:auramusic/presentation/core/style.dart';
import 'package:auramusic/presentation/screens/commonscreen/add_to_playlist.dart';
import 'package:auramusic/presentation/screens/mini_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';

class RecentScrn extends StatelessWidget {
  const RecentScrn({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0B0E38),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFF0B0E38),
          body: Container(
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
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                              size: 30,
                              color: Colors.white,
                            )),
                        const Padding(
                          padding: EdgeInsets.only(left: 4.0),
                          child: Text(
                            'RECENT',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                BlocBuilder<MusicBloc, MusicState>(
                  builder: (context, state) => Expanded(
                    child: listtilebuilder(state),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget songlistempty() {
    return const Center(
      child: Text(
        'No songs in recent',
        style: TextStyle(color: Colors.grey, fontSize: 20),
      ),
    );
  }

  Widget listtilebuilder(MusicState state) {
    return state.recentList.isEmpty
        ? songlistempty()
        : ListView.builder(
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 30),
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) => InkWell(
              onTap: () {
                BlocProvider.of<MusicBloc>(context).add(PlayingEvent(
                    playlist: state.recentList, playingIndex: index));
                showModalBottomSheet(
                    context: context,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    backgroundColor: const Color(0xFF202EAF),
                    builder: (context) => const MiniPlayer());
              },
              child: ListTileCustom(
                index: index,
                context: context,
                leading: QueryArtworkWidget(
                  size: 3000,
                  quality: 100,
                  artworkQuality: FilterQuality.high,
                  artworkBorder: BorderRadius.circular(10),
                  artworkFit: BoxFit.cover,
                  id: state.recentList[index].id,
                  type: ArtworkType.AUDIO,
                  nullArtworkWidget: ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: Image.asset(
                      'assets/images/Happier.png',
                    ),
                  ),
                ),
                tilecolor: const Color(0xFF939DF5),
                title: Text(
                  state.recentList[index].songname!,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                      fontSize: songnamefontsize,
                      color: fontcolor),
                ),
                subtitle: Text(state.recentList[index].artist!,
                    style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: artistfontsize,
                        color: fontcolor)),
                trailing1: FavoriteButton(
                    isfav: state.favorite.contains(state.recentList[index]),
                    currentSong: state.recentList[index]),
                trailing2: Theme(
                  data: Theme.of(context)
                      .copyWith(cardColor: const Color(0xFF87BEFF)),
                  child: PopupMenuButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      icon: const Icon(Icons.more_vert, color: fontcolor),
                      itemBuilder: (context) =>
                          [const PopupMenuItem(child: Text('Add to playlist'))],
                      onSelected: (value) =>
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => BlocProvider.value(
                              value: BlocProvider.of<MusicBloc>(context),
                              child: AddToPlaylist(
                                  addingsong: state.recentList[index]),
                            ),
                          ))),
                ),
              ),
            ),
            itemCount: state.recentList.length,
          );
  }
}
