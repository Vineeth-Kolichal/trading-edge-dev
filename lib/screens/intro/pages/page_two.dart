import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:my_tradebook/screens/login/screen_login.dart';

class PageTwo extends StatelessWidget {
  const PageTwo({super.key});

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
              'assets/images/page_two_image.png',
              scale: 4,
            ),
            sizedBoxTen,
            Text(
              textAlign: TextAlign.center,
              'View and Analyse your Trading \n Journal using graph',
              style: TextStyle(fontSize: 15),
            )
          ],
        ),
      ),
    );
  }
}
