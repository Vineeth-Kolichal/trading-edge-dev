import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:my_tradebook/database/firebase/user_profile/user_profile_photo_name_uplaod.dart';
import 'package:my_tradebook/database/local_databse/db_functions/user_name_and_image.dart';
import 'package:my_tradebook/database/local_databse/models/user_model.dart';
import 'package:my_tradebook/screens/home/screen_home.dart';
import 'package:my_tradebook/screens/login/screen_login.dart';
import 'package:my_tradebook/widgets/widget_login_button.dart';

class ScreenEnterName extends StatelessWidget {
  ScreenEnterName({super.key});
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();

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
                Image.asset(
                  'assets/images/name_page_image.png',
                  scale: 4.2,
                ),
                const SizedBox(
                  height: 40,
                ),
                const Text(
                  'What should we call\n You?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),
                const SizedBox(
                  height: 40,
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
                                UserModel user = UserModel(
                                    name: nameController.text, image: null);
                                addUserProfileToFireStore(
                                    nameController.text, null);
                                //await addName(user: user);
                                Get.offAll(ScreenHome(),
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
}
