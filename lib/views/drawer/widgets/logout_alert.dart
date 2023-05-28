 import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_tradebook/core/constants/colors.dart';
import 'package:my_tradebook/services/authentication/google_sign_in_authentication.dart';
import 'package:my_tradebook/views/login/screen_login.dart';
import 'package:my_tradebook/views/widgets/widget_loading_alert.dart';

void openDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 5,
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure want to logout?'),
        actions: [
          ElevatedButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ))),
            child: const Text("Cancel"),
            onPressed: () => Get.back(),
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: const BorderSide(color: customPrimaryColor),
                ),
              ),
            ),
            child: const Text(
              "Confirm",
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () async {
              GoogleSignInProvider provider = GoogleSignInProvider();
              await provider.googleSignOut();
              const WidgetLoadingAlert(duration: 3000);
              Get.offAll(const ScreenLogin(),
                  transition: Transition.leftToRight,
                  duration: const Duration(milliseconds: 1000));
            },
          ),
        ],
      ),
    );
  }