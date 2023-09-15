import 'package:flutter/material.dart';
import 'package:trading_edge/utils/constants/constant_widgets.dart';
import 'package:trading_edge/view_model/login_screen_viewmodel/authentication_viewmodel.dart';
import 'package:provider/provider.dart';
import 'widgets/google_signin_button.dart';
import 'widgets/or_divider.dart';
import 'widgets/phone_text_field.dart';
import 'widgets/send_otp_button.dart';



class ScreenLogin extends StatelessWidget {
  const ScreenLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<AuthenticationViewModel>().key,
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset('assets/images/login.png', scale: 3),
                  ),
                  sizedBoxTen,
                  const Text(
                    'Sign in to',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/images/my_trade_book.png',
                      scale: 3,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 25, right: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Login with Mobile',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w300),
                        ),
                        sizedBoxTen,
                        PhoneInputField(),
                        sizedBoxTen,
                        SendOtpButton(),
                        OrDivider(),
                        GoogleSignInButton()
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
