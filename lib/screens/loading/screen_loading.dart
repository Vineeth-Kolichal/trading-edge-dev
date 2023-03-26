import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:my_tradebook/screens/home/screen_home.dart';
import 'package:my_tradebook/screens/intro/screen_intro.dart';
import 'package:my_tradebook/screens/login/screen_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScreenLoading extends StatefulWidget {
  const ScreenLoading({super.key});

  @override
  State<ScreenLoading> createState() => _ScreenLoadingState();
}

class _ScreenLoadingState extends State<ScreenLoading> {
  bool newUser = false;

  @override
  void initState() {
    final User? user = FirebaseAuth.instance.currentUser;

    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      checkSharedPreferences();
      Get.to(
          (user == null)
              ? ((newUser) ? ScreenIntro() : ScreenLogin())
              : ScreenHome(),
          transition: Transition.leftToRight);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SpinKitCubeGrid(
          duration: Duration(milliseconds: 3500),
          color: Colors.deepPurple,
          size: 80,
        ),
      ),
    );
  }

  Future<void> checkSharedPreferences() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    final bool? isNotNewUser = shared.getBool('not_a_first_user');
    if (isNotNewUser == null) {
      newUser = true;
    }
  }
}
