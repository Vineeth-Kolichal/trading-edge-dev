import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:my_tradebook/authentication/phone_authentication.dart';
import 'package:my_tradebook/main.dart';
import 'package:my_tradebook/screens/enter_name/screen_enter_name.dart';
import 'package:my_tradebook/screens/login/screen_login.dart';
import 'package:my_tradebook/widgets/widget_loading_alert.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScreenOtpVerification extends StatefulWidget {
  const ScreenOtpVerification({super.key});

  @override
  State<ScreenOtpVerification> createState() => _ScreenOtpVerificationState();
}

class _ScreenOtpVerificationState extends State<ScreenOtpVerification> {
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
              const Text(
                'We need to verify your phone number \n before getting started !',
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
                        child: Pinput(
                          controller: _pinController,
                          defaultPinTheme: defaultPinTheme,
                          focusedPinTheme: focusedPinTheme,
                          length: 6,
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
                            await veryfyOtpRecieved();
                          },
                          child: const Text(
                            'Verify Phone Number',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                        onTap: () {}, child: const Text('Edit Phone Number?')),
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
      Get.snackbar('OTP Verified Successfully!', '',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color.fromARGB(255, 3, 182, 12),
          margin: const EdgeInsets.all(10),
          animationDuration: const Duration(milliseconds: 1500),
          colorText: Colors.white);

      Get.offAll(ScreenEnterName(),
          transition: Transition.leftToRightWithFade,
          duration: Duration(milliseconds: 500));
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(
      //     builder: ((ctx) => ScreenEnterName()),
      //   ),
      // );
    } else {
      Get.snackbar('Ooops..', 'Wrong OTP, Please enter correct OTP',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          margin: const EdgeInsets.all(10),
          animationDuration: const Duration(milliseconds: 2000),
          colorText: Colors.white);
    }
  }
}
