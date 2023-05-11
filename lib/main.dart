import 'package:auramusic/database/favorite/dbmodel/fav_model.dart';
import 'package:auramusic/database/playlist/playlistmodel/playlist_model.dart';
import 'package:auramusic/screens/splash_screen.dart';
import 'package:flutter/material.dart';
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        primaryColor: const Color(0xFF0B0E38),
        scaffoldBackgroundColor: const Color(0xFF0B0E38),
      ),
      home: const SplashScreen(),
      title: 'AURA',
    );
  }
}
