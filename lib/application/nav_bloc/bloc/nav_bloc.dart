import 'package:flutter_bloc/flutter_bloc.dart';

part 'nav_event.dart';
part 'nav_state.dart';


//----------------------------- Changing the navigation bar index---------------------------
class NavBloc extends Bloc<NavEvent, NavState> {
  NavBloc() : super(NavState(navindex: 0)) {
    on<NavEvent>((event, emit) {
      return emit(NavState(navindex: event.index));
    });
  }
}
