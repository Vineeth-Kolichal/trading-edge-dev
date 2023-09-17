import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:trading_edge/app/routes/routes.dart';
import 'package:trading_edge/models/user_model/user_model.dart';
import 'package:trading_edge/utils/constants/constant_widgets.dart';
import 'package:trading_edge/view_model/user_profile_viewmodel/user_profile_viewmodel.dart';

class ScreenEnterName extends StatelessWidget {
  const ScreenEnterName({super.key});

  @override
  Widget build(BuildContext context) {
    UserProfileViewModel userProfileViewModel =
        context.read<UserProfileViewModel>();
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
                  height: 80,
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: InkWell(
                      onTap: () {
                        context.read<UserProfileViewModel>().addImage();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 235, 232, 232),
                            borderRadius: BorderRadius.circular(10)),
                        height: 80,
                        width: 80,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(7),
                            child: Selector<UserProfileViewModel, String>(
                                selector: (p0, p1) => p1.imageUrl,
                                builder: (context, imagePath, _) {
                                  return CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: imagePath,
                                    progressIndicatorBuilder:
                                        (context, url, downloadProgress) =>
                                            Center(
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          value: downloadProgress.progress),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  );
                                })),
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
                            key: userProfileViewModel.formKey,
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your name!';
                                }
                                return null;
                              },
                              controller: userProfileViewModel.nameController,
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
                              if (userProfileViewModel.formKey.currentState!
                                  .validate()) {
                                final currentUser =
                                    FirebaseAuth.instance.currentUser;
                                UserModel userModel = UserModel(
                                    name: userProfileViewModel
                                        .nameController.text,
                                    imagePath: userProfileViewModel.imageUrl,
                                    contact: currentUser?.phoneNumber);
                                userProfileViewModel
                                    .addUserProfileToFireStore(userModel);
                                Navigator.of(context)
                                    .pushReplacementNamed(Routes.home);
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
}
