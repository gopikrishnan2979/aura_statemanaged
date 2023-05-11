import 'package:auramusic/database/favorite/fav_db_function/fav_functions.dart';
import 'package:auramusic/screens/favorite.dart';
import 'package:auramusic/screens/most_played_scrn.dart';
import 'package:auramusic/screens/playlist_scrn.dart';
import 'package:auramusic/screens/recent_scrn.dart';
import 'package:flutter/material.dart';
import 'package:auramusic/songs/songs.dart';

// ignore: must_be_immutable
class FavoriteButton extends StatefulWidget {
  bool isfav = false;
  Songs currentSong;
  Color? color;
  double? size;
  FavoriteButton(
      {super.key,
      required this.isfav,
      required this.currentSong,
      this.color,
      this.size});

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          setState(() {
            if (!favorite.value.contains(widget.currentSong)) {
              widget.isfav = true;
              addfavorite(widget.currentSong);
              snackbar(text: 'Added to liked', color: Colors.green);
            } else {
              removefavorite(widget.currentSong);
              widget.isfav = false;
              snackbar(text: 'Removed from liked', color: Colors.red);
            }
            if (widget.color != null) {
              recentList.notifyListeners();
              mostPlayedList.notifyListeners();
              playListNotifier.notifyListeners();
            }
            favorite.notifyListeners();
          });
        },
        child: Icon(
          widget.isfav ? Icons.favorite : Icons.favorite_border_rounded,
          color: widget.isfav
              ? const Color(0xFF00FF08)
              : widget.color ?? const Color.fromARGB(255, 255, 255, 255),
          size: widget.size ?? 25,
        ));
  }

//liked snackbar
  snackbar({required String text, required color}) {
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
