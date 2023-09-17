import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:trading_edge/utils/constants/colors.dart';
import 'package:trading_edge/utils/constants/const_values.dart';
import 'package:trading_edge/utils/constants/constant_widgets.dart';
import 'package:trading_edge/utils/snackbar/error_snackbar.dart';
import 'package:trading_edge/view_model/authentication_viewmodel/authentication_viewmodel.dart';
import 'package:trading_edge/app/routes/routes.dart';
import 'package:pinput/pinput.dart';

class ScreenOtpVerification extends StatelessWidget {
  final String phoneNumber;
  ScreenOtpVerification({super.key, required this.phoneNumber});

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final authViewmodel = context.read<AuthenticationViewModel>();
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/otp.png',
                height: 157,
                width: 237,
              ),
              sizedBoxTen,
              const Text(
                'Phone Verification',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'We need to verify your phone number\n $phoneNumber \n before getting started !',
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Enter OTP',
                      style: TextStyle(color: Colors.grey),
                    ),
                    sizedBoxTen,
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Form(
                          key: formKey,
                          child: Pinput(
                            onSubmitted: (value) {
                              authViewmodel
                                  .verifyOtp(
                                value,
                              )
                                  .then((nextScreen) {
                                if (nextScreen != null) {
                                  Navigator.of(context)
                                      .pushReplacementNamed(nextScreen);
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(errorSnackbar());
                                }
                              });
                            },
                            controller: authViewmodel.pinController,
                            defaultPinTheme: defaultPinTheme,
                            focusedPinTheme: focusedPinTheme,
                            length: 6,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter OTP';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    sizedBoxTen,
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Selector<AuthenticationViewModel, bool>(
                            selector: (p0, p1) => p1.isLoading,
                            builder: (context, isLoading, _) {
                              if (isLoading) {
                                return Center(
                                  child: LoadingAnimationWidget.inkDrop(
                                      color: customPrimaryColor, size: 25),
                                  // child: CircularProgressIndicator(
                                  //   strokeWidth: 2,
                                  // ),
                                );
                              }
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    await context
                                        .read<AuthenticationViewModel>()
                                        .verifyOtp(
                                          authViewmodel.pinController.text,
                                        )
                                        .then((nextScreen) {
                                      if (nextScreen != null) {
                                        Navigator.of(context)
                                            .pushReplacementNamed(nextScreen);
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(errorSnackbar());
                                      }
                                    });
                                  }
                                },
                                child: const Text(
                                  'Verify Phone Number',
                                  style: TextStyle(fontSize: 16),
                                ),
                              );
                            }),
                      ),
                    ),
                    sizedBoxTen,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(
                          width: 1,
                        ),
                        InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .pushReplacementNamed(Routes.login);
                            },
                            child: const Text('Change Phone Number?')),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}