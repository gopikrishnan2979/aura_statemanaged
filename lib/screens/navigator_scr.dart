import 'package:auramusic/common_widget/appbar.dart';
import 'package:auramusic/common_widget/drawer.dart';
import 'package:auramusic/functions/universal_functions.dart';
import 'package:auramusic/screens/favorite.dart';
import 'package:auramusic/screens/homescreen.dart';
import 'package:auramusic/screens/playlist_scrn.dart';
import 'package:auramusic/screens/search.dart';
import 'package:auramusic/songs/playlist.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NavigatorScrn extends StatefulWidget {
  const NavigatorScrn({super.key});
  @override
  State<NavigatorScrn> createState() => _NavigatorScrnState();
}

class _NavigatorScrnState extends State<NavigatorScrn> {
  final List screens = [
    const HomeScreen(),
    const PlaylistScrn(),
    const Favorite(),
    const Search(),
  ];
  List<Color> backgroundcolor = const [
    Color(0xFF202EB0),
    Color(0xFF202EB0),
    Color(0xFF1D2A9D),
    Color(0xFF1C2898),
  ];

  int screenindex = 0;
  @override
  Widget build(BuildContext context) {
    Color color = const Color.fromARGB(255, 104, 197, 255);
    return Container(
      color: const Color(0xFF0B0E38),
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Scaffold(
            backgroundColor: backgroundcolor[screenindex],
            drawer: const DrawerWidget(),
            appBar: PreferredSize(
              preferredSize: Size(MediaQuery.of(context).size.width, 200),
              child: appbarselector(screenindex, context),
            ),
            body: screens[screenindex],
            bottomNavigationBar: CurvedNavigationBar(
              items: [
                FaIcon(FontAwesomeIcons.houseChimney,
                    color: screenindex == 0 ? color : Colors.white),
                Center(
                    child: FaIcon(FontAwesomeIcons.indent,
                        color: screenindex == 1 ? color : Colors.white)),
                FaIcon(
                  Icons.favorite,
                  color: screenindex == 2 ? color : Colors.white,
                ),
                FaIcon(FontAwesomeIcons.magnifyingGlass,
                    color: screenindex == 3 ? color : Colors.white)
              ],
              color: const Color(0xFF0C113F),
              backgroundColor: const Color.fromARGB(0, 0, 0, 0),
              onTap: (index) {
                setState(() {
                  screenindex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget appbarselector(int index, BuildContext ctx) {
    if (index == 0) {
      return GradientAppBar(action: [Image.asset('assets/images/aura.png')]);
    } else if (index == 1) {
      return GradientAppBar(action: [
        IconButton(
            onPressed: () {
              showModalBottomSheet(
                isDismissible: true,
                isScrollControlled: true,
                context: context,
                builder: (context) => Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: showbottomsheetmodel(context)),
              );
            },
            icon: const FaIcon(
              FontAwesomeIcons.solidSquarePlus,
              size: 25,
              color: Colors.white,
            )),
        const Padding(
          padding: EdgeInsets.only(right: 10.0),
          child: Text(
            'PLAYLIST',
            style: TextStyle(color: Colors.white, fontSize: 23),
          ),
        )
      ]);
    } else if (index == 2) {
      return const GradientAppBar(action: [
        Padding(
          padding: EdgeInsets.only(right: 10.0),
          child: Text(
            'FAVORITE',
            style: TextStyle(color: Colors.white, fontSize: 23),
          ),
        )
      ]);
    } else {
      return const GradientAppBar(action: [
        Padding(
          padding: EdgeInsets.only(right: 10.0),
          child: Text(
            'SEARCH',
            style: TextStyle(color: Colors.white, fontSize: 23),
          ),
        )
      ]);
    }
  }

  Widget showbottomsheetmodel(context) {
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
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().isEmpty) {
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
                          playlistcreating(value);
                          Navigator.pop(context);
                          playListNotifier.notifyListeners();
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
                          playlistcreating(playlistName);
                          Navigator.pop(context);
                          playListNotifier.notifyListeners();
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
