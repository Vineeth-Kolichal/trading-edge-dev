import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;

  Future googleLogin() async {
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) return;
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
    print(user?.uid);
  }

  Future<void> googleSignOut()async{
    await FirebaseAuth.instance.signOut();
            final GoogleSignInAccount? googleSignInAccount =
                googleSignIn.currentUser;
            if (googleSignInAccount != null) {
              await googleSignInAccount.clearAuthCache();
            }
            await googleSignIn.disconnect();

}
}

