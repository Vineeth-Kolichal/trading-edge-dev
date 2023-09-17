import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trading_edge/app/routes/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trading_edge/data/repositories/user_profile_repo/user_profile_repo.dart';
import 'package:trading_edge/data/services/current_user_data.dart';
import 'package:trading_edge/data/services/user_profile_services/userprofile_services.dart';

class SplashViewModel extends ChangeNotifier {
  UserProfileRepo userProfileRepo = UserProfileServices();
  User? user = FirebaseAuth.instance.currentUser;
  Future<String> selectNextRoute() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    final bool? isNotNewUser = shared.getBool('not_a_first_user');
    if (user == null) {
      if (isNotNewUser == null) {
        return Routes.intro;
      } else {
        return Routes.login;
      }
    } else {
      bool isuserExist = await userProfileRepo
          .checkUserDataExist(CurrentUserData.returnCurrentUserId());
      if (isuserExist) {
        return Routes.home;
      } else {
        return Routes.login;
      }
    }
  }
}
