

//Each audio files are changed to object of this class for easy using
class Songs {
  String? songname;
  String? artist;
  int? duration;
  String? songurl;
  int id;
  Songs(
      {required this.songname,
      required this.artist,
      required this.duration,
      required this.id,
      required this.songurl});
}
