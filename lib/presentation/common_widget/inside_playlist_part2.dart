import 'package:auramusic/application/favorite_bloc/favorite_bloc.dart';
import 'package:auramusic/application/playlist_bloc/playlist_bloc.dart';
import 'package:auramusic/application/repeat_cubit/repeat_cubit.dart';
import 'package:auramusic/application/shuffle_cubit/shuffle_cubit.dart';
import 'package:auramusic/infrastructure/functions/player_function.dart';
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
    return BlocBuilder<PlaylistBloc, PlaylistState>(
      builder: (context, playliststate) {
        final playlist = playliststate.playlist[currentplaylistindex];
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: listtile(context, index, playliststate),
              ),
              itemCount: playlist.container.length,
            ),
          ),
        );
      },
    );
  }

  listtile(BuildContext context, int idx, PlaylistState playliststate) {
    EachPlaylist playlist = playliststate.playlist[currentplaylistindex];
    return InkWell(
      onTap: () {
        playAudio(songs: playlist.container, index: idx);
        showModalBottomSheet(
            context: context,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            backgroundColor: const Color(0xFF202EAF),
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider.value(
                        value: BlocProvider.of<PlaylistBloc>(context)),
                    BlocProvider.value(
                        value: BlocProvider.of<ShuffleCubit>(context)),
                    BlocProvider.value(
                        value: BlocProvider.of<RepeatCubit>(context))
                  ],
                  child: const MiniPlayer(),
                ));
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
        trailing1: BlocBuilder<FavoriteBloc, FavoriteState>(
          builder: (context, favstate) {
            return FavoriteButton(
              isfav: favstate.favorite.contains(playlist.container[idx]),
              currentSong: playlist.container[idx],
            );
          },
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
                BlocProvider.of<PlaylistBloc>(context).add(
                    PlaylistI.songRemoving(
                        song: playlist.container[idx],
                        playlistIndex: currentplaylistindex));
              }),
        ),
        tilecolor: const Color(0xFF939DF5),
      ),
    );
  }
}
