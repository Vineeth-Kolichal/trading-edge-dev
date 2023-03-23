import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_tradebook/authentication/google_sign_in_authentication.dart';
import 'package:my_tradebook/firebase_options.dart';
import 'package:my_tradebook/screens/enter_name/screen_enter_name.dart';
import 'package:my_tradebook/screens/home/screen_home.dart';
import 'package:my_tradebook/screens/intro/screen_intro.dart';
import 'package:my_tradebook/screens/login/screen_login.dart';
import 'package:my_tradebook/screens/otp_verification/screen_otp_verification.dart';
import 'package:my_tradebook/screens/splash_screen/screen_splash.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          // brightness: Brightness.dark,
          primarySwatch: Colors.deepPurple,
        ),
        home: ScreenSplash(),
      ),
    );
  }
}
