import 'package:flutter_bloc/flutter_bloc.dart';

part 'miniplayer_event.dart';
part 'miniplayer_state.dart';

//Current state of miniplayer is active or not -------------
class MiniplayerBloc extends Bloc<MiniplayerEvent, MiniplayerState> {
  MiniplayerBloc() : super(MiniplayerState(isactive: false)) {
    on<MiniplayerEvent>((event, emit) {
      return emit(MiniplayerState(isactive: true));
    });
  }
}
