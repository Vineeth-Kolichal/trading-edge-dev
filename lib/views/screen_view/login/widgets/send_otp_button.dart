
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trading_edge/view_model/login_screen_viewmodel/authentication_viewmodel.dart';
import 'package:trading_edge/views/screen_view/otp_verification/screen_otp_verification.dart';

class SendOtpButton extends StatelessWidget {
  const SendOtpButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Consumer<AuthenticationViewModel>(
          builder: (context, value, child) {
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () async {
                if (context
                    .read<AuthenticationViewModel>()
                    .formKey
                    .currentState!
                    .validate()) {
                  context.read<AuthenticationViewModel>().sendOtp(
                    () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ScreenOtpVerification(
                          phoneNumber: context
                              .read<AuthenticationViewModel>()
                              .completedPhone,
                        ),
                      ));
                    },
                  );
                }
              },
              child: value.isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Send OTP',
                      style: TextStyle(fontSize: 16),
                    ),
            );
          },
        ),
      ),
    );
  }
}



