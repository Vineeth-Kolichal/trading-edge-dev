import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_tradebook/screens/otp_verification/screen_otp_verification.dart';

FirebaseAuth auth = FirebaseAuth.instance;
String verificationIdenty = '';
Future<void> sendOtp(String phoneNumber, BuildContext context) async {
  await auth.verifyPhoneNumber(
    phoneNumber: phoneNumber,
    verificationCompleted: (PhoneAuthCredential credential) {},
    verificationFailed: (FirebaseAuthException e) {},
    codeSent: (String verificationId, int? resendToken) async {
      await Future.delayed(Duration(milliseconds: 4000));
      Navigator.of(context)
          .push(MaterialPageRoute(builder: ((ctx) => ScreenOtpVerification())));
    },
    codeAutoRetrievalTimeout: (String verificationId) {
      verificationIdenty = verificationId;
    },
  );
}

Future<void> verifyOtp(String otp) async {
  PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationIdenty, smsCode: otp);
  final UserCredential userCredential =
      await auth.signInWithCredential(credential);
  final User? user = userCredential.user;
  print(user?.uid);
}
