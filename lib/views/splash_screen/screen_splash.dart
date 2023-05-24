import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:my_tradebook/views/home/screen_home.dart';
import 'package:my_tradebook/views/intro/screen_intro.dart';
import 'package:my_tradebook/views/login/screen_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScreenSplash extends StatefulWidget {
  const ScreenSplash({super.key});

  @override
  State<ScreenSplash> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  late final User? user;
  bool newUser = false;
  bool checkInternet = false;
  String id = '';
  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    checkSharedPreferences();
    super.initState();
  }

  Future<void> checkSharedPreferences() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    final bool? isNotNewUser = shared.getBool('not_a_first_user');
    if (isNotNewUser == null) {
      newUser = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 5500,
      splash: Image.asset(
        'assets/images/splash_logo.png',
        scale: 2.2,
      ),
      nextScreen: (user == null)
          ? ((newUser) ? const ScreenIntro() : const ScreenLogin())
          : const ScreenHome(),
      splashTransition: SplashTransition.slideTransition,
    );
  }
}
