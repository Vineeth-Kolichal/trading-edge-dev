
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:trading_edge/data/repositories/authentication_repo/authentication_repo.dart';

class AutheticationServices implements AuthenticationRepo {
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;

  FirebaseAuth auth = FirebaseAuth.instance;
  static String verificationIdenty = '';
  @override
  Future<void> sendOtp({required String mobileNumber}) async {
    await auth.verifyPhoneNumber(
      timeout: const Duration(milliseconds: 4000),
      phoneNumber: mobileNumber,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) async {},
      codeAutoRetrievalTimeout: (String verificationId) {
        verificationIdenty = verificationId;
      },
    );
  }

  @override
  Future<bool> verifyOtp({required String otp}) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationIdenty, smsCode: otp);
      final user = await auth.signInWithCredential(credential);
      if (user.user != null) {
        return true;
      } else {
        return false;
      }
    } on FirebaseAuthException catch (_) {
      return false;
    }
  }

  @override
  Future<bool> googleLogin() async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return false;
      _user = googleUser;
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> googleSignOut() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    try {
      await FirebaseAuth.instance.signOut();

      final GoogleSignInAccount? googleSignInAccount = googleSignIn.currentUser;
      if (googleSignInAccount != null) {
        await googleSignInAccount.clearAuthCache();
      }
      if (currentUser?.providerData[0].providerId ==
          GoogleAuthProvider.GOOGLE_SIGN_IN_METHOD) {
        await googleSignIn.disconnect();
      }
    } catch (e) {
      ('error sign out $e');
    }
  }

  @override
  Future<bool> checkUserDataExist(String userId) async {
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (snapshot.exists) {
      return true;
    } else {
      return false;
    }
  }
  
}
