import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:my_tradebook/authentication/get_current_user_id.dart';
import 'package:my_tradebook/authentication/phone_authentication.dart';
import 'package:my_tradebook/database/firebase/user_profile/user_profile_photo_name_uplaod.dart';
import 'package:my_tradebook/main.dart';
import 'package:my_tradebook/screens/enter_name/screen_enter_name.dart';
import 'package:my_tradebook/screens/home/screen_home.dart';
import 'package:my_tradebook/screens/login/screen_login.dart';
import 'package:my_tradebook/widgets/widget_loading_alert.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScreenOtpVerification extends StatefulWidget {
  final String phoneNumber;
  const ScreenOtpVerification({super.key, required this.phoneNumber});

  @override
  State<ScreenOtpVerification> createState() => _ScreenOtpVerificationState();
}

class _ScreenOtpVerificationState extends State<ScreenOtpVerification> {
  bool resendVisible = true;
  final formKey = GlobalKey<FormState>();
  final _pinController = TextEditingController();

  final defaultPinTheme = PinTheme(
    width: 50,
    height: 52,
    textStyle: const TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      color: const Color.fromARGB(31, 148, 144, 144),
      border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
      borderRadius: BorderRadius.circular(10),
    ),
  );

  final focusedPinTheme = PinTheme(
    width: 50,
    height: 52,
    textStyle: const TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      color: const Color.fromARGB(31, 148, 144, 144),
      border: Border.all(color: const Color.fromRGBO(1, 80, 145, 1)),
      borderRadius: BorderRadius.circular(10),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/otp.png',
                height: 157,
                width: 237,
              ),
              sizedBoxTen,
              const Text(
                'Phone Verification',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'We need to verify your phone number\n ${widget.phoneNumber} \n before getting started !',
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Enter OTP',
                      style: TextStyle(color: Colors.grey),
                    ),
                    sizedBoxTen,
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Form(
                          key: formKey,
                          child: Pinput(
                            controller: _pinController,
                            defaultPinTheme: defaultPinTheme,
                            focusedPinTheme: focusedPinTheme,
                            length: 6,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter OTP';
                              } else {
                                return null;
                              }
                            },
                          ),
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
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              await veryfyOtpRecieved();
                            }
                          },
                          child: const Text(
                            'Verify Phone Number',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                    sizedBoxTen,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Visibility(
                          visible: resendVisible,
                          child: InkWell(
                              onTap: () async {
                                _pinController.clear();
                                setState(() {
                                  resendVisible = false;
                                });
                                await sendOtp(widget.phoneNumber);
                                Future.delayed(const Duration(minutes: 1));
                                setState(() {
                                  resendVisible = true;
                                });
                              },
                              child: const Text('Resend OTP')),
                        ),
                        const SizedBox(
                          width: 1,
                        ),
                        InkWell(
                            onTap: () {
                              Get.offAll(ScreenLogin());
                            },
                            child: const Text('Change Phone Number?')),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> veryfyOtpRecieved() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();

    // ignore: use_build_context_synchronously
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const WidgetLoadingAlert(
          duration: 8000,
        );
      },
    );
    bool verify = await verifyOtp(_pinController.text);
    if (verify) {
      await shared.setString(loginType, mobile);
      bool isUserExist = await checkUserDataExist(returnCurrentUserId());
      Get.snackbar('OTP Verified Successfully!', '',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color.fromARGB(255, 3, 182, 12),
          margin: const EdgeInsets.all(10),
          animationDuration: const Duration(milliseconds: 1100),
          colorText: Colors.white);
      await Future.delayed(const Duration(milliseconds: 1500));
      if (isUserExist) {
        Get.offAll(const ScreenHome(),
            transition: Transition.leftToRightWithFade,
            duration: const Duration(milliseconds: 500));
      } else {
        Get.offAll(ScreenEnterName(),
            transition: Transition.leftToRightWithFade,
            duration: const Duration(milliseconds: 500));
      }
    } else {
      Get.snackbar('Ooops..', 'Wrong OTP, Please enter correct OTP',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          margin: const EdgeInsets.all(10),
          animationDuration: const Duration(milliseconds: 2000),
          colorText: Colors.white);
    }
  }
}
