import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trading_edge/data/authentication/authentication.dart';
import 'package:trading_edge/data/user_profile_services/userprofile_services.dart';
import 'package:trading_edge/repositories/authentication_repo/authentication_repo.dart';
import 'package:trading_edge/repositories/user_profile_repo/user_profile_repo.dart';

class AuthenticationViewModel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final pinController = TextEditingController();
  UserProfileRepo userProfileRepo = UserProfileServices();
  bool isLoading = false;
  final key = GlobalKey<ScaffoldState>();
  String completedPhone = '';

  AuthenticationRepo authenticationRepo = AutheticationServices();
  void setCompletePhone(String phone) {
    completedPhone = phone;
  }

  Future<void> sendOtp(Function() otpScreenNavigation) async {
    isLoading = true;
    notifyListeners();
    await authenticationRepo.sendOtp(mobileNumber: completedPhone);
    isLoading = false;
    otpScreenNavigation();
    notifyListeners();
  }

  Future<bool> verifyOtp(String otp) async {
    bool verified = await authenticationRepo.verifyOtp(otp: otp);
    return verified;
  }

  Future<void> googleSignIn(Function(bool) googleSignInResponse) async {
    await authenticationRepo.googleLogin().then((value) {
      if (value) {
        final currentUser = FirebaseAuth.instance.currentUser;
        final userId = currentUser!.uid;
        authenticationRepo.checkUserDataExist(userId).then((value) {
          if (!value) {
            userProfileRepo.addGoogleDetailsToFirestore();
          }
        });
        googleSignInResponse(true);
      } else {
        googleSignInResponse(false);
      }
    });
  }

  Future<void> signOut() async {
    authenticationRepo.googleSignOut();
  }
}
