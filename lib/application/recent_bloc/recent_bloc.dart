import 'package:auramusic/domain/songs/songs.dart';
import 'package:auramusic/infrastructure/database_functions/recent/recently_played.dart';
import 'package:auramusic/infrastructure/functions/fetch_songs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'recent_event.dart';
part 'recent_state.dart';

class RecentBloc extends Bloc<RecentEvent, RecentState> {
  RecentBloc() : super(RecentState(recentlist: [])) {
    on<RecentFetch>((event, emit) async {
      List<Songs> data = await recentfetch();
      return emit(RecentState(recentlist: data));
    });
    on<RecentAdd>((event, emit) async {
      List<Songs> data =
          await recentadd(song: event.song, recentList: state.recentlist);
      return emit(RecentState(recentlist: data));
    });
  }
}
