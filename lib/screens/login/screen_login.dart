import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:my_tradebook/authentication/google_sign_in_authentication.dart';
import 'package:my_tradebook/authentication/phone_authentication.dart';
import 'package:my_tradebook/database/firebase/user_profile/user_profile_photo_name_uplaod.dart';
import 'package:my_tradebook/screens/home/screen_home.dart';
import 'package:my_tradebook/screens/otp_verification/screen_otp_verification.dart';
import 'package:my_tradebook/widgets/widget_loading_alert.dart';
import 'package:provider/provider.dart';

Widget sizedBoxTen = const SizedBox(
  height: 10,
);

class ScreenLogin extends StatefulWidget {
  const ScreenLogin({super.key});

  @override
  State<ScreenLogin> createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String completePhone = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color.fromARGB(249, 255, 253, 253),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset('assets/images/login.png', scale: 3),
                  ),
                  sizedBoxTen,
                  const Text(
                    'Sign in to',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/images/my_trade_book.png',
                      scale: 3,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Login with Mobile',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w300),
                        ),
                        sizedBoxTen,
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Form(
                            key: _formKey,
                            child: IntlPhoneField(
                              style: const TextStyle(fontSize: 17),
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                hintText: 'Phone Number',
                                //labelText: 'Phone Number',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(),
                                ),
                              ),
                              initialCountryCode: 'IN',
                              onChanged: (phone) {
                                completePhone = phone.completeNumber;
                              },
                            ),
                          ),
                        ),
                        sizedBoxTen,
                        SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 3, // the elevation of the button
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10), // the radius of the button
                                ),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  await signInWithMobile();
                                }
                              },
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 3,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    )
                                  : const Text(
                                      'Send OTP',
                                      style: TextStyle(fontSize: 16),
                                    ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: const [
                              Expanded(child: Divider()),
                              Padding(
                                padding: EdgeInsets.only(left: 15, right: 15),
                                child: Text(
                                  'OR',
                                  style: TextStyle(fontSize: 19),
                                ),
                              ),
                              Expanded(
                                child: Divider(),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            color: const Color.fromARGB(255, 226, 223, 223),
                            child: InkWell(
                              onTap: () async {
                                await signInWithGoogle();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: Image.asset(
                                            'assets/images/google.png')),
                                    const Text(
                                      'Contitue with google',
                                      style: TextStyle(color: Colors.black),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signInWithGoogle() async {
    // final SharedPreferences shared = await SharedPreferences.getInstance();
    // ignore: use_build_context_synchronously
    final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
    bool validated = await provider.googleLogin();
    // await shared.setString(loginType, google);
    // ignore: use_build_context_synchronously
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const WidgetLoadingAlert(
          duration: 3000,
        );
      },
    );
    if (validated) {
      final currentUser = FirebaseAuth.instance.currentUser;
      String? name = currentUser?.displayName;
      String? imagePath = currentUser?.photoURL;
      addUserProfileToFireStore(name!, imagePath);
      Get.offAll(const ScreenHome(),
          transition: Transition.fadeIn,
          duration: const Duration(milliseconds: 500));
    } else {
      Get.snackbar('Ooops..', 'Something went wrong, Please try again',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          margin: const EdgeInsets.all(10),
          animationDuration: const Duration(milliseconds: 700),
          colorText: Colors.white);
    }
  }

  Future<void> signInWithMobile() async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(const Duration(milliseconds: 2000));
    await sendOtp(completePhone);
    Get.off(ScreenOtpVerification(phoneNumber: completePhone),
        transition: Transition.fadeIn,
        duration: const Duration(milliseconds: 500));

    setState(() {
      _isLoading = false;
    });
  }
}
