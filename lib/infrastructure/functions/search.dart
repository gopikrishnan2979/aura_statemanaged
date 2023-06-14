import 'package:auramusic/core/data_structure.dart';
import 'package:auramusic/domain/songs/songs.dart';


//--------------Searching for songs from the allsongs list----------------
search(String querry) {
  List<Songs> data = allsongs
      .where((element) =>
          element.songname!.toLowerCase().contains(querry.toLowerCase().trim()))
      .toList();
  return data;
}
