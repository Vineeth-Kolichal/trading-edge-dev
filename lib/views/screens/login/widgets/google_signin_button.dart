import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trading_edge/utils/snackbar/error_snackbar.dart';
import 'package:trading_edge/view_model/login_screen_viewmodel/authentication_viewmodel.dart';
import 'package:trading_edge/views/routes/routes.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: const Color.fromARGB(255, 226, 223, 223),
        child: InkWell(
          onTap: () async {
            context.read<AuthenticationViewModel>().googleSignIn((isSuccess) {
              if (isSuccess) {
                Navigator.of(context).pushReplacementNamed(Routes.home);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(errorSnackbar());
              }
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    height: 20,
                    width: 20,
                    child: Image.asset('assets/images/google.png')),
                const Text(
                  'Continue with google',
                  style: TextStyle(color: Colors.black),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
