import 'package:auramusic/application/nav_bloc/bloc/nav_bloc.dart';
import 'package:auramusic/application/playlist_bloc/playlist_bloc.dart';
import 'package:auramusic/presentation/common_widget/appbar.dart';
import 'package:auramusic/presentation/common_widget/drawer.dart';
import 'package:auramusic/presentation/screens/favorite.dart';
import 'package:auramusic/presentation/screens/homescreen.dart';
import 'package:auramusic/presentation/screens/playlist_scrn.dart';
import 'package:auramusic/presentation/screens/search.dart';
import 'package:auramusic/domain/playlist/ui_model/playlist.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NavigatorScrn extends StatelessWidget {
  NavigatorScrn({super.key});
  final List screens = [
    const HomeScreen(),
    const PlaylistScrn(),
    const Favorite(),
    const Search(),
  ];

  final List<Color> backgroundcolor = const [
    Color(0xFF202EB0),
    Color(0xFF202EB0),
    Color(0xFF1D2A9D),
    Color(0xFF1C2898),
  ];

  // int screenidndex = 0;

  @override
  Widget build(BuildContext context) {
    Color color = const Color.fromARGB(255, 104, 197, 255);
    return Container(
      color: const Color(0xFF0B0E38),
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: BlocBuilder<NavBloc, NavState>(
            builder: (contextbloc, state) {
              return Scaffold(
                backgroundColor: backgroundcolor[state.navindex],
                drawer: const DrawerWidget(),
                appBar: PreferredSize(
                  preferredSize:
                      Size(MediaQuery.of(contextbloc).size.width, 200),
                  child: appbarselector(
                    state.navindex,
                    context,
                  ),
                ),
                body: screens[state.navindex],
                bottomNavigationBar: CurvedNavigationBar(
                  items: [
                    FaIcon(FontAwesomeIcons.houseChimney,
                        color: state.navindex == 0 ? color : Colors.white),
                    Center(
                        child: FaIcon(FontAwesomeIcons.indent,
                            color: state.navindex == 1 ? color : Colors.white)),
                    FaIcon(
                      Icons.favorite,
                      color: state.navindex == 2 ? color : Colors.white,
                    ),
                    FaIcon(FontAwesomeIcons.magnifyingGlass,
                        color: state.navindex == 3 ? color : Colors.white)
                  ],
                  color: const Color(0xFF0C113F),
                  backgroundColor: const Color.fromARGB(0, 0, 0, 0),
                  onTap: (navidx) {
                    BlocProvider.of<NavBloc>(context)
                        .add(NavEvent(index: navidx));
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget appbarselector(int index, BuildContext context) {
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
                builder: (contex) => Padding(
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

  Widget showbottomsheetmodel(
    BuildContext context,
  ) {
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
                  child: BlocBuilder<PlaylistBloc, PlaylistState>(
                    builder: (context, playliststate) {
                      return Form(
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
                            for (EachPlaylist element
                                in playliststate.playlist) {
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
                              BlocProvider.of<PlaylistBloc>(context).add(
                                  PlaylistE.createnew(
                                      newname: value.trim()));
                              Navigator.pop(context);
                            }
                          },
                        ),
                      );
                    },
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
