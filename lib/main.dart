import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:my_tradebook/authentication/google_sign_in_authentication.dart';
import 'package:my_tradebook/database/local_databse/db_functions/check_adapter_registered.dart';
import 'package:my_tradebook/firebase_options.dart';
import 'package:my_tradebook/screens/splash_screen/screen_splash.dart';
import 'package:provider/provider.dart';

const mobile = 'mobile';
const google = 'google';
const String currentUserId='current_user_id';
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
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'My TradeBook',
        theme: ThemeData(
          //brightness: Brightness.dark,
          primarySwatch: Colors.deepPurple,
        ),
        home: const ScreenSplash(),
      ),
    );
  }
}
