import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_tradebook/authentication/get_current_user_id.dart';
import 'package:my_tradebook/authentication/google_sign_in_authentication.dart';
import 'package:my_tradebook/database/firebase/user_profile/user_profile_photo_name_uplaod.dart';
import 'package:my_tradebook/database/local_databse/db_functions/user_name_and_image.dart';
import 'package:my_tradebook/database/local_databse/models/user_model.dart';
import 'package:my_tradebook/drawer_pages/page_about_tradebook.dart';
import 'package:my_tradebook/drawer_pages/page_contact_us.dart';
import 'package:my_tradebook/drawer_pages/page_terms_of_user.dart';
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
  final currentUser = FirebaseAuth.instance.currentUser;

  String? name = '';
  String? mail = '';
  String? imgPath = '';
  String? fireStoreImgPath = '';
  Uint8List? localImgBytes;
  String? localImgPath;
  @override
  void initState() {
    setNameImage();
    super.initState();
  }

  void setNameImage() async {
    if (currentUser != null) {
      if (currentUser?.providerData[0].providerId == 'google.com') {
        setState(() {
          name = currentUser?.displayName;
          mail = currentUser?.email;
          imgPath = currentUser?.photoURL;
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

  Future<void> pickImage() async {
    final imagePicked =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imagePicked != null) {
      final temp = await imagePicked.readAsBytes();
      setState(() {
        localImgBytes = temp;
      });
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
                          if (currentUser?.providerData[0].providerId !=
                              'google.com') {
                            final imgurl =
                                await pickAndUploadImageToFirebaseStorage();
                            await updateImageUrl(imgurl);
                            // await pickImage();
                            //  await updateUserImage(localImgBytes!);
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
                            child: (currentUser?.providerData[0].providerId ==
                                    'google.com')
                                ? Image.network(imgPath!, fit: BoxFit.cover)
                                : ((fireStoreImgPath == null)
                                    ? Image.asset(
                                        'assets/images/user_image_drawer.png',
                                        fit: BoxFit.cover)
                                    : Image.network(fireStoreImgPath!,
                                        fit: BoxFit.cover)),
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
                      Text(
                        name!,
                        style: const TextStyle(fontSize: 17),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Visibility(
                          visible: (currentUser?.providerData[0].providerId ==
                              'phone'),
                          child: InkWell(
                            onTap: () {
                              editNameDialoge();
                              scaffoldKey.currentState!.closeDrawer();
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
          onTapFunction: () {
            Get.to(() => const PageAboutTradeBokk());
          },
        ),
        drawerListTileItem(
          leadingIcon: FeatherIcons.alertCircle,
          title: 'Terms of use',
          onTapFunction: () {
            Get.to(() => const PageTermsOfUser());
          },
        ),
        drawerListTileItem(
          leadingIcon: FeatherIcons.mail,
          title: 'Contact us',
          onTapFunction: () {
            Get.to(() => const ContactUs());
          },
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
            child: SizedBox(
              height: 60,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Divider(),
                    Text(
                      'Made with ❤️ by Vineeth',
                      style: TextStyle(fontSize: 11),
                    ),
                    Text('Version :', style: TextStyle(fontSize: 11))
                  ],
                ),
              ),
            ),
          ),
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
                  side: const BorderSide(color: Colors.deepPurple),
                ),
              ),
            ),
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
    final formGlobalKey = GlobalKey<FormState>();
    UserModel? user = await getUserNameAndImage(returnCurrentUserId());
    TextEditingController nameController = TextEditingController();
    final name = user?.name;
    nameController.text = name!;
    Get.dialog(AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        'Edit Name',
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
      ),
      content: Form(
        key: formGlobalKey,
        child: TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your name ';
            }
            return null;
          },
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
          controller: nameController,
        ),
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
                side: const BorderSide(color: Colors.deepPurple),
              ),
            ),
          ),
          child: const Text(
            "Update",
            style: TextStyle(color: Colors.black),
          ),
          onPressed: () {
            if (formGlobalKey.currentState!.validate()) {
              updateUserName(nameController.text);
              Get.back();
            }
          },
        ),
      ],
    ));
  }
}

Widget drawerListTileItem(
    {required IconData leadingIcon,
    required String title,
    required Function() onTapFunction}) {
  return ListTile(
    onTap: onTapFunction,
    leading: Icon(
      leadingIcon,
      fill: 0,
    ),
    title: Text(title),
  );
}

void editNameDialoge() async {
  UserModel? user = await getUserNameAndImage(returnCurrentUserId());
  TextEditingController nameController = TextEditingController();
  final name = user?.name;
  nameController.text = name!;
  Get.dialog(AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    title: const Text(
      'Edit Name',
      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
    ),
    content: TextFormField(
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
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
                    side: const BorderSide(color: Colors.deepPurple)))),
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
