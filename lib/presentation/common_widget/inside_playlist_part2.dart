import 'package:auramusic/application/music/music_bloc.dart';
import 'package:auramusic/presentation/common_widget/favoritewidget.dart';
import 'package:auramusic/presentation/common_widget/listtilecustom.dart';
import 'package:auramusic/presentation/core/style.dart';
import 'package:auramusic/presentation/screens/mini_player.dart';
import 'package:auramusic/domain/playlist/ui_model/playlist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlaylistInsidePart2 extends StatelessWidget {
  final int currentplaylistindex;
  const PlaylistInsidePart2({super.key, required this.currentplaylistindex});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MusicBloc, MusicState>(
      builder: (context, state) {
        final playlist = state.playListobjects[currentplaylistindex];
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: InkWell(
                  onTap: () {},
                  child: listtile(context, index, state),
                ),
              ),
              itemCount: playlist.container.length,
            ),
          ),
        );
      },
    );
  }

  listtile(BuildContext context, int idx, MusicState state) {
    EachPlaylist playlist = state.playListobjects[currentplaylistindex];
    return InkWell(
      onTap: () {
        BlocProvider.of<MusicBloc>(context)
            .add(PlayingEvent(playlist: playlist.container, playingIndex: idx));
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
          playlist.container[idx].songname ?? 'Unknown',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: songnamefontsize,
            color: fontcolor,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        subtitle: Text(
          playlist.container[idx].artist != null
              ? '${playlist.container[idx].artist}'
              : 'Unknown',
          style: const TextStyle(
              color: fontcolor,
              overflow: TextOverflow.ellipsis,
              fontSize: artistfontsize),
        ),
        trailing1: FavoriteButton(
          isfav: state.favorite.contains(playlist.container[idx]),
          currentSong: playlist.container[idx],
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
                BlocProvider.of<MusicBloc>(context).add(
                    PlaylistEvent.songAddorRemove(
                        songtooperation: playlist.container[idx],
                        playlistIndex: currentplaylistindex,
                        isaddingsong: false,
                        isremovingsong: true));
              }),
        ),
        tilecolor: const Color(0xFF939DF5),
      ),
    );
  }
}
