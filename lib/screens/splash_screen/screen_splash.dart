import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/widgets.dart';
import 'package:my_tradebook/screens/intro/screen_intro.dart';

class ScreenSplash extends StatelessWidget {
  const ScreenSplash({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 3500,
      splash: Container(
          child: Image.asset(
        'assets/images/splash_logo.png',
        scale: 2.2,
      )),
      nextScreen: ScreenIntro(),
      splashTransition: SplashTransition.slideTransition,
    );
  }
}
