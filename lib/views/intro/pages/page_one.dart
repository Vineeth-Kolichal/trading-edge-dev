import 'package:flutter/material.dart';
import 'package:my_tradebook/views/login/screen_login.dart';

class PageOne extends StatelessWidget {
  const PageOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/intro_image_one.png',
              scale: 4,
            ),
            sizedBoxTen,
            const Text(
              textAlign: TextAlign.center,
              'Track Your Trading Journey And \n Become A Pro Trader',
              style: TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
