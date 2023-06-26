import 'package:auramusic/application/favorite_bloc/favorite_bloc.dart';
import 'package:auramusic/application/miniplyr_state_bloc/miniplayer_bloc.dart';
import 'package:auramusic/application/mostplayed_bloc/mostplayed_bloc.dart';
import 'package:auramusic/application/playlist_bloc/playlist_bloc.dart';
import 'package:auramusic/application/repeat_cubit/repeat_cubit.dart';
import 'package:auramusic/application/shuffle_cubit/shuffle_cubit.dart';
import 'package:auramusic/infrastructure/functions/player_function.dart';
import 'package:auramusic/presentation/common_widget/favoritewidget.dart';
import 'package:auramusic/presentation/common_widget/listtilecustom.dart';
import 'package:auramusic/presentation/core/style.dart';
import 'package:auramusic/presentation/screens/commonscreen/add_to_playlist.dart';
import 'package:auramusic/presentation/screens/mini_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MostPlayedScrn extends StatelessWidget {
  const MostPlayedScrn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.centerLeft,
              colors: [Color(0xFF000000), Color(0xFF0B0E38), Color(0xFF202EAF)],
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
                          'Most Played',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              BlocBuilder<MostPlayedBloc, MostPlayedState>(
                builder: (mostcontext, mosstate) {
                  return Expanded(
                    child: mosstate.mostPlayedList.isEmpty
                        ? songlistempty()
                        : ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 10, bottom: 30),
                            itemBuilder: (context, index) => InkWell(
                              onTap: () {
                                playAudio(
                                    songs: mosstate.mostPlayedList,
                                    index: index);
                                BlocProvider.of<MiniplayerBloc>(context)
                                    .add(MiniplayerEvent());
                                showModalBottomSheet(
                                    enableDrag: false,
                                    context: context,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    backgroundColor: const Color(0xFF202EAF),
                                    builder:  (_) => MultiBlocProvider(
                          providers: [
                            BlocProvider.value(
                                value: BlocProvider.of<ShuffleCubit>(context)),
                            BlocProvider.value(
                                value: BlocProvider.of<RepeatCubit>(context))
                          ],
                          child: const MiniPlayer(),
                        ));
                              },
                              child: ListTileCustom(
                                index: index,
                                context: context,
                                leading: QueryArtworkWidget(
                                  size: 3000,
                                  quality: 100,
                                  artworkQuality: FilterQuality.high,
                                  artworkBorder: BorderRadius.circular(7),
                                  artworkFit: BoxFit.cover,
                                  id: mosstate.mostPlayedList[index].id,
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
                                  mosstate.mostPlayedList[index].songname!,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: songnamefontsize,
                                      overflow: TextOverflow.ellipsis,
                                      color: fontcolor),
                                ),
                                subtitle: Text(
                                    mosstate.mostPlayedList[index].artist!,
                                    style: const TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: artistfontsize,
                                        color: fontcolor)),
                                trailing1:
                                    BlocBuilder<FavoriteBloc, FavoriteState>(
                                  builder: (context, favstate) {
                                    return FavoriteButton(
                                        isfav: favstate.favorite.contains(
                                            mosstate.mostPlayedList[index]),
                                        currentSong:
                                            mosstate.mostPlayedList[index]);
                                  },
                                ),
                                trailing2: Theme(
                                  data: Theme.of(context).copyWith(
                                      cardColor: const Color(0xFF87BEFF)),
                                  child: PopupMenuButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    icon: const Icon(
                                      Icons.more_vert,
                                      color: fontcolor,
                                    ),
                                    itemBuilder: (context) => [
                                      const PopupMenuItem(
                                          child: Text('Add to playlist'))
                                    ],
                                    onSelected: (value) => Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => BlocProvider.value(
                                        value: BlocProvider.of<PlaylistBloc>(
                                            context),
                                        child: AddToPlaylist(
                                            addingsong:
                                                mosstate.mostPlayedList[index]),
                                      ),
                                    )),
                                  ),
                                ),
                              ),
                            ),
                            itemCount: mosstate.mostPlayedList.length,
                          ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  songlistempty() {
    return const Center(
      child: Text(
        'No songs in mostplayed',
        style: TextStyle(color: Colors.grey, fontSize: 20),
      ),
    );
  }
}
