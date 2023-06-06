import 'dart:async';
import 'package:auramusic/application/music/music_bloc.dart';
import 'package:auramusic/presentation/screens/navigator_scr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<MusicBloc>(context).add(GetAllSongs());
    return BlocListener<MusicBloc, MusicState>(
      listener: (context, state) {
        Timer(const Duration(seconds: 2), () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                    value: BlocProvider.of<MusicBloc>(context),
                    child: NavigatorScrn(),
                  )));
        });
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Image.asset('assets/images/AURA.gif'),
        ),
      ),
    );
  }
}
