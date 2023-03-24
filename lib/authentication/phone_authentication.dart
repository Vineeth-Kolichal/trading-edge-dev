import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_tradebook/authentication/otp_verification_dialoges/success_otp_dialoge.dart';

FirebaseAuth auth = FirebaseAuth.instance;
String verificationIdenty = '';
Future<void> sendOtp(String phoneNumber, BuildContext context) async {
  await auth.verifyPhoneNumber(
    phoneNumber: phoneNumber,
    verificationCompleted: (PhoneAuthCredential credential) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return SuccessDialog();
        },
      );
    },
    verificationFailed: (FirebaseAuthException e) {},
    codeSent: (String verificationId, int? resendToken) async {},
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
