import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:auramusic/screens/homescreen.dart';
import 'package:flutter/material.dart';

class PlayPause extends StatefulWidget {
  const PlayPause({super.key});

  @override
  State<PlayPause> createState() => _PlayPauseState();
}

class _PlayPauseState extends State<PlayPause> {
  @override
  Widget build(BuildContext context) {
    return PlayerBuilder.isPlaying(
      player: player,
      builder: (context, isPlaying) {
        return IconButton(
            onPressed: () async {
              await player.playOrPause();
              setState(() {
                isPlaying = !isPlaying;
              });
            },
            icon: Icon(
              isPlaying ? Icons.pause_circle : Icons.play_circle,
              size: 50,
              color: Colors.white,
            ));
      },
    );
  }
}
