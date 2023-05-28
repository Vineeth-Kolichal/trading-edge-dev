import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_tradebook/core/constants/constants.dart';
import 'package:my_tradebook/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

FirebaseAuth auth = FirebaseAuth.instance;
String verificationIdenty = '';
Future<void> sendOtp(String phoneNumber) async {
  await auth.verifyPhoneNumber(
    phoneNumber: phoneNumber,
    verificationCompleted: (PhoneAuthCredential credential) {},
    verificationFailed: (FirebaseAuthException e) {},
    codeSent: (String verificationId, int? resendToken) async {},
    codeAutoRetrievalTimeout: (String verificationId) {
      verificationIdenty = verificationId;
    },
  );
}

Future<bool> verifyOtp(String otp) async {
  try {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationIdenty, smsCode: otp);

    final UserCredential userCredential =
        await auth.signInWithCredential(credential);
    final User? user = userCredential.user;
    //currentUserId = user?.uid;
    String? userId = user?.uid;
    final SharedPreferences shared = await SharedPreferences.getInstance();
    await shared.setString(currentUserId, userId!);
    return true;
  } catch (e) {
    return false;
  }
}
