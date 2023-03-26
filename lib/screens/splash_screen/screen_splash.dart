import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/widgets.dart';
import 'package:get/route_manager.dart';
import 'package:my_tradebook/authentication/get_current_user_id.dart';
import 'package:my_tradebook/main.dart';
import 'package:my_tradebook/screens/home/screen_home.dart';
import 'package:my_tradebook/screens/intro/screen_intro.dart';
import 'package:my_tradebook/screens/loading/screen_loading.dart';
import 'package:my_tradebook/screens/login/screen_login.dart';
import 'package:my_tradebook/screens/no_internet/screen_no_internet.dart';
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
    checkInternetConnetion();
    checkSharedPreferences();
    super.initState();
    // Future.delayed(const Duration(seconds: 5), () {
    //   checkSharedPreferences();
    //   Get.to(
    //       (user == null)
    //           ? ((newUser) ? ScreenIntro() : ScreenLogin())
    //           : ScreenHome(),
    //       transition: Transition.leftToRight);
    // });
  }

  Future<void> checkInternetConnetion() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        checkInternet = false;
      });
    } else {
      setState(() {
        checkInternet = true;
      });
    }
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
      nextScreen: checkInternet
          ? (user == null)
              ? ((newUser) ? ScreenIntro() : ScreenLogin())
              : ScreenHome()
          : const ScreenNoInternet(),
      //checkInternet ? const ScreenLoading() : const ScreenNoInternet(),
      splashTransition: SplashTransition.slideTransition,
    );
  }
}
