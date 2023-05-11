import 'package:auramusic/screens/recent_scrn.dart';
import 'package:auramusic/songs/songs.dart';
import 'package:hive_flutter/hive_flutter.dart';

recentadd(Songs song) async {
  Box<int> recentDb = await Hive.openBox('recent');
  List<int> temp = [];
  temp.addAll(recentDb.values);
  if (recentList.value.contains(song)) {
    recentList.value.remove(song);
    recentList.value.insert(0, song);
    for (int i = 0; i < temp.length; i++) {
      if (song.id == temp[i]) {
        recentDb.deleteAt(i);
        recentDb.add(song.id);
      }
    }
  } else {
    recentList.value.insert(0, song);
    recentDb.add(song.id);
  }
  if (recentList.value.length > 10) {
    recentList.value = recentList.value.sublist(0, 10);
    recentDb.deleteAt(0);
  }
  
}
