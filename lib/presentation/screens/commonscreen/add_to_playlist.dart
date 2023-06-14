import 'package:auramusic/application/playlist_bloc/playlist_bloc.dart';
import 'package:auramusic/domain/playlist/ui_model/playlist.dart';
import 'package:auramusic/domain/songs/songs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddToPlaylist extends StatelessWidget {
  final Songs addingsong;
  const AddToPlaylist({super.key, required this.addingsong});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.centerLeft,
            colors: [Color(0xFF000000), Color(0xFF0B0E38), Color(0xFF202EAF)],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.height * 0.01,
                  right: MediaQuery.of(context).size.height * 0.04),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.09,
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 30,
                        )),
                    const Text(
                      'ADD TO PLAYLIST',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    const Spacer(),
                    BlocBuilder<PlaylistBloc, PlaylistState>(
                      builder: (context, playliststate) {
                        return IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                isDismissible: true,
                                isScrollControlled: true,
                                context: context,
                                builder: (context) => Padding(
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom),
                                    child: showbottomsheetmodel(
                                      context,playliststate.playlist
                                    )),
                              );
                            },
                            icon: const FaIcon(
                              FontAwesomeIcons.solidSquarePlus,
                              size: 25,
                              color: Colors.white,
                            ));
                      },
                    )
                  ],
                ),
              ),
            ),
            BlocBuilder<PlaylistBloc, PlaylistState>(
              builder: (context, state) {
                return Expanded(
                  child: state.playlist.isEmpty
                      ? playlistempty()
                      : gridcard(state, context),
                );
              },
            )
          ],
        ),
      )),
    );
  }

  Widget playlistempty() {
    return const Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.hourglass_empty,
            color: Colors.grey,
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              'Playlist is empty',
              style: TextStyle(fontSize: 25, color: Colors.grey),
            ),
          )
        ],
      ),
    );
  }

  Widget gridcard(PlaylistState state, BuildContext ctx) {
    double paddingsize = MediaQuery.of(ctx).size.width * 0.1;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: MediaQuery.of(ctx).size.width * 0.1,
        mainAxisSpacing: MediaQuery.of(ctx).size.width * 0.1,
      ),
      itemBuilder: (context, index) => elementgridcard(context, index, state),
      itemCount: state.playlist.length,
      padding: EdgeInsets.only(
          bottom: state.playlist.length >= 8 ? paddingsize : 20,
          top: paddingsize,
          left: paddingsize,
          right: paddingsize),
    );
  }

  Widget elementgridcard(BuildContext ctx, int index, PlaylistState state) {
    return Material(
      borderRadius: BorderRadius.circular(10),
      elevation: 3,
      child: InkWell(
        onTap: () {
          if (!state.playlist[index].container.contains(addingsong)) {
            // playListNotifier.value[index].container.add(addingsong);
            BlocProvider.of<PlaylistBloc>(ctx).add(PlaylistI.songAdding(
                song: addingsong,
                playlistIndex: index,));
            ScaffoldMessenger.of(ctx)
              ..removeCurrentSnackBar()
              ..showSnackBar(SnackBar(
                  duration: const Duration(milliseconds: 800),
                  margin:
                      const EdgeInsets.only(left: 30, right: 30, bottom: 40),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.green,
                  content: Center(
                      child: Text(
                          'Song Added to ${state.playlist[index].name}'))));
          } else {
            ScaffoldMessenger.of(ctx)
              ..removeCurrentSnackBar()
              ..showSnackBar(const SnackBar(
                  duration: Duration(milliseconds: 800),
                  margin: EdgeInsets.only(left: 30, right: 30, bottom: 40),
                  behavior: SnackBarBehavior.floating,
                  content: Center(child: Text('Song already exist'))));
          }
          Navigator.pop(ctx);
        },
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/images/playlistbg.png',
                width: MediaQuery.of(ctx).size.width * 0.35,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
                bottom: 0,
                child: Container(
                  decoration: const BoxDecoration(
                      color: Color(0xFF9FE0C5),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                  width: MediaQuery.of(ctx).size.width * 0.35,
                  height: MediaQuery.of(ctx).size.width * 0.11,
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(ctx).size.width * 0.015,
                        left: MediaQuery.of(ctx).size.width * 0.05),
                    child: Text(
                      state.playlist[index].name,
                      style: const TextStyle(
                          color: Color(0xFF0812FF), fontSize: 18),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget showbottomsheetmodel(context, List<EachPlaylist> playlist) {
    final GlobalKey<FormState> playlistformkey = GlobalKey();
    var playlistController = TextEditingController();

    double height = MediaQuery.of(context).size.height * 0.05;
    return SingleChildScrollView(
      child: Container(
        color: const Color(0xFFF9FAC8),
        child: Padding(
          padding: EdgeInsets.all(height),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Make playlist, Have fun',
                    style: TextStyle(fontSize: 23, color: Color(0xFF75807B)),
                  ),
                  ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/images/smileimgyellow.png',
                        width: 60,
                      ))
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  height: 70,
                  child: Form(
                    key: playlistformkey,
                    child: TextFormField(
                      autofocus: true,
                      keyboardType: TextInputType.name,
                      controller: playlistController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Name is required';
                        }
                        value = value.trim();
                        for (EachPlaylist element in playlist) {
                          if (element.name == value) {
                            return 'Name already exist';
                          }
                        }
                        return null;
                      },
                      style: const TextStyle(fontSize: 19),
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          hintText: 'Enter the name',
                          hintStyle: TextStyle(fontSize: 19),
                          fillColor: Colors.white),
                      maxLength: 10,
                      onFieldSubmitted: (value) {
                        if (playlistformkey.currentState!.validate()) {
                          BlocProvider.of<PlaylistBloc>(context)
                              .add(PlaylistE.createnew(newname: value));
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.5,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: 110,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF375EE8)),
                      onPressed: () {
                        String playlistName = playlistController.text.trim();
                        if (playlistformkey.currentState!.validate()) {
                          BlocProvider.of<PlaylistBloc>(context).add(
                              PlaylistE.createnew(newname: playlistName));
                          Navigator.pop(context);
                        }
                      },
                      child: const Text(
                        'CREATE',
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
