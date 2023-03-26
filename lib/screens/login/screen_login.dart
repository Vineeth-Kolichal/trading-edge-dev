import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/route_manager.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:my_tradebook/authentication/google_sign_in_authentication.dart';
import 'package:my_tradebook/authentication/phone_authentication.dart';
import 'package:my_tradebook/main.dart';
import 'package:my_tradebook/screens/home/screen_home.dart';
import 'package:my_tradebook/screens/otp_verification/screen_otp_verification.dart';
import 'package:my_tradebook/widgets/widget_loading_alert.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget sizedBoxTen = SizedBox(
  height: 10,
);

class ScreenLogin extends StatefulWidget {
  ScreenLogin({super.key});

  @override
  State<ScreenLogin> createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  bool _isLoading = false;
  String completePhone = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color.fromARGB(249, 255, 253, 253),
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset('assets/images/login.png'),
                  ),
                  sizedBoxTen,
                  Text(
                    'Welcome..',
                    style: TextStyle(fontSize: 27, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Login with Mobile',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w300),
                        ),
                        sizedBoxTen,
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: IntlPhoneField(
                            style: TextStyle(fontSize: 17),
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              hintText: 'Phone Number',
                              //labelText: 'Phone Number',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(),
                              ),
                            ),
                            initialCountryCode: 'IN',
                            onChanged: (phone) {
                              completePhone = phone.completeNumber;
                              print(phone.completeNumber);
                            },
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
                                await signInWithMobile();
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
                            children: [
                              Expanded(child: Divider()),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, right: 15),
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
                            color: Color.fromARGB(255, 226, 223, 223),
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
    final SharedPreferences shared = await SharedPreferences.getInstance();
    // ignore: use_build_context_synchronously
    final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
    bool validated = await provider.googleLogin();
    await shared.setString(loginType, google);
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
      Get.offAll(ScreenHome(),
          transition: Transition.zoom, duration: Duration(milliseconds: 1000));
    } else {
      Get.snackbar('Ooops..', 'Something went wrong, Please try again',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          margin: const EdgeInsets.all(10),
          animationDuration: const Duration(milliseconds: 2000),
          colorText: Colors.white);
    }
  }

  Future<void> signInWithMobile() async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(const Duration(milliseconds: 2000));
    await sendOtp(completePhone);
    Get.off(const ScreenOtpVerification(),
        transition: Transition.leftToRightWithFade,
        duration: const Duration(milliseconds: 500));
    // Navigator.of(context)
    //     .push(MaterialPageRoute(builder: ((ctx) => ScreenOtpVerification())));
    setState(() async {
      _isLoading = false;
    });
  }
}
