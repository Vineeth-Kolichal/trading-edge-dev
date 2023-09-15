import 'package:flutter/material.dart';
import 'package:trading_edge/views/routes/routes.dart';
import 'package:trading_edge/views/screens/home/screen_home.dart';
import 'package:trading_edge/views/screens/intro/screen_intro.dart';
import 'package:trading_edge/views/screens/login/screen_login.dart';
import 'package:trading_edge/views/screens/otp_verification/screen_otp_verification.dart';
import 'package:trading_edge/views/screens/splash_screen/screen_splash.dart';

class AppRouteGenerate {
  Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(builder: (ctx) => const ScreenSplash());
      case Routes.intro:
        return MaterialPageRoute(
          builder: (ctx) => const ScreenIntro(),
        );
      case Routes.login:
        return MaterialPageRoute(
          builder: (ctx) => const ScreenLogin(),
        );
      case Routes.home:
        return MaterialPageRoute(
          builder: (ctx) =>  const ScreenHome(),
        );
      case Routes.otpVerify:
        return MaterialPageRoute(
          builder: (ctx) => const ScreenOtpVerification(phoneNumber: ''),
        );

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (ctx) {
      return const Scaffold(
        body: Center(
          child: Text('Something Error'),
        ),
      );
    });
  }
}
