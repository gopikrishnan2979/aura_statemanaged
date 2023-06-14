import 'package:auramusic/infrastructure/functions/search.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auramusic/domain/songs/songs.dart';

part 'search_event.dart';
part 'search_state.dart';


//--------------------------------------Search Bloc--------------------------------------------

class SearchBloc extends Bloc< SearchEvent, SearchState> {
  SearchBloc() : super(SearchState(searchdata: [])) {

    //Searching -------------------
    on<SearchEvent>((event, emit) {
      List<Songs> searchdata = search(event.querry);
      return emit(SearchState(searchdata: searchdata));
    });
  }
}
