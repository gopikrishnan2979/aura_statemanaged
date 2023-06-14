import 'package:auramusic/application/favorite_bloc/favorite_bloc.dart';
import 'package:auramusic/application/mostplayed_bloc/mostplayed_bloc.dart';
import 'package:auramusic/application/playlist_bloc/playlist_bloc.dart';
import 'package:auramusic/application/recent_bloc/recent_bloc.dart';
import 'package:auramusic/domain/favmodel/dbmodel/fav_model.dart';
import 'package:auramusic/domain/playlist/hiveplaylistmodel/playlist_model.dart';
import 'package:auramusic/presentation/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:flutter/services.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(FavModelAdapter().typeId)) {
    Hive.registerAdapter(FavModelAdapter());
  }
  if (!Hive.isAdapterRegistered(PlaylistClassAdapter().typeId)) {
    Hive.registerAdapter(PlaylistClassAdapter());
  }
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FavoriteBloc>(
          create: (BuildContext context) => FavoriteBloc(),
        ),
        BlocProvider<MostPlayedBloc>(
          create: (BuildContext context) => MostPlayedBloc(),
        ),
        BlocProvider<RecentBloc>(
          create: (BuildContext context) => RecentBloc(),
        ),
        BlocProvider<PlaylistBloc>(
          create: (BuildContext context) => PlaylistBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          primaryColor: const Color(0xFF0B0E38),
          scaffoldBackgroundColor: const Color(0xFF0B0E38),
        ),
        home: const SplashScreen(),
        title: 'AURA',
      ),
    );
  }
}
