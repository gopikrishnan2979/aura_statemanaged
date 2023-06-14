import 'package:flutter_bloc/flutter_bloc.dart';

part 'shuffle_state.dart';

//-------------------------------------Shuffle Cubit----------------------------------------

class ShuffleCubit extends Cubit<ShuffleState> {
  ShuffleCubit() : super(ShuffleState(isshuffle: false));

  //toggling shuffling----------------
  void toggleshuffle() => emit(ShuffleState(isshuffle: !state.isshuffle));
}
