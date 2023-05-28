import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/route_manager.dart';

class WidgetLoadingAlert extends StatelessWidget {
  final int duration;
  const WidgetLoadingAlert({super.key, required this.duration});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Timer(Duration(milliseconds: duration), () {
        Get.back();
      });
    });
    return const AlertDialog(
      scrollable: false,
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Center(
        child: SpinKitThreeBounce(
          duration: Duration(milliseconds: 3000),
          color: Colors.white,
          size: 60,
        ),
      ),
    );
  }
}
