import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_tradebook/views/home/screen_home.dart';
import 'package:my_tradebook/views/intro/screen_intro.dart';
import 'package:my_tradebook/views/login/screen_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScreenSplash extends StatelessWidget {
  ScreenSplash({super.key});

  late final User? user;
  bool newUser = false;
  bool checkInternet = false;
  String id = '';

  Future<void> checkSharedPreferences() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    final bool? isNotNewUser = shared.getBool('not_a_first_user');
    if (isNotNewUser == null) {
      newUser = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      user = FirebaseAuth.instance.currentUser;
      await checkSharedPreferences();
      Future.delayed(const Duration(milliseconds: 4000), () {
        if (user == null) {
          if (newUser) {
            Get.off(() => ScreenIntro());
          } else {
            Get.off(() => const ScreenLogin());
          }
        } else {
          Get.off(() => const ScreenHome());
        }
      });
    });

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                  width: size.width * 0.4,
                  child: const ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: LinearProgressIndicator(
                      minHeight: 5,
                    ),
                  )),
            ),
          ),
          Center(
            child: Image.asset(
              'assets/images/splash_logo.png',
              scale: 2.2,
            ),
          ),
        ],
      ),
    );
  }
}
