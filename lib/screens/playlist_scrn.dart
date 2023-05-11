import 'package:auramusic/functions/universal_functions.dart';
import 'package:auramusic/screens/inside_playlist.dart';
import 'package:auramusic/screens/mini_player.dart';
import 'package:auramusic/screens/play_screen.dart';
import 'package:auramusic/songs/playlist.dart';
import 'package:flutter/material.dart';

//Playlist name stored in map as key and value(songs) in list

ValueNotifier<List<EachPlaylist>> playListNotifier = ValueNotifier([]);
const Color fontcolor = Colors.white;
const double artistfontsize = 12;
const double songnamefontsize = 14;

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
        child: ValueListenableBuilder(
            valueListenable: playListNotifier,
            builder: (context, value, child) {
              if (currentlyplaying != null) {
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  showBottomSheet(
                      context: context,
                      backgroundColor: const Color(0xFF202EAF),
                      builder: (context) => const MiniPlayer());
                });
              }
              return playListNotifier.value.isEmpty
                  ? playlistempty()
                  : gridcard(value, context, rebuildkey);
            }),
      ),
    );
  }

  Widget playlistempty() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
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

  Widget gridcard(value, ctx, rebuildkey) {
    double paddingsize = MediaQuery.of(ctx).size.width * 0.1;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: MediaQuery.of(ctx).size.width * 0.1,
        mainAxisSpacing: MediaQuery.of(ctx).size.width * 0.1,
      ),
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) => InkWell(
        child: elementgridcard(context, index, rebuildkey),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => InsidePlaylist(
              currentplaylistindex: index,
            ),
          ));
        },
      ),
      itemCount: playListNotifier.value.length,
      padding: EdgeInsets.only(
          bottom: playListNotifier.value.length >= 8 ? paddingsize : 20,
          top: paddingsize,
          left: paddingsize,
          right: paddingsize),
    );
  }

  Widget elementgridcard(ctx, index, rebuildkey) {
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
                        ? renamePlaylist(ctx, index, rebuildkey)
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
                    playListNotifier.value[index].name,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0), fontSize: 18),
                  ),
                ),
              ))
        ],
      ),
    );
  }

  renamePlaylist(BuildContext context, int index, GlobalKey rebuildkey) {
    final GlobalKey<FormState> renamekey = GlobalKey();
    var rename = TextEditingController();
    String currentname = playListNotifier.value[index].name;
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
                for (EachPlaylist element in playListNotifier.value) {
                  if (element.name == value) {
                    return 'Name already exist';
                  }
                }
                return null;
              },
              onFieldSubmitted: (value) {
                if (renamekey.currentState!.validate()) {
                  playlistrename(index, rename.text.trim());
                  playListNotifier.notifyListeners();

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
                  playlistrename(index, rename.text.trim());
                  playListNotifier.notifyListeners();
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
        title: Row(
          children: const [
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
                playlistdelete(index);
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
