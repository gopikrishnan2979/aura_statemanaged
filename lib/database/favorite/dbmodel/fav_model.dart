import 'package:hive_flutter/hive_flutter.dart';
part 'fav_model.g.dart';

@HiveType(typeId: 0)
class FavModel extends HiveObject {
  @HiveField(0)
  int? id;
  FavModel({
    required this.id,
  });
}
