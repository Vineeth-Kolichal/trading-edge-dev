import 'package:flutter/material.dart';
import 'package:my_tradebook/authentication/phone_authentication.dart';
import 'package:my_tradebook/screens/enter_name/screen_enter_name.dart';
import 'package:my_tradebook/screens/home/screen_home.dart';
import 'package:my_tradebook/screens/login/screen_login.dart';
import 'package:pinput/pinput.dart';

class ScreenOtpVerification extends StatefulWidget {
  ScreenOtpVerification({super.key});

  @override
  State<ScreenOtpVerification> createState() => _ScreenOtpVerificationState();
}

class _ScreenOtpVerificationState extends State<ScreenOtpVerification> {
  final _pinController = TextEditingController();

  final defaultPinTheme = PinTheme(
    width: 50,
    height: 52,
    textStyle: TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      color: Color.fromARGB(31, 148, 144, 144),
      border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
      borderRadius: BorderRadius.circular(10),
    ),
  );

  final focusedPinTheme = PinTheme(
    width: 50,
    height: 52,
    textStyle: TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      color: Color.fromARGB(31, 148, 144, 144),
      border: Border.all(color: Color.fromRGBO(1, 80, 145, 1)),
      borderRadius: BorderRadius.circular(10),
    ),
  );

//   final focusedPinTheme = defaultPinTheme.copyDecorationWith(
  @override
  Widget build(BuildContext context) {
    bool _isLoading = false;
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
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
                    Pinput(
                      controller: _pinController,
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: focusedPinTheme,
                      length: 6,
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
                            setState(() {
                              _isLoading = true;
                            });
                            await verifyOtp(_pinController.text);
                            await Future.delayed(
                                const Duration(milliseconds: 5000));
                            await verifyOtp(_pinController.text);
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: ((ctx) => ScreenEnterName()),
                              ),
                            );
                            setState(() {
                              _isLoading = false;
                            });
                          },
                          child: _isLoading == true
                              ? SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : Text(
                                  'Verify Phone Number',
                                  style: TextStyle(fontSize: 16),
                                ),
                        ),
                      ),
                    ),
                    InkWell(onTap: () {}, child: Text('Edit Phone Number?')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
