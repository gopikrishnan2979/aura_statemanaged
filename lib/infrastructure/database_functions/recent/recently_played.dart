import 'package:auramusic/domain/songs/songs.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<List<Songs>>recentadd({required Songs song, required List<Songs> recentList}) async {
  Box<int> recentDb = await Hive.openBox('recent');

  List<int> temp = [];
  temp.addAll(recentDb.values);
  if (recentList.contains(song)) {
    recentList.remove(song);
    recentList.insert(0, song);
    for (int i = 0; i < temp.length; i++) {
      if (song.id == temp[i]) {
        recentDb.deleteAt(i);
        recentDb.add(song.id);
      }
    }
  } else {
    recentList.insert(0, song);
    recentDb.add(song.id);
  }
  if (recentList.length > 10) {
    recentList = recentList.sublist(0, 10);
    recentDb.deleteAt(0);
  }
  return recentList;
}
