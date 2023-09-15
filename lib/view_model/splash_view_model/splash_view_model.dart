import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trading_edge/views/routes/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashViewModel extends ChangeNotifier {
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
      return Routes.home;
    }
  }
}
