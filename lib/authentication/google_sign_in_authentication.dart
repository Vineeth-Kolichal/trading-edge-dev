import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_tradebook/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;

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
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      notifyListeners();
      final User? user = userCredential.user;
      String? userId = user?.uid;
      final SharedPreferences shared = await SharedPreferences.getInstance();
      await shared.setString(currentUserId, userId!);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> googleSignOut() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    await FirebaseAuth.instance.signOut();
    final GoogleSignInAccount? googleSignInAccount = googleSignIn.currentUser;
    if (googleSignInAccount != null) {
      await googleSignInAccount.clearAuthCache();
    }
    if (currentUser?.providerData[0].providerId == 'google.com') {
      await googleSignIn.disconnect();
    }
  }
}
