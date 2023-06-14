import 'package:auramusic/core/data_structure.dart';
import 'package:auramusic/domain/songs/songs.dart';
import 'package:hive_flutter/hive_flutter.dart';


//----------------Adding song to recentlist----------------
Future<List<Songs>> recentadd(
    {required int id, required List<Songs> recentList}) async {
  late Songs song;
  for (Songs element in allsongs) {
    if (element.id == id) {
      song = element;
      break;
    }
  }
  Box<int> recentDb = await Hive.openBox('recent');

  List<int> temp = [];
  temp.addAll(recentDb.values);
  
  if (recentList.contains(song)) {
    //--------------If already song existing in the recent list removing the existing and adding it to the 0th position--------------
    recentList.remove(song);
    recentList.insert(0, song);
    for (int i = 0; i < temp.length; i++) {
      if (song.id == temp[i]) {
        recentDb.deleteAt(i);
        recentDb.add(song.id);
      }
    }
  } else {
    //---------------If song not in the recentlist adding it to the 0th position------------------
    recentList.insert(0, song);
    recentDb.add(song.id);
  }
  //---------------------------Only taking 10 from the list-------------------
  if (recentList.length > 10) {
    recentList = recentList.sublist(0, 10);
    recentDb.deleteAt(0);
  }
  return recentList;
}
