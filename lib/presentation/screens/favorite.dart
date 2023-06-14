import 'package:auramusic/application/favorite_bloc/favorite_bloc.dart';
import 'package:auramusic/application/miniplyr_state_bloc/miniplayer_bloc.dart';
import 'package:auramusic/application/playlist_bloc/playlist_bloc.dart';
import 'package:auramusic/infrastructure/functions/player_function.dart';
import 'package:auramusic/presentation/common_widget/favoritewidget.dart';
import 'package:auramusic/presentation/common_widget/listtilecustom.dart';
import 'package:auramusic/presentation/core/style.dart';
import 'package:auramusic/presentation/screens/commonscreen/add_to_playlist.dart';
import 'package:auramusic/presentation/screens/mini_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Favorite extends StatelessWidget {
  const Favorite({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 20, 30, 124),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.centerLeft,
            colors: [Color(0xFF000000), Color(0xFF0B0E38), Color(0xFF202EAF)],
          ),
        ),
        child: BlocBuilder<MiniplayerBloc, MiniplayerState>(
          builder: (context, cntplaystate) {
            if (cntplaystate.isactive) {
              WidgetsBinding.instance.addPostFrameCallback(
                (timeStamp) {
                  showBottomSheet(
                      context: context,
                      backgroundColor: const Color(0xFF202EAF),
                      builder: (context) => const MiniPlayer());
                },
              );
            }
            return BlocBuilder<FavoriteBloc, FavoriteState>(
              builder: (context, favstate) {
                return favstate.favorite.isEmpty
                    ? const Center(
                        child: Text(
                          'Favorite List is empty',
                          style: TextStyle(fontSize: 20, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 10),
                        itemCount: favstate.favorite.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) => InkWell(
                          onTap: () {
                            playAudio(songs: favstate.favorite, index: index);
                            BlocProvider.of<MiniplayerBloc>(context)
                                .add(MiniplayerEvent());
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
                              id: favstate.favorite[index].id,
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
                              favstate.favorite[index].songname ?? 'Unknown',
                              style: const TextStyle(
                                  color: fontcolor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: songnamefontsize,
                                  overflow: TextOverflow.ellipsis),
                            ),
                            subtitle: Text(
                              favstate.favorite[index].artist != null
                                  ? '${favstate.favorite[index].artist}'
                                  : 'Unknown',
                              style: const TextStyle(
                                  color: fontcolor,
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: artistfontsize),
                            ),
                            trailing1: FavoriteButton(
                              isfav: true,
                              currentSong: favstate.favorite[index],
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
                                    Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => BlocProvider.value(
                                      value: BlocProvider.of<PlaylistBloc>(
                                          context),
                                      child: AddToPlaylist(
                                        addingsong: favstate.favorite[index],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
              },
            );
          },
        ),
      ),
    );
  }
}
