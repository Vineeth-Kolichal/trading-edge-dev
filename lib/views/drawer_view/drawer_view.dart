import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:trading_edge/services/current_user_data.dart';
import 'package:trading_edge/database/firebase/user_profile/user_profile_photo_name_uplaod.dart';
import 'package:trading_edge/drawer_pages/page_about_tradebook.dart';
import 'package:trading_edge/drawer_pages/page_all_users.dart';
import 'package:trading_edge/drawer_pages/page_contact_us.dart';
import 'package:trading_edge/drawer_pages/page_terms_of_user.dart';
import 'package:trading_edge/main.dart';
import 'package:trading_edge/view_model/login_screen_viewmodel/authentication_viewmodel.dart';
import 'package:trading_edge/views/screens/home/screen_home.dart';
import 'package:trading_edge/views/screens/login/screen_login.dart';
import 'package:trading_edge/views/widgets/widget_loading_alert.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';

import 'utils/logout_dialoge.dart';
import 'widgets/drawer_header_section.dart';
import 'widgets/drawer_lits_tile.dart';

class WidgetDrawer extends StatefulWidget {
  const WidgetDrawer({super.key});

  @override
  State<WidgetDrawer> createState() => _WidgetDrawerState();
}

class _WidgetDrawerState extends State<WidgetDrawer> {
  final currentUser = FirebaseAuth.instance.currentUser;

  String? name = '';
  String? mail = '';
  String? imgPath = '';
  String? fireStoreImgPath = '';
  @override
  void initState() {
    setNameImage();
    super.initState();
  }

  void setNameImage() async {
    if (currentUser != null) {
      if (currentUser?.providerData[0].providerId == 'google.com') {
        String username = await getNameFromFirebase();
        String? profileImgUrl = await getImageUrlFromFirebase();
        setState(() {
          name = username;
          mail = currentUser?.email;
          fireStoreImgPath = profileImgUrl;
        });
      }
      if (currentUser?.providerData[0].providerId == 'phone') {
        String username = await getNameFromFirebase();
        String? profileImgUrl = await getImageUrlFromFirebase();
        setState(() {
          name = username;
          mail = currentUser?.phoneNumber;
          fireStoreImgPath = profileImgUrl;
        });
      }
    }
  }

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
            DrawerHeaderSection(fireStoreImgPath: fireStoreImgPath, name: name, mail: mail),
            DrawerListTileItem(
              leadingIcon: Iconsax.scroll,
              title: 'About Trading Edge',
              onTapFunction: () {
                Get.to(() => const PageAboutTradeBokk(),
                    transition: Transition.leftToRight,
                    duration: const Duration(milliseconds: 300));
              },
            ),
            DrawerListTileItem(
              leadingIcon: Iconsax.info_circle,
              title: 'Terms of use',
              onTapFunction: () {
                Get.to(() => const PageTermsOfUser(),
                    transition: Transition.leftToRight,
                    duration: const Duration(milliseconds: 300));
              },
            ),
            DrawerListTileItem(
              leadingIcon: Iconsax.sms_tracking,
              title: 'Contact us',
              onTapFunction: () {
                Get.to(() => const ContactUs(),
                    transition: Transition.leftToRight,
                    duration: const Duration(milliseconds: 300));
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
            Visibility(
              visible: mail == 'vineethchandran5898@gmail.com',
              child: DrawerListTileItem(
                leadingIcon: FeatherIcons.users,
                title: 'View all Users',
                onTapFunction: () {
                  Get.to(() => PageAllUser(),
                      transition: Transition.leftToRight,
                      duration: const Duration(milliseconds: 300));
                },
              ),
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


//Drawer List tile Items- refactored


//Alert shows when user click on the logout button to confirm logout


// Code for the alert box to edit the name


// This function is used ot get name from firebase
  Future<String> getNameFromFirebase() async {
    late String fieldValue;
    final documentRef = FirebaseFirestore.instance
        .collection('users')
        .doc(CurrentUserData.returnCurrentUserId());

    final documentSnapshot = await documentRef.get();

    fieldValue = documentSnapshot['name'];

    return fieldValue;
  }

// This fuction is used to get image url from firebase
  Future<String> getImageUrlFromFirebase() async {
    late String fieldValue;
    final documentRef = FirebaseFirestore.instance
        .collection('users')
        .doc(CurrentUserData.returnCurrentUserId());
    final documentSnapshot = await documentRef.get();
    fieldValue = documentSnapshot['photUrl'];
    return fieldValue;
  }