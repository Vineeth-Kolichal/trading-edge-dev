import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class WidgetLoadingAlert extends StatelessWidget {
  final int duration;
  const WidgetLoadingAlert({super.key, required this.duration});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Timer(Duration(milliseconds: duration), () {
        Navigator.of(context).pop();
      });
    });
    return const AlertDialog(
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
