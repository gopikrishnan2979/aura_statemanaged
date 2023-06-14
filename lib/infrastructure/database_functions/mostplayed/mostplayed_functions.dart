import 'package:auramusic/core/data_structure.dart';
import 'package:auramusic/domain/songs/songs.dart';
import 'package:hive_flutter/hive_flutter.dart';


//-----------------Adding Song to mostplayed database-------------------
Future<List<Songs>>mostplayedaddtodb(
    {required int id, required List<Songs> mostPlayedList}) async {
  Box<int> mostplayedDb = await Hive.openBox('mostplayed');
  int count = mostplayedDb.get(id)!;
  mostplayedDb.put(id, count + 1);
  return await mostplayedaddtolist(mostPlayedList);
}

//-----------------Clearing all the songs in the mostplayed list and adding new 10 mostplayed song to the list-----------------
Future<List<Songs>> mostplayedaddtolist(List<Songs> mostPlayedList) async {
  Box<int> mostplayedDb = await Hive.openBox('mostplayed');
  //------------clearing the current mostplayed list-------------
  mostPlayedList.clear();
  List<List<int>> mostplayedTemp = [];
  //-----------Adding the Database value into a 2D array for sorting -------------
  for (Songs song in allsongs) {
    int count = mostplayedDb.get(song.id)!;
    mostplayedTemp.add([song.id, count]);
  }

  //--------------Sorting the songs according to the count------------------
  for (int i = 0; i < mostplayedTemp.length - 1; i++) {
    for (int j = i + 1; j < mostplayedTemp.length; j++) {
      if (mostplayedTemp[i][1] < mostplayedTemp[j][1]) {
        List<int> temp = mostplayedTemp[i];
        mostplayedTemp[i] = mostplayedTemp[j];
        mostplayedTemp[j] = temp;
      }
    }
  }

  //-----------Taking the mostplayed 10 songs---------
  List<List<int>> temp = [];
  for (int i = 0; i < mostplayedTemp.length && i < 10; i++) {
    temp.add(mostplayedTemp[i]);
  }
  mostplayedTemp = temp;
  //---------------From that only songs played more than 3 times are taken---------------
  for (List<int> element in mostplayedTemp) {
    for (Songs song in allsongs) {
      if (element[0] == song.id && element[1] > 3) {
        mostPlayedList.add(song);
      }
    }
  }
  return mostPlayedList;
}
