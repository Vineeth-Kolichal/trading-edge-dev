import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:trading_edge/app/routes/routes.dart';
import 'package:trading_edge/views/screens/drawer_item_screens/screen_about.dart';
import 'package:trading_edge/views/screens/drawer_item_screens/screen_contact_us.dart';
import 'package:trading_edge/views/screens/drawer_item_screens/screen_terms_of_user.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';

import 'utils/logout_dialoge.dart';
import 'widgets/drawer_header_section.dart';
import 'widgets/drawer_lits_tile.dart';

class WidgetDrawer extends StatelessWidget {
  const WidgetDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: Colors.transparent,
            height: 65,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Divider(),
                  const Text(
                    'Made with ❤️ by Vineeth',
                    style: TextStyle(fontSize: 11),
                  ),
                  FutureBuilder<PackageInfo>(
                    future: PackageInfo.fromPlatform(),
                    builder: (BuildContext context,
                        AsyncSnapshot<PackageInfo> snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                          'Version: ${snapshot.data!.version}',
                          style: const TextStyle(fontSize: 11),
                        );
                      } else {
                        return const Text(
                          'Loading...',
                          style: TextStyle(fontSize: 11),
                        );
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ),
        ListView(
          children: [
            const DrawerHeaderSection(),
            DrawerListTileItem(
              leadingIcon: Iconsax.scroll,
              title: 'About Trading Edge',
              onTapFunction: () {
                Navigator.of(context).pushNamed(Routes.aboutTradingEdge);
              },
            ),
            DrawerListTileItem(
              leadingIcon: Iconsax.info_circle,
              title: 'Terms of use',
              onTapFunction: () {
                Navigator.of(context).pushNamed(Routes.termsOfUse);
               
              },
            ),
            DrawerListTileItem(
              leadingIcon: Iconsax.sms_tracking,
              title: 'Contact us',
              onTapFunction: () {
                 Navigator.of(context).pushNamed(Routes.contactUs);
                
              },
            ),
            DrawerListTileItem(
              leadingIcon: Iconsax.share,
              title: 'Share with friends',
              onTapFunction: () {
                Share.share(
                    'https://play.google.com/store/apps/details?id=com.vineethkolichal.trading_edge');
              },
            ),
            DrawerListTileItem(
              leadingIcon: Iconsax.logout,
              title: 'Logout',
              onTapFunction: () {
                logoutDialoge(context);
              },
            ),
          ],
        ),
      ],
    );
  }
}
