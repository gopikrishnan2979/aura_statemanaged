import 'package:auramusic/application/music/music_bloc.dart';
import 'package:flutter/material.dart';
import 'package:auramusic/domain/songs/songs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class FavoriteButton extends StatelessWidget {
  bool isfav = false;

  final Songs currentSong;
  final Color? color;
  final double? size;
  FavoriteButton(
      {super.key,
      required this.currentSong,
      required this.isfav,
      this.color,
      this.size});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MusicBloc, MusicState>(
      builder: (context, state) {
        return InkWell(
            onTap: () {
              if (!state.favorite.contains(currentSong)) {
                isfav = true;
                BlocProvider.of<MusicBloc>(context)
                    .add(FavoriteEvent(song: currentSong,isAdding: true));
                snackbar(text: 'Added to liked', color: Colors.green,context: context);
              } else {
                BlocProvider.of<MusicBloc>(context)
                    .add(FavoriteEvent(song: currentSong,isRemoving: true));
                isfav = false;
                snackbar(text: 'Removed from liked', color: Colors.red,context: context);
              }
            },
            child: Icon(
              isfav ? Icons.favorite : Icons.favorite_border_rounded,
              color: isfav
                  ? const Color(0xFF00FF08)
                  : color ?? const Color.fromARGB(255, 255, 255, 255),
              size: size ?? 25,
            ));
      },
    );
  }

//liked snackbar
  snackbar({required String text, required Color color,required BuildContext context}) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(
        duration: const Duration(milliseconds: 800),
        margin: const EdgeInsets.only(left: 30, right: 30, bottom: 40),
        behavior: SnackBarBehavior.floating,
        content: Text(text),
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ));
  }
}
