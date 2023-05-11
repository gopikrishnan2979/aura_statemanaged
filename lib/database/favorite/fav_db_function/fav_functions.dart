import 'package:auramusic/database/favorite/dbmodel/fav_model.dart';
import 'package:auramusic/screens/favorite.dart';
import 'package:auramusic/songs/songs.dart';
import 'package:hive_flutter/hive_flutter.dart';

addfavorite(Songs song) async {
  favorite.value.insert(0, song);
  Box<FavModel> favdb = await Hive.openBox('favorite');
  FavModel temp = FavModel(id: song.id);
  favdb.add(temp);
  favdb.close();
}

removefavorite(Songs song) async {
  favorite.value.remove(song);
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
}
