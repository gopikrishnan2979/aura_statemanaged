import 'package:auramusic/common_widget/favoritewidget.dart';
import 'package:auramusic/common_widget/listtilecustom.dart';
import 'package:auramusic/functions/player_function.dart';
import 'package:auramusic/screens/commonscreen/add_to_playlist.dart';
import 'package:auramusic/screens/favorite.dart';
import 'package:auramusic/screens/mini_player.dart';
import 'package:auramusic/screens/playlist_scrn.dart';
import 'package:auramusic/songs/songs.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

ValueNotifier<List<Songs>> mostPlayedList = ValueNotifier([]);

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
                            playListNotifier.notifyListeners();
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
              Expanded(
                child: mostPlayedList.value.isEmpty
                    ? songlistempty()
                    : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, top: 10, bottom: 30),
                        itemBuilder: (context, index) => InkWell(
                          onTap: () {
                            playAudio(mostPlayedList.value, index);
                            showModalBottomSheet(
                                enableDrag: false,
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
                              artworkBorder: BorderRadius.circular(7),
                              artworkFit: BoxFit.cover,
                              id: mostPlayedList.value[index].id,
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
                              mostPlayedList.value[index].songname!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: songnamefontsize,
                                  overflow: TextOverflow.ellipsis,
                                  color: fontcolor),
                            ),
                            subtitle: Text(mostPlayedList.value[index].artist!,
                                style: const TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: artistfontsize,
                                    color: fontcolor)),
                            trailing1: FavoriteButton(
                                isfav: favorite.value
                                    .contains(mostPlayedList.value[index]),
                                currentSong: mostPlayedList.value[index]),
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
                                      child: Text('Add to playlist'))
                                ],
                                onSelected: (value) => Navigator.of(context)
                                    .push(MaterialPageRoute(
                                  builder: (context) => AddToPlaylist(
                                      addingsong: mostPlayedList.value[index]),
                                )),
                              ),
                            ),
                          ),
                        ),
                        itemCount: mostPlayedList.value.length,
                      ),
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
