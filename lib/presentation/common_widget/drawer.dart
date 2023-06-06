import 'package:auramusic/presentation/screens/drawerscreens/about_us.dart';
import 'package:auramusic/presentation/screens/drawerscreens/privacy_policy.dart';
import 'package:auramusic/presentation/screens/drawerscreens/terms_and_conditions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    return Drawer(
      backgroundColor: const Color(0xFF0C113F),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: width * 0.05, top: height * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/aura.png',
                    height: height * 0.125,
                  ),
                  SizedBox(
                    height: height * 0.04,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const PrivacyPolicy(),
                      ));
                    },
                    child: const IconTextmerge(
                        icon: FaIcon(
                          FontAwesomeIcons.shieldHalved,
                          color: Colors.white,
                          size: 24,
                        ),
                        text: 'Privacy policy'),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const TermsAndCondition(),
                      ));
                    },
                    child: const IconTextmerge(
                        icon: FaIcon(
                          FontAwesomeIcons.clipboardCheck,
                          color: Colors.white,
                          size: 26,
                        ),
                        text: 'Terms and condiitions'),
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => const AboutUs(),
                      );
                    },
                    child: const IconTextmerge(
                        icon: FaIcon(
                          FontAwesomeIcons.circleInfo,
                          color: Colors.white,
                          size: 23,
                        ),
                        text: 'About us'),
                  ),
                  InkWell(
                    onTap: () {
                      Share.share(
                          '''Check out this awesome app! 
                          https://play.google.com/store/apps/details?id=com.brototype.auramusic''');
                    },
                    child: const IconTextmerge(
                        icon: Icon(
                          Icons.share,
                          size: 25,
                          color: Colors.white,
                        ),
                        text: 'Share'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: height * 0.05),
                  child: const Text(
                    'Version 1.0.0',
                    style: TextStyle(color: Color(0xFF9C9C9C), fontSize: 13),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IconTextmerge extends StatelessWidget {
  final Widget icon;
  final String text;

  const IconTextmerge({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: Row(
        children: [
          icon,
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ],
      ),
    );
  }
}
