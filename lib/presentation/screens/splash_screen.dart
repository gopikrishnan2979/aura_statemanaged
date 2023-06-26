import 'dart:async';
import 'package:auramusic/application/favorite_bloc/favorite_bloc.dart';
import 'package:auramusic/application/miniplyr_state_bloc/miniplayer_bloc.dart';
import 'package:auramusic/application/mostplayed_bloc/mostplayed_bloc.dart';
import 'package:auramusic/application/nav_bloc/bloc/nav_bloc.dart';
import 'package:auramusic/application/playlist_bloc/playlist_bloc.dart';
import 'package:auramusic/application/recent_bloc/recent_bloc.dart';
import 'package:auramusic/application/repeat_cubit/repeat_cubit.dart';
import 'package:auramusic/application/search_bloc/search_bloc.dart';
import 'package:auramusic/application/shuffle_cubit/shuffle_cubit.dart';
import 'package:auramusic/infrastructure/functions/fetch_songs.dart';
import 'package:auramusic/presentation/screens/navigator_scr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    wait(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Image.asset('assets/images/AURA.gif'),
      ),
    );
  }

  wait(context) async {
    await allsongfetch();
    BlocProvider.of<FavoriteBloc>(context).add(GetAllFavorite());
    BlocProvider.of<PlaylistBloc>(context).add(PlaylistFetch());
    BlocProvider.of<RecentBloc>(context).add(RecentFetch());
    BlocProvider.of<MostPlayedBloc>(context).add(MostPlayedFetch());
    Timer(const Duration(milliseconds: 1500), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: BlocProvider.of<FavoriteBloc>(context),
            ),
            BlocProvider.value(
              value: BlocProvider.of<RecentBloc>(context),
            ),
            BlocProvider.value(
              value: BlocProvider.of<MostPlayedBloc>(context),
            ),
            BlocProvider.value(
              value: BlocProvider.of<PlaylistBloc>(context),
            ),
            BlocProvider(
              create: (context) => NavBloc(),
            ),
            BlocProvider(
              create: (context) => MiniplayerBloc(),
            ),
            BlocProvider(
              create: (context) => SearchBloc(),
            ),
            BlocProvider(
              create: (context) => ShuffleCubit(),
            ),
            BlocProvider(
              create: (context) => RepeatCubit(),
            ),
          ],
          child: NavigatorScrn(),
        ),
      ));
    });
  }
}
