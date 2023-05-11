import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF0C113F),
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                height: 80,
                width: MediaQuery.of(context).size.width * 0.3,
                child: Image.asset(
                  'assets/images/aura.png',
                  fit: BoxFit.cover,
                )),
            const Text(
              "AURA is the ultimate music player for those  who love to groove to the rhythm of their favorite tunes .If you are looking for a music player that can handle any genre, any mood, and any occasion, look no further than AURA .AURA is more than a music player. it's your musical companion. Get yours now and feel the beast",
              style: TextStyle(
                  color: Colors.white, fontFamily: 'Peddana', fontSize: 14),
            ),
          ],
        ),
      ),
      actions: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'Created by :- Gopikrishnan Nair S',
              style: TextStyle(
                  color: Colors.white, fontFamily: 'Peddana', fontSize: 13),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    'Contact Developer :-',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Peddana',
                        fontSize: 13),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                InkWell(
                    onTap: () async {
                      final Uri url = Uri.parse(
                          'https://www.linkedin.com/in/gopikrishnan-nair-s-65b914247/');
                      await launchUrl(url,
                          mode: LaunchMode.externalNonBrowserApplication);
                    },
                    child: const FaIcon(
                      FontAwesomeIcons.linkedin,
                      color: Colors.white,
                    )),
                const SizedBox(
                  width: 8,
                ),
                InkWell(
                  onTap: () async {
                    String? encodeQueryParameters(Map<String, String> params) {
                      return params.entries
                          .map((MapEntry<String, String> e) =>
                              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                          .join('&');
                    }

                    final Uri emailLaunchUri = Uri(
                        scheme: 'mailto',
                        path: 'gopikrishnan2979@gmail.com',
                        query: encodeQueryParameters(<String, String>{
                          'subject': 'Aura related query',
                        }));
                    await launchUrl(emailLaunchUri);
                  },
                  child: const FaIcon(
                    FontAwesomeIcons.envelope,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
              ],
            )
          ],
        )
      ],
    );
  }
}
