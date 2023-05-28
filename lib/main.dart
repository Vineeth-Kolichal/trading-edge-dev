import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:my_tradebook/services/authentication/google_sign_in_authentication.dart';
import 'package:my_tradebook/services/hive_db_adapter_registration/hive_db_adapter_registration.dart';
import 'package:my_tradebook/firebase_options.dart';
import 'package:my_tradebook/services/functions/check_internet.dart';
import 'package:my_tradebook/views/no_internet/screen_no_internet.dart';
import 'package:my_tradebook/views/splash_screen/screen_splash.dart';
import 'package:provider/provider.dart';

bool checkInternet = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Hive.initFlutter();
  checkAdapterRegistered();
  checkInternet = await checkInternetConnetion();
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
        home: checkInternet ? ScreenSplash() : const ScreenNoInternet(),
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
