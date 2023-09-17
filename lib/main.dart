import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:trading_edge/data/services/position_sizing/position_sizing_services.dart';
import 'package:trading_edge/firebase_options.dart';
import 'package:trading_edge/utils/constants/colors.dart';
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
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'My TradeBook',
        theme: ThemeData(
          scaffoldBackgroundColor: scafoldBgColor,
          primarySwatch: customPrimaryColor,
        ),
        onGenerateRoute: appRouteGenerate.onGenerateRoute,
      ),
    );
  }
}
