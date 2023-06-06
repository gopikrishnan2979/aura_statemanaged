import 'package:auramusic/domain/favmodel/dbmodel/fav_model.dart';
import 'package:auramusic/domain/songs/songs.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<List<Songs>>addfavorite(Songs song) async {
  List<Songs> favorite = [];
  favorite.insert(0, song);
  Box<FavModel> favdb = await Hive.openBox('favorite');
  FavModel temp = FavModel(id: song.id);
  favdb.add(temp);
  favdb.close();
  return favorite;
}

removefavorite(Songs song) async {
  List<Songs> favorite = [];
  favorite.remove(song);
  List<FavModel> templist = [];
  Box<FavModel> favdb = await Hive.openBox('favorite');
  templist.addAll(favdb.values);
  for (var element in templist) {
    if (element.id == song.id) {
      var key = element.key;
      favdb.delete(key);
      break;
    }
  }
  return favorite;
}
