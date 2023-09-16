import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:trading_edge/data/services/position_sizing/position_sizing_services.dart';
import 'package:trading_edge/firebase_options.dart';
import 'package:trading_edge/utils/functions/check_internet.dart';
import 'package:trading_edge/view_model/fund_page_viewmodel/fund_page_viewmodel.dart';
import 'package:trading_edge/view_model/home_screen_viewmodel/home_screen_viewmodel.dart';
import 'package:trading_edge/view_model/login_screen_viewmodel/authentication_viewmodel.dart';
import 'package:trading_edge/view_model/position_sizing_viewmodel/position_sizing_viewmodel.dart';
import 'package:trading_edge/view_model/splash_view_model/splash_view_model.dart';
import 'package:trading_edge/view_model/trade_log_viewmodel/trade_log_viewmodel.dart';
import 'package:trading_edge/view_model/user_profile_viewmodel/user_profile_viewmodel.dart';
import 'package:provider/provider.dart';

import 'app/routes/app_route_generate.dart';

bool checkInternet = false;
const loginType = 'LoggedIn';
const String currentUserId = 'current_user_id';
const whiteColor = Colors.white;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Hive.initFlutter();
  PositionSizingServices.checkAdapterRegistered();
  checkInternet = await checkInternetConnetion();
  runApp(MyTradeBookApp(
    appRouteGenerate: AppRouteGenerate(),
  ));
}

class MyTradeBookApp extends StatelessWidget {
  const MyTradeBookApp({super.key, required this.appRouteGenerate});
  final AppRouteGenerate appRouteGenerate;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => SplashViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthenticationViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserProfileViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => TradeLogViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => PositionSizingViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => HomeScreenViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => FundPageViewModel(),
        ),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'My TradeBook',
        theme: ThemeData(
          //brightness: Brightness.dark,
          primarySwatch: customPrimaryColor,
        ),
        //  home: checkInternet ? const ScreenSplash() : const ScreenNoInternet(),
        onGenerateRoute: appRouteGenerate.onGenerateRoute,
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
