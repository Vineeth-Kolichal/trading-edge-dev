import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trading_edge/views/widgets/widget_appbar.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 238, 247),
      appBar: const WidgetAppbar(title: 'Contact Us'),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Connect with Developer',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
            ),
            const Divider(),
            InkWell(
              onTap: () async {
                await launchUrl(Uri.https('github.com', '/Vineeth-Kolichal'));
              },
              child: const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: FaIcon(FontAwesomeIcons.github),
                  ),
                  Text('GitHub'),
                ],
              ),
            ),
            InkWell(
              onTap: () async {
                await launchUrl(Uri.https(
                    'www.linkedin.com', '/in/vineeth-chandran-kolichal'));
              },
              child: const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: FaIcon(FontAwesomeIcons.linkedinIn),
                  ),
                  Text('LinkedIn'),
                ],
              ),
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
                  path: 'vineethchandran5898@gmail.com',
                  query: encodeQueryParameters(<String, String>{
                    'subject': 'Tradebook app related query',
                  }),
                );
                await launchUrl(emailLaunchUri);
              },
              child: const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.mail_outline),
                  ),
                  Text('G mail'),
                ],
              ),
            ),
            InkWell(
              onTap: () async {
                await launchUrl(
                    Uri.https('www.instagram.com', '/vineeth.kolichal'));
              },
              child: const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: FaIcon(FontAwesomeIcons.instagram),
                  ),
                  Text('Instagram'),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
