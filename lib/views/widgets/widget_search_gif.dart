import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WidgetSearchGif extends StatelessWidget {
  const WidgetSearchGif({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      width: 120,
      child: LottieBuilder.asset(
        'assets/lottie_jsons/no_data.json',
        height: 120,
      ),
    );
  }
}
