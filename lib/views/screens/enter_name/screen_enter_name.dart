import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:trading_edge/services/current_user_data.dart';
import 'package:trading_edge/database/firebase/user_profile/user_profile_photo_name_uplaod.dart';
import 'package:trading_edge/utils/constants/constant_widgets.dart';
import 'package:trading_edge/views/screens/home/screen_home.dart';

class ScreenEnterName extends StatefulWidget {
  const ScreenEnterName({super.key});

  @override
  State<ScreenEnterName> createState() => _ScreenEnterNameState();
}

class _ScreenEnterNameState extends State<ScreenEnterName> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();

  String? fireStoreImgPath = '';
  String imgurl =
      'https://firebasestorage.googleapis.com/v0/b/my-tradebook.appspot.com/o/user_profile_images%2Fuser_image_drawer.png?alt=media&token=259f68a2-dfcb-4be3-9028-781154c58fe6';
  @override
  void initState() {
    setNameImage();
    super.initState();
  }

  void setNameImage() async {
    String? profileImgUrl = await getImageUrlFromFirebase();
    setState(() {
      fireStoreImgPath = profileImgUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(children: [
                const Text(
                  'Setup your Profile',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),
                const SizedBox(
                  height: 60,
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(70)),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: InkWell(
                      onTap: () {
                        _updateState();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 235, 232, 232),
                            borderRadius: BorderRadius.circular(70)),
                        height: 120,
                        width: 120,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(70),
                          child: Image.network(
                            imgurl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 8, right: 15, top: 5),
                          child: Form(
                            key: _formKey,
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your name!';
                                }
                                return null;
                              },
                              controller: nameController,
                              decoration: const InputDecoration(
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.only(bottom: 7),
                                    child:
                                        Icon(FontAwesomeIcons.user, size: 20),
                                  ),
                                  hintText: 'Enter your name',
                                  border: InputBorder.none),
                            ),
                          ),
                        ),
                      ),
                      sizedBoxTen,
                      sizedBoxTen,
                      SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                              ),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                final currentUser =
                                    FirebaseAuth.instance.currentUser;
                                await addUserProfileToFireStore(
                                    name: nameController.text,
                                    imgUrl: imgurl,
                                    contact: currentUser?.phoneNumber);

                                Get.offAll(
                                   const ScreenHome(),
                                  transition: Transition.leftToRightWithFade,
                                  duration: const Duration(milliseconds: 500),
                                );
                              }
                            },
                            child: const Text(
                              'Submit',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                      sizedBoxTen,
                      const Text(
                        'By clicking submit button, I hereby agree to and accept \n the terms and conditions governing my use of \n"My TradeBook" app, I further reaffirm my acceptance \nof general terms and conditions.',
                        style: TextStyle(fontSize: 11),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }

  void _updateState() {
    pickAndUploadImageToFirebaseStorage().then((imgurl) {
      setState(() {
        this.imgurl = imgurl;
        setNameImage();
      });
    });
  }

  Future<String> getImageUrlFromFirebase() async {
    late String fieldValue;
    final documentRef = FirebaseFirestore.instance
        .collection('users')
        .doc(CurrentUserData.returnCurrentUserId());

    final documentSnapshot = await documentRef.get();
    setState(() {
      fieldValue = documentSnapshot['photUrl'];
    });

    return fieldValue;
  }
}
