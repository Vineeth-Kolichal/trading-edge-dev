import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trading_edge/app/routes/routes.dart';
import 'package:trading_edge/data/services/authentication/authentication.dart';
import 'package:trading_edge/data/services/current_user_data.dart';
import 'package:trading_edge/data/services/user_profile_services/userprofile_services.dart';
import 'package:trading_edge/data/repositories/authentication_repo/authentication_repo.dart';
import 'package:trading_edge/data/repositories/user_profile_repo/user_profile_repo.dart';

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

  Future<String?> verifyOtp(String otp) async {
    isLoading = true;
    notifyListeners();
    bool verified = await authenticationRepo.verifyOtp(otp: otp);
    if (verified) {
      bool isUserExist = await authenticationRepo.checkUserDataExist(
        CurrentUserData.returnCurrentUserId(),
      );
      isLoading = false;
      notifyListeners();
      if (isUserExist) {
        return Routes.home;
      } else {
        return Routes.enterNameScreen;
      }
    } else {
      isLoading = false;
      notifyListeners();
      return null;
    }
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
