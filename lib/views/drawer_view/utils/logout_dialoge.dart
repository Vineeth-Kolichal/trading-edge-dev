import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trading_edge/app/routes/routes.dart';
import 'package:trading_edge/utils/constants/colors.dart';
import 'package:trading_edge/view_model/authentication_viewmodel/authentication_viewmodel.dart';
import 'package:trading_edge/views/widgets/widget_loading_alert.dart';

void logoutDialoge(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
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
          onPressed: () => Navigator.of(context).pop(),
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
            final provider = context.read<AuthenticationViewModel>();
            await provider.signOut();
            const WidgetLoadingAlert(duration: 3000);
            Future.delayed(const Duration(microseconds: 100), (() {
              Navigator.of(context).pushReplacementNamed(Routes.login);
            }));
          },
        ),
      ],
    ),
  );
}
