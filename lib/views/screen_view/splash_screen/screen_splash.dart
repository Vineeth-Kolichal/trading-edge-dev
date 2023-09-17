import 'package:flutter/material.dart';
import 'package:trading_edge/view_model/splash_view_model/splash_view_model.dart';
import 'package:provider/provider.dart';

class ScreenSplash extends StatelessWidget {
  const ScreenSplash({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      

      String nextRoute =
          await context.read<SplashViewModel>().selectNextRoute();
      Future.delayed(
        const Duration(milliseconds: 3000),
        () {
          Navigator.of(context).pushReplacementNamed(nextRoute);
        },
      );
    });
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/splash_logo.png',
          scale: 2.2,
        ),
      ),
    );
  }
}
