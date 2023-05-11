import 'package:auramusic/common_widget/favoritewidget.dart';
import 'package:auramusic/common_widget/listtilecustom.dart';
import 'package:auramusic/functions/player_function.dart';
import 'package:auramusic/screens/commonscreen/add_to_playlist.dart';
import 'package:auramusic/screens/mini_player.dart';
import 'package:auramusic/screens/play_screen.dart';
import 'package:auramusic/screens/playlist_scrn.dart';
import 'package:auramusic/songs/songs.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

ValueNotifier<List<Songs>> favorite = ValueNotifier([]);

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
          child: ValueListenableBuilder(
            valueListenable: favorite,
            builder: (context, value, child) {
              if (currentlyplaying != null) {
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  showBottomSheet(
                      context: context,
                      backgroundColor: const Color(0xFF202EAF),
                      builder: (context) => const MiniPlayer());
                });
              }
              return favorite.value.isEmpty
                  ? const Center(
                      child: Text(
                        'Favorite List is empty',
                        style: TextStyle(fontSize: 20, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                      itemCount: favorite.value.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) => InkWell(
                        onTap: () {
                          playAudio(favorite.value, index);
                          favorite.notifyListeners();
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
                            id: favorite.value[index].id,
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
                            favorite.value[index].songname ?? 'Unknown',
                            style: const TextStyle(
                                color: fontcolor,
                                fontWeight: FontWeight.bold,
                                fontSize: songnamefontsize,
                                overflow: TextOverflow.ellipsis),
                          ),
                          subtitle: Text(
                            favorite.value[index].artist != null
                                ? '${favorite.value[index].artist}'
                                : 'Unknown',
                            style: const TextStyle(
                                color: fontcolor,
                                overflow: TextOverflow.ellipsis,
                                fontSize: artistfontsize),
                          ),
                          trailing1: FavoriteButton(
                            isfav: true,
                            currentSong: favorite.value[index],
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
                                builder: (context) => AddToPlaylist(
                                    addingsong: favorite.value[index]),
                              )),
                            ),
                          ),
                        ),
                      ),
                    );
            },
          )),
    );
  }
}
