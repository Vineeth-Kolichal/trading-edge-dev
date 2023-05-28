import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:my_tradebook/services/functions/check_internet.dart';
import 'package:my_tradebook/views/login/screen_login.dart';
import 'package:my_tradebook/views/splash_screen/screen_splash.dart';
import 'package:my_tradebook/views/widgets/widget_loading_alert.dart';

class ScreenNoInternet extends StatelessWidget {
  const ScreenNoInternet({super.key});
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
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return const WidgetLoadingAlert(
                      duration: 2000,
                    );
                  },
                );
                if (chekInternet) {
                  Get.offAll(ScreenSplash());
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
