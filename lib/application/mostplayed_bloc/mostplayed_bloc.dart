import 'package:auramusic/domain/songs/songs.dart';
import 'package:auramusic/infrastructure/database_functions/mostplayed/mostplayed_functions.dart';
import 'package:auramusic/infrastructure/functions/fetch_songs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'mostplayed_event.dart';
part 'mostplayed_state.dart';

//-----------------------------------------Most Played bloc-----------------------------------------------

class MostPlayedBloc extends Bloc<MostPlayedEvent, MostPlayedState> {
  MostPlayedBloc() : super(MostPlayedState(mostPlayedList: [])) {

    //Most Played fetching from database-----------------------
    on<MostPlayedFetch>((event, emit) async {
      List<Songs> data = await mostplayedfetch();
      return emit(MostPlayedState(mostPlayedList: data));
    });

    //Most played counting adding to the database----------------------
    on<MostPlayedAdd>((event, emit) async {
      List<Songs> data = await mostplayedaddtodb(
          id: event.songid, mostPlayedList: state.mostPlayedList);
      return emit(MostPlayedState(mostPlayedList: data));
    });
  }
}
