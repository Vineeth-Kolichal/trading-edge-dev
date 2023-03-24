import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:my_tradebook/main.dart';
import 'package:my_tradebook/screens/home/screen_home.dart';
import 'package:my_tradebook/screens/login/screen_login.dart';

class ScreenLoading extends StatefulWidget {
  const ScreenLoading({super.key});

  @override
  State<ScreenLoading> createState() => _ScreenLoadingState();
}

class _ScreenLoadingState extends State<ScreenLoading> {
  @override
  void initState() {
    final User? user = FirebaseAuth.instance.currentUser;
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 5), () {
      // Navigate to the new screen after loading is complete
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  (user == null) ? ScreenLogin() : ScreenHome()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitThreeBounce(
          duration: Duration(milliseconds: 3000),
          color: Colors.deepPurple,
          size: 60,
        ),
      ),
    );
  }
}
