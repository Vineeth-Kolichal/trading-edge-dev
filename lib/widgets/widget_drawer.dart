import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_tradebook/authentication/get_current_user_id.dart';
import 'package:my_tradebook/authentication/google_sign_in_authentication.dart';
import 'package:my_tradebook/authentication/phone_authentication.dart';
import 'package:my_tradebook/database/local_databse/db_functions/user_name_and_image.dart';
import 'package:my_tradebook/database/local_databse/models/user_model.dart';
import 'package:my_tradebook/main.dart';
import 'package:my_tradebook/screens/home/screen_home.dart';
import 'package:my_tradebook/screens/login/screen_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WidgetDrawer extends StatefulWidget {
  const WidgetDrawer({super.key});

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
    setNameImage();
    super.initState();
  }

  void setNameImage() async {
    UserModel? user = await getUserNameAndImage(returnCurrentUserId());
    if (_auth?.email == null) {
      setState(() {
        name = user?.name;
        imgPath = user?.imagePath;
        mail = _auth?.phoneNumber;
      });
    } else {
      name = (_auth?.displayName == null) ? name : _auth?.displayName;
      mail = (_auth?.email == null) ? _auth?.phoneNumber : _auth?.email;
      imgPath = (_auth?.photoURL == null) ? imgPath : _auth?.photoURL;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          elevation: 5,
          child: DrawerHeader(
            padding: const EdgeInsets.all(0),
            decoration: const BoxDecoration(
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
                      child: const CircleAvatar(
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
                      child: InkWell(
                        onTap: () async {
                          if (_auth?.email == null) {
                            final ImagePicker _picker = ImagePicker();
                            final XFile? image = await _picker.pickImage(
                                source: ImageSource.gallery);
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 235, 232, 232),
                              borderRadius: BorderRadius.circular(10)),
                          height: 60,
                          width: 60,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(7),
                            child: (_auth?.photoURL == null)
                                ? Image.asset(
                                    'assets/images/user_image_drawer.png')
                                : Image.network(
                                    imgPath!,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 25,
                  bottom: 20,
                  child: Row(
                    children: [
                      GetBuilder<EditUserName>(
                        init: EditUserName(),
                        builder: (_) => Text(
                          name!,
                          style: const TextStyle(fontSize: 17),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Visibility(
                          visible: (_auth?.email == null),
                          child: InkWell(
                            onTap: () {
                              EditUserName eun = EditUserName();
                              eun.editNameDialoge();
                            },
                            child: const Icon(
                              Icons.edit,
                              size: 15,
                              color: Color.fromARGB(255, 145, 144, 144),
                            ),
                          ))
                    ],
                  ),
                ),
                Positioned(
                  left: 25,
                  bottom: 7,
                  child: Text(
                    mail!,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w200),
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
            final SharedPreferences shared =
                await SharedPreferences.getInstance();
            shared.remove(currentUserId);
            openDialog();
            // Navigator.of(context).pushReplacement(
            //     MaterialPageRoute(builder: (((context) => ScreenLogin()))));
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

  void openDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 5,
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure want to logout?'),
        actions: [
          ElevatedButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ))),
            child: const Text("Cancel"),
            onPressed: () => Get.back(),
          ),
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.deepPurple)))),
            child: const Text(
              "Confirm",
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () => Get.offAll(ScreenLogin()),
          ),
        ],
      ),
    );
  }

  void editNameDialoge() async {
    UserModel? user = await getUserNameAndImage(returnCurrentUserId());
    TextEditingController nameController = TextEditingController();
    final name = user?.name;
    nameController.text = name!;
    Get.dialog(AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        'Edit Name',
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
      ),
      content: TextFormField(
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
        controller: nameController,
      ),
      actions: [
        ElevatedButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ))),
          child: const Text("Cancel"),
          onPressed: () => Get.back(),
        ),
        ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.deepPurple)))),
          child: const Text(
            "Update",
            style: TextStyle(color: Colors.black),
          ),
          onPressed: () {
            updateUserName(nameController.text);
            Get.back();
          },
        ),
      ],
    ));
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

class EditUserName extends GetxController {
  void editNameDialoge() async {
    UserModel? user = await getUserNameAndImage(returnCurrentUserId());
    TextEditingController nameController = TextEditingController();
    final name = user?.name;
    nameController.text = name!;
    Get.dialog(AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        'Edit Name',
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
      ),
      content: TextFormField(
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
        controller: nameController,
      ),
      actions: [
        ElevatedButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ))),
          child: const Text("Cancel"),
          onPressed: () => Get.back(),
        ),
        ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.deepPurple)))),
          child: const Text(
            "Update",
            style: TextStyle(color: Colors.black),
          ),
          onPressed: () {
            updateUserName(nameController.text);
            Get.back();
            update();
          },
        ),
      ],
    ));
  }
}
