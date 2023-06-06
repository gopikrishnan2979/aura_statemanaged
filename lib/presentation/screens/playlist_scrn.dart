import 'package:auramusic/application/music/music_bloc.dart';
import 'package:auramusic/presentation/screens/inside_playlist.dart';
import 'package:auramusic/presentation/screens/mini_player.dart';
import 'package:auramusic/domain/playlist/ui_model/playlist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlaylistScrn extends StatelessWidget {
  const PlaylistScrn({super.key});
  @override
  Widget build(BuildContext context) {
    final GlobalKey rebuildkey = GlobalKey();
    return Scaffold(
      backgroundColor: const Color(0xFF202EB0),
      body: Container(
        key: rebuildkey,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.centerLeft,
            colors: [Color(0xFF000000), Color(0xFF0B0E38), Color(0xFF202EAF)],
          ),
        ),
        child: BlocBuilder<MusicBloc, MusicState>(
          builder: (context, state) {
            if (state.currentlyplaying != null) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                showBottomSheet(
                    context: context,
                    backgroundColor: const Color(0xFF202EAF),
                    builder: (context) => const MiniPlayer());
              });
            }
            return state.playListobjects.isEmpty
                ? playlistempty()
                : gridcard(context, state);
          },
        ),
      ),
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

  Widget gridcard(BuildContext ctx, MusicState state) {
    double paddingsize = MediaQuery.of(ctx).size.width * 0.1;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: MediaQuery.of(ctx).size.width * 0.1,
        mainAxisSpacing: MediaQuery.of(ctx).size.width * 0.1,
      ),
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) => InkWell(
        child: elementgridcard(context, index, state),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: BlocProvider.of<MusicBloc>(context),
              child: InsidePlaylist(
                currentplaylistindex: index,
              ),
            ),
          ));
        },
      ),
      itemCount: state.playListobjects.length,
      padding: EdgeInsets.only(
          bottom: state.playListobjects.length >= 8 ? paddingsize : 20,
          top: paddingsize,
          left: paddingsize,
          right: paddingsize),
    );
  }

  Widget elementgridcard(ctx, index, MusicState state) {
    return Material(
      borderRadius: BorderRadius.circular(10),
      elevation: 3,
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
              right: 0,
              child: Theme(
                data: Theme.of(ctx).copyWith(
                    cardColor: const Color.fromARGB(255, 255, 237, 192)),
                child: PopupMenuButton(
                  onSelected: (value) {
                    value == 1
                        ? renamePlaylist(ctx, index, state)
                        : deletePlaylist(index, ctx);
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  icon: const Icon(Icons.more_vert),
                  itemBuilder: (
                    context,
                  ) =>
                      const [
                    PopupMenuItem(
                      value: 1,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: Text(
                          'Rename',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      value: 2,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: Text(
                          'Delete',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          Positioned(
              bottom: 0,
              child: Container(
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 252, 242, 176),
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
                    state.playListobjects[index].name,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0), fontSize: 18),
                  ),
                ),
              ))
        ],
      ),
    );
  }

  renamePlaylist(BuildContext context, int index, MusicState state) {
    final GlobalKey<FormState> renamekey = GlobalKey();
    var rename = TextEditingController();
    String currentname = state.playListobjects[index].name;
    rename.text = currentname;
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFF9FAC8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        title: const Text('Rename'),
        content: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: Form(
            key: renamekey,
            child: TextFormField(
              controller: rename,
              maxLength: 10,
              decoration: const InputDecoration(
                  filled: true,
                  hintText: 'Enter new name',
                  icon: Icon(Icons.edit),
                  border: InputBorder.none,
                  fillColor: Colors.white),
              validator: (value) {
                if (value == currentname) {
                  return "Newname can't be\nold name";
                }
                if (value == null || value.isEmpty || value.trim().isEmpty) {
                  return 'Name is required';
                }
                value = value.trim();
                for (EachPlaylist element in state.playListobjects) {
                  if (element.name == value) {
                    return 'Name already exist';
                  }
                }
                return null;
              },
              onFieldSubmitted: (value) {
                if (renamekey.currentState!.validate()) {
                  BlocProvider.of<MusicBloc>(context).add(
                      PlaylistEvent.isrenaming(
                          newname: rename.text.trim(), playlistIndex: index));
                  Navigator.pop(context);
                }
              },
            ),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                if (renamekey.currentState!.validate()) {
                  BlocProvider.of<MusicBloc>(context).add(
                      PlaylistEvent.isrenaming(
                          newname: rename.text.trim(), playlistIndex: index));
                  Navigator.pop(context);
                }
              },
              child: const Text('Rename')),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'))
        ],
      ),
    );
  }

  deletePlaylist(int index, BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 168, 204, 248),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        title: const Row(
          children: [
            Icon(
              Icons.delete,
              color: Colors.red,
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text('Delete'),
            ),
          ],
        ),
        content: const Text('Are you sure, You want to delete this playlist?'),
        actions: [
          TextButton(
              onPressed: () {
                //playlist deleting
                BlocProvider.of<MusicBloc>(context)
                    .add(PlaylistEvent.isdeleting(playlistIndex: index));
                Navigator.pop(context);
              },
              child: const Text('Delete')),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'))
        ],
      ),
    );
  }
}
