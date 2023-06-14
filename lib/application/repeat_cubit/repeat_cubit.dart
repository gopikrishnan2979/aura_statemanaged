import 'package:flutter_bloc/flutter_bloc.dart';

part 'repeat_state.dart';


//----------------------------Repeat Cubit-------------------------------
class RepeatCubit extends Cubit<RepeatState> {
  RepeatCubit() : super(RepeatState(isrepeat: false));
  //Repeat toggleing-------------
  void toggleshuffle() => emit(RepeatState(isrepeat: !state.isrepeat));
}
