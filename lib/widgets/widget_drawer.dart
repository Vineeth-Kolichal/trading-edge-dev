import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_tradebook/authentication/google_sign_in_authentication.dart';
import 'package:my_tradebook/screens/home/screen_home.dart';
import 'package:my_tradebook/screens/login/screen_login.dart';

class WidgetDrawer extends StatefulWidget {
  WidgetDrawer({super.key});

  @override
  State<WidgetDrawer> createState() => _WidgetDrawerState();
}

class _WidgetDrawerState extends State<WidgetDrawer> {
  final User? _auth = FirebaseAuth.instance.currentUser;
  String? name = '';
  String? mail = '';
  String? imgPath = '';
  @override
  void initState() {
    name = _auth?.displayName;
    mail = _auth?.email;
    imgPath = _auth?.photoURL;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          elevation: 5,
          child: DrawerHeader(
            padding: EdgeInsets.all(0),
            decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/drawer_header_bg.png'))),
            child: Stack(
              children: [
                Positioned(
                  top: 10,
                  left: 10,
                  child: Material(
                    borderRadius: BorderRadius.circular(40),
                    elevation: 5,
                    child: InkWell(
                      onTap: () {
                        scaffoldKey.currentState!.closeDrawer();
                      },
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: Color.fromARGB(255, 235, 232, 232),
                        child: Icon(Icons.arrow_back),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 20,
                  bottom: 40,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 235, 232, 232),
                            borderRadius: BorderRadius.circular(10)),
                        height: 60,
                        width: 60,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(7),
                          child: Image.network(
                            imgPath!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 25,
                  bottom: 20,
                  child: Text(
                    '' + name!,
                    style: TextStyle(fontSize: 17),
                  ),
                ),
                Positioned(
                  left: 25,
                  bottom: 7,
                  child: Text(
                    mail!,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w200),
                  ),
                ),
              ],
            ),
          ),
        ),
        drawerListTileItem(
          leadingIcon: FeatherIcons.book,
          title: 'About My TradeBook',
          onTapFunction: () {},
        ),
        drawerListTileItem(
          leadingIcon: FeatherIcons.alertCircle,
          title: 'Terms of use',
          onTapFunction: () {},
        ),
        drawerListTileItem(
          leadingIcon: FeatherIcons.mail,
          title: 'Contact us',
          onTapFunction: () {},
        ),
        drawerListTileItem(
          leadingIcon: FeatherIcons.share2,
          title: 'Share with friends',
          onTapFunction: () {},
        ),
        drawerListTileItem(
          leadingIcon: FeatherIcons.pieChart,
          title: 'Position sizing',
          onTapFunction: () {},
        ),
        drawerListTileItem(
          leadingIcon: FeatherIcons.logOut,
          title: 'Logout',
          onTapFunction: () async {
            //await _googleSignIn.signOut();
            GoogleSignInProvider provider = GoogleSignInProvider();
            provider.googleSignOut();

            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (((context) => ScreenLogin()))));
          },
        ),
        Expanded(
          child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 60,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Divider(),
                        Text(
                          'Made with ❤️ by Vineeth',
                          style: TextStyle(fontSize: 11),
                        ),
                        Text('Version :', style: TextStyle(fontSize: 11))
                      ]),
                ),
              )),
        ),
      ],
    );
  }
}

Widget drawerListTileItem(
    {required IconData leadingIcon,
    required String title,
    required onTapFunction()}) {
  return ListTile(
    onTap: onTapFunction,
    leading: Icon(
      leadingIcon,
      fill: 0,
    ),
    title: Text(title),
  );
}
