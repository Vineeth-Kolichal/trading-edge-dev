import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:my_tradebook/authentication/google_sign_in_authentication.dart';
import 'package:my_tradebook/database/local_databse/db_functions/check_adapter_registered.dart';
import 'package:my_tradebook/firebase_options.dart';
import 'package:my_tradebook/screens/splash_screen/screen_splash.dart';
import 'package:provider/provider.dart';

import 'screens/enter_name/screen_enter_name.dart';

const loginType = 'LoggedIn';
const String currentUserId = 'current_user_id';
const whiteColor = Colors.white;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Hive.initFlutter();
  checkAdapterRegistered();
  runApp(const MyTradeBookApp());
}

class MyTradeBookApp extends StatelessWidget {
  const MyTradeBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'My TradeBook',
        theme: ThemeData(
          //brightness: Brightness.dark,
          primarySwatch: customPrimaryColor,
        ),
        //home: ScreenEnterName(),
        home: const ScreenSplash(),
      ),
    );
  }
}

const MaterialColor customPrimaryColor = MaterialColor(
  0xFF648BF8, // Set the primary color value
  <int, Color>{
    50: Color(0xFFE4E9FB),
    100: Color(0xFFBBC7F4),
    200: Color(0xFF8DA3ED),
    300: Color(0xFF607FE6),
    400: Color(0xFF3D5CE0),
    500: Color(0xFF2749DB), // Set the primary color value
    600: Color(0xFF2042D8),
    700: Color(0xFF183BD3),
    800: Color(0xFF1034CF),
    900: Color(0xFF0027C6),
  },
);
