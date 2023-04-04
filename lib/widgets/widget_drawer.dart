import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:my_tradebook/authentication/get_current_user_id.dart';
import 'package:my_tradebook/authentication/google_sign_in_authentication.dart';
import 'package:my_tradebook/database/firebase/user_profile/user_profile_photo_name_uplaod.dart';
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
            color: whiteColor,
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
        ListView(
          children: [
            Material(
              elevation: 3,
              child: DrawerHeader(
                padding: const EdgeInsets.all(0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/drawer_header_bg.png'),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Material(
                      //   borderRadius: BorderRadius.circular(40),
                      //   elevation: 5,
                      //   child: InkWell(
                      //     onTap: () {
                      //       scaffoldKey.currentState!.closeDrawer();
                      //     },
                      //     child: const CircleAvatar(
                      //       radius: 15,
                      //       backgroundColor: Color.fromARGB(255, 235, 232, 232),
                      //       child: Icon(Icons.arrow_back),
                      //     ),
                      //   ),
                      // ),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: InkWell(
                            onTap: () async {
                              final imgurl =
                                  await pickAndUploadImageToFirebaseStorage();
                              await updateImageUrl(imgurl);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 235, 232, 232),
                                  borderRadius: BorderRadius.circular(10)),
                              height: 60,
                              width: 60,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(7),
                                child: ((fireStoreImgPath == null)
                                    ? Image.asset(
                                        'assets/images/user_image_drawer.png',
                                        fit: BoxFit.cover)
                                    : FutureBuilder<String>(
                                        future: getImageUrlFromFirebase(),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<String> snapshot) {
                                          if (snapshot.hasData) {
                                            return Image.network(snapshot.data!,
                                                fit: BoxFit.cover);
                                          } else {
                                            return const SizedBox(
                                              width: 10,
                                              height: 10,
                                              child: SpinKitCircle(
                                                color: Colors.white,
                                                size: 40,
                                              ),
                                            );
                                          }
                                        },
                                      )),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            name!,
                            style: const TextStyle(fontSize: 17),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap: () {
                              editNameDialoge();
                              scaffoldKey.currentState!.closeDrawer();
                            },
                            child: const Icon(
                              Icons.edit,
                              size: 15,
                              color: Color.fromARGB(255, 145, 144, 144),
                            ),
                          )
                        ],
                      ),
                      Text(
                        mail!,
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            drawerListTileItem(
              leadingIcon: FeatherIcons.book,
              title: 'About My TradeBook',
              onTapFunction: () {
                Get.to(() => const PageAboutTradeBokk(),
                    transition: Transition.fadeIn,
                    duration: Duration(milliseconds: 300));
              },
            ),
            drawerListTileItem(
              leadingIcon: FeatherIcons.alertCircle,
              title: 'Terms of use',
              onTapFunction: () {
                Get.to(() => const PageTermsOfUser(),
                    transition: Transition.fadeIn,
                    duration: Duration(milliseconds: 300));
              },
            ),
            drawerListTileItem(
              leadingIcon: FeatherIcons.mail,
              title: 'Contact us',
              onTapFunction: () {
                Get.to(() => const ContactUs(),
                    transition: Transition.fadeIn,
                    duration: Duration(milliseconds: 300));
              },
            ),
            drawerListTileItem(
              leadingIcon: FeatherIcons.share2,
              title: 'Share with friends',
              onTapFunction: () {},
            ),
            drawerListTileItem(
              leadingIcon: FeatherIcons.logOut,
              title: 'Logout',
              onTapFunction: () async {
                final SharedPreferences shared =
                    await SharedPreferences.getInstance();
                shared.remove(currentUserId);
                openDialog();
              },
            ),
          ],
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
            onPressed: () {
              GoogleSignInProvider provider = GoogleSignInProvider();
              provider.googleSignOut();
              Get.offAll(const ScreenLogin());
            },
          ),
        ],
      ),
    );
  }

  void editNameDialoge() async {
    final documentRef = FirebaseFirestore.instance
        .collection('users')
        .doc(returnCurrentUserId());

    final documentSnapshot = await documentRef.get();
    final name = documentSnapshot['name'];
    final formGlobalKey = GlobalKey<FormState>();

    TextEditingController nameController = TextEditingController();

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
          onPressed: () async {
            if (formGlobalKey.currentState!.validate()) {
              await updateUserName(nameController.text);
              //await getNameFromFirebase();
              Get.back();
            }
          },
        ),
      ],
    ));
  }

  Future<String> getNameFromFirebase() async {
    late String fieldValue;
    final documentRef = FirebaseFirestore.instance
        .collection('users')
        .doc(returnCurrentUserId());

    final documentSnapshot = await documentRef.get();

    fieldValue = documentSnapshot['name'];

    return fieldValue;
  }

  Future<String> getImageUrlFromFirebase() async {
    late String fieldValue;
    final documentRef = FirebaseFirestore.instance
        .collection('users')
        .doc(returnCurrentUserId());

    final documentSnapshot = await documentRef.get();
    setState(() {
      fieldValue = documentSnapshot['photUrl'];
    });

    return fieldValue;
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
