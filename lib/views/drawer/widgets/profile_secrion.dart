import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:my_tradebook/services/authentication/get_current_user_id.dart';
import 'package:my_tradebook/services/firebase/user_profile/user_profile_photo_name_uplaod.dart';
import 'package:my_tradebook/views/drawer/widgets/edit_name_dialog.dart';
import 'package:my_tradebook/views/home/screen_home.dart';

class ProfileSection extends StatefulWidget {
  const ProfileSection({super.key});

  @override
  State<ProfileSection> createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSection> {
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
    return  Material(
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
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: InkWell(
                            onTap: () async {
                              try {
                                final imgurl =
                                    await pickAndUploadImageToFirebaseStorage();
                                await updateImageUrl(imgurl);
                              } catch (e) {
                                ('image exception $e');
                              }
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
            );
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

// This fuction is used to get image url from firebase
  Future<String> getImageUrlFromFirebase() async {
    late String fieldValue;
    final documentRef = FirebaseFirestore.instance
        .collection('users')
        .doc(returnCurrentUserId());
    final documentSnapshot = await documentRef.get();
    fieldValue = documentSnapshot['photUrl'];
    return fieldValue;
  }
}