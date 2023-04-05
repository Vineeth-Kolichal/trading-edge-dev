import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:my_tradebook/authentication/get_current_user_id.dart';
import 'package:my_tradebook/database/firebase/user_profile/user_profile_photo_name_uplaod.dart';
import 'package:my_tradebook/screens/home/screen_home.dart';
import 'package:my_tradebook/screens/login/screen_login.dart';

class ScreenEnterName extends StatefulWidget {
  ScreenEnterName({super.key});

  @override
  State<ScreenEnterName> createState() => _ScreenEnterNameState();
}

class _ScreenEnterNameState extends State<ScreenEnterName> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();

  String? fireStoreImgPath = '';
  String imgurl = '';
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
                // Image.asset(
                //   'assets/images/name_page_image.png',
                //   scale: 4.2,
                // ),
                // const SizedBox(
                //   height: 20,
                // ),
                // const Text(
                //   'Set up your Profile',
                //   textAlign: TextAlign.center,
                //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                // ),
                // const SizedBox(
                //   height: 40,
                // ),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(70)),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: InkWell(
                      onTap: () {
                        _updateState();
                        // setState(() async {
                        //   imgurl = await pickAndUploadImageToFirebaseStorage();
                        //   setNameImage();
                        // });
                        // await updateImageUrl(imgurl);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 235, 232, 232),
                            borderRadius: BorderRadius.circular(70)),
                        height: 120,
                        width: 120,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(70),
                          child: (imgurl == '')
                              ? Image.asset(
                                  'assets/images/user_image_drawer.png',
                                  fit: BoxFit.cover)
                              : Image.network(
                                  imgurl,
                                  fit: BoxFit.cover,
                                ),
                          // child: (FutureBuilder<String>(
                          //   future: getImageUrlFromFirebase(),
                          //   builder: (BuildContext context,
                          //       AsyncSnapshot<String> snapshot) {
                          //     if (snapshot.hasData) {
                          //       return Image.network(snapshot.data!,
                          //           fit: BoxFit.cover);
                          //     } else {
                          //       return SizedBox(
                          //         width: 10,
                          //         height: 10,
                          //         child: Image.asset(
                          //             'assets/images/user_image_drawer.png',
                          //             fit: BoxFit.cover),
                          //       );
                          //     }
                          //   },
                          // )),
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
                              elevation: 5, // the elevation of the button
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    10), // the radius of the button
                              ),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                addUserProfileToFireStore(nameController.text,
                                    (imgurl == '') ? null : imgurl);
                                //await addName(user: user);
                                Get.offAll(const ScreenHome(),
                                    transition: Transition.leftToRightWithFade,
                                    duration:
                                        const Duration(milliseconds: 500));
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
        .doc(returnCurrentUserId());

    final documentSnapshot = await documentRef.get();
    setState(() {
      fieldValue = documentSnapshot['photUrl'];
    });

    return fieldValue;
  }
}
