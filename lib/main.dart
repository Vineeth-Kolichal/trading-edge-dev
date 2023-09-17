import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:trading_edge/data/services/position_sizing/position_sizing_services.dart';
import 'package:trading_edge/firebase_options.dart';
import 'package:trading_edge/utils/constants/colors.dart';
import 'package:trading_edge/view_model/dashboard_page_viewmodel/dashboard_page_viewmodel.dart';
import 'package:trading_edge/view_model/fund_page_viewmodel/fund_page_viewmodel.dart';
import 'package:trading_edge/view_model/home_screen_viewmodel/home_screen_viewmodel.dart';
import 'package:trading_edge/view_model/authentication_viewmodel/authentication_viewmodel.dart';
import 'package:trading_edge/view_model/position_sizing_viewmodel/position_sizing_viewmodel.dart';
import 'package:trading_edge/view_model/splash_view_model/splash_view_model.dart';
import 'package:trading_edge/view_model/trade_log_viewmodel/trade_log_viewmodel.dart';
import 'package:trading_edge/view_model/user_profile_viewmodel/user_profile_viewmodel.dart';
import 'package:provider/provider.dart';

import 'app/routes/app_route_generate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  PositionSizingServices.checkAdapterRegistered();
  runApp(TradingEdgeApp(
    appRouteGenerate: AppRouteGenerate(),
  ));
}

class TradingEdgeApp extends StatelessWidget {
  const TradingEdgeApp({super.key, required this.appRouteGenerate});
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
        ChangeNotifierProvider(
          create: (context) => DashboardPageViewModel(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Trading Edge',
        theme: ThemeData(
          scaffoldBackgroundColor: scafoldBgColor,
          primarySwatch: customPrimaryColor,
        ),
        onGenerateRoute: appRouteGenerate.onGenerateRoute,
      ),
    );
  }
}
