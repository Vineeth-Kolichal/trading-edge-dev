import 'package:flutter/material.dart';
import 'package:trading_edge/app/routes/routes.dart';
import 'package:trading_edge/views/screens/add_update_trade_logs_screen/add_update_trade_logs_screen.dart';
import 'package:trading_edge/views/screens/drawer_item_screens/screen_about.dart';
import 'package:trading_edge/views/screens/drawer_item_screens/screen_contact_us.dart';
import 'package:trading_edge/views/screens/drawer_item_screens/screen_terms_of_user.dart';
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
          builder: (ctx) => const ScreenHome(),
        );
      case Routes.otpVerify:
        return MaterialPageRoute(
          builder: (ctx) => ScreenOtpVerification(phoneNumber: ''),
        );
      case Routes.aboutTradingEdge:
        return MaterialPageRoute(
          builder: (ctx) => const PageAboutTradingEdge(),
        );
      case Routes.termsOfUse:
        return MaterialPageRoute(
          builder: (ctx) => const TermsOfUseScreen(),
        );
      case Routes.contactUs:
        return MaterialPageRoute(
          builder: (ctx) => const ContactUs(),
        );
      case Routes.addOrUpdateTradeLogScreen:
        return MaterialPageRoute(
          builder: (ctx) => const AddUpdateTradeLogScreen(),
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
