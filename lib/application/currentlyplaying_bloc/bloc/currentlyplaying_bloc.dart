import 'package:auramusic/domain/songs/songs.dart';
import 'package:auramusic/infrastructure/functions/player_function.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'currentlyplaying_event.dart';
part 'currentlyplaying_state.dart';

class CurrentlyplayingBloc
    extends Bloc<CurrentlyplayingEvent, CurrentlyplayingState> {
  CurrentlyplayingBloc()
      : super(CurrentlyplayingState(currentlyplaying: null)) {
    //make audio play
    on<PlayingEvent>((event, emit) async {
      Songs data =
          await playAudio(songs: event.playlist, index: event.playingIndex);
      return emit(CurrentlyplayingState(currentlyplaying: data));
    });

    on<CurrentlyplayFind>((event, emit) {
      Songs? data = currentlyplayingfinder(playingId: event.id);
      return emit(CurrentlyplayingState(currentlyplaying: data));
    });
  }
}
