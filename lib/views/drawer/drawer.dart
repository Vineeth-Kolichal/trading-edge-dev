import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:my_tradebook/core/constants/colors.dart';
import 'package:my_tradebook/views/drawer/widgets/drawer_list_tile.dart';
import 'package:my_tradebook/views/drawer_pages/page_about_tradebook.dart';
import 'package:my_tradebook/views/drawer_pages/page_contact_us.dart';
import 'package:my_tradebook/views/drawer_pages/page_terms_of_user.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'widgets/logout_alert.dart';
import 'widgets/profile_secrion.dart';

class WidgetDrawer extends StatelessWidget {
  const WidgetDrawer({super.key});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: whiteColor,
            height: 60,
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
            ProfileSection(),
            DrawerListTile(
              leadingIcon: FeatherIcons.book,
              title: 'About My TradeBook',
              onTapFunction: () {
                Get.to(
                  () => const PageAboutTradeBokk(),
                  transition: Transition.leftToRight,
                );
              },
            ),
            DrawerListTile(
              leadingIcon: FeatherIcons.alertCircle,
              title: 'Terms of use',
              onTapFunction: () {
                Get.to(
                  () => const PageTermsOfUser(),
                  transition: Transition.leftToRight,
                );
              },
            ),
            DrawerListTile(
              leadingIcon: FeatherIcons.mail,
              title: 'Contact us',
              onTapFunction: () {
                Get.to(
                  () => const ContactUs(),
                  transition: Transition.leftToRight,
                );
              },
            ),
            DrawerListTile(
              leadingIcon: FeatherIcons.share2,
              title: 'Share with friends',
              onTapFunction: () {
                Share.share(
                    'https://play.google.com/store/apps/details?id=com.vineethkolichal.my_tradebook');
              },
            ),
            DrawerListTile(
              leadingIcon: FeatherIcons.logOut,
              title: 'Logout',
              onTapFunction: () {
                openDialog();
              },
            ),
          ],
        ),
      ],
    );
  }
}
