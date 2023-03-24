import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/widgets.dart';
import 'package:my_tradebook/main.dart';
import 'package:my_tradebook/screens/home/screen_home.dart';
import 'package:my_tradebook/screens/intro/screen_intro.dart';
import 'package:my_tradebook/screens/loading/screen_loading.dart';
import 'package:my_tradebook/screens/no_internet/screen_no_internet.dart';

class ScreenSplash extends StatefulWidget {
  const ScreenSplash({super.key});

  @override
  State<ScreenSplash> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  bool checkInternet = false;
  @override
  void initState() {
    checkInternetConnetion();
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 3500,
      splash: Image.asset(
        'assets/images/splash_logo.png',
        scale: 2.2,
      ),
      nextScreen:
          checkInternet ? const ScreenLoading() : const ScreenNoInternet(),
      splashTransition: SplashTransition.slideTransition,
    );
  }
}
