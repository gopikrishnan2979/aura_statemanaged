import 'package:auramusic/common_widget/favoritewidget.dart';
import 'package:auramusic/common_widget/listtilecustom.dart';
import 'package:auramusic/functions/player_function.dart';
import 'package:auramusic/functions/universal_functions.dart';
import 'package:auramusic/screens/favorite.dart';
import 'package:auramusic/screens/mini_player.dart';
import 'package:auramusic/screens/playlist_scrn.dart';
import 'package:auramusic/songs/playlist.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlaylistInsidePart2 extends StatelessWidget {
  final int currentplaylistindex;
  const PlaylistInsidePart2({super.key, required this.currentplaylistindex});

  @override
  Widget build(BuildContext context) {
    final playlist = playListNotifier.value[currentplaylistindex];
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: InkWell(
              onTap: () {},
              child: listtile(context, index, playlist),
            ),
          ),
          itemCount:
              (playListNotifier.value[currentplaylistindex].container).length,
        ),
      ),
    );
  }

  listtile(BuildContext context, int idx, EachPlaylist playlist) {
    return InkWell(
      onTap: () {
        playAudio(playListNotifier.value[currentplaylistindex].container, idx);
        showModalBottomSheet(
            context: context,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            backgroundColor: const Color(0xFF202EAF),
            builder: (context) => const MiniPlayer());
      },
      child: ListTileCustom(
        context: context,
        index: idx,
        leading: QueryArtworkWidget(
          size: 3000,
          quality: 100,
          artworkQuality: FilterQuality.high,
          artworkBorder: BorderRadius.circular(7),
          artworkFit: BoxFit.cover,
          id: playlist.container[idx].id,
          type: ArtworkType.AUDIO,
          nullArtworkWidget: ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: Image.asset(
              'assets/images/Happier.png',
            ),
          ),
        ),
        title: Text(
          playListNotifier
                  .value[currentplaylistindex].container[idx].songname ??
              'Unknown',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: songnamefontsize,
            color: fontcolor,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        subtitle: Text(
          playListNotifier.value[currentplaylistindex].container[idx].artist !=
                  null
              ? '${playListNotifier.value[currentplaylistindex].container[idx].artist}'
              : 'Unknown',
          style: const TextStyle(
              color: fontcolor,
              overflow: TextOverflow.ellipsis,
              fontSize: artistfontsize),
        ),
        trailing1: FavoriteButton(
          isfav: favorite.value.contains(
              playListNotifier.value[currentplaylistindex].container[idx]),
          currentSong:
              playListNotifier.value[currentplaylistindex].container[idx],
        ),
        trailing2: Theme(
          data: Theme.of(context).copyWith(cardColor: const Color(0xFF87BEFF)),
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
                        'Remove from playlist',
                        style: TextStyle(color: Colors.black),
                      ),
                    )
                  ],
              onSelected: (value) {
                playlistremoveDB(
                    playListNotifier.value[currentplaylistindex].container[idx],
                    playlist.name);
                playListNotifier.value[currentplaylistindex].container.remove(
                    playListNotifier
                        .value[currentplaylistindex].container[idx]);
              }),
        ),
        tilecolor: const Color(0xFF939DF5),
      ),
    );
  }
}
