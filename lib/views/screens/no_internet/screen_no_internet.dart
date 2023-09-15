import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:trading_edge/functions/check_internet.dart';
import 'package:trading_edge/utils/constants/constant_widgets.dart';
import 'package:trading_edge/views/screens/splash_screen/screen_splash.dart';
import 'package:trading_edge/views/widgets/widget_loading_alert.dart';

class ScreenNoInternet extends StatefulWidget {
  const ScreenNoInternet({super.key});

  @override
  State<ScreenNoInternet> createState() => _ScreenNoInternetState();
}

class _ScreenNoInternetState extends State<ScreenNoInternet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/no_internet.png',
              scale: 2,
            ),
            sizedBoxTen,
            const Text(
              'Ooops!',
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  color: Colors.deepPurple),
            ),
            sizedBoxTen,
            const Text(
              'Slow or no internet connection\n Check your inernet settings.',
              textAlign: TextAlign.center,
            ),
            sizedBoxTen,
            ElevatedButton(
              onPressed: () async {
                bool chekInternet = await checkInternetConnetion();
                await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const WidgetLoadingAlert(
                      duration: 2000,
                    );
                  },
                );
                if (chekInternet) {
                  Get.offAll(const ScreenSplash());
                }
              },
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
              child: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}
