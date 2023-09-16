import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/route_manager.dart';

class WidgetLoadingAlert extends StatefulWidget {
  final int duration;
  const WidgetLoadingAlert({super.key, required this.duration});

  @override
  State<WidgetLoadingAlert> createState() => _WidgetLoadingAlertState();
}

class _WidgetLoadingAlertState extends State<WidgetLoadingAlert> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: widget.duration), () {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
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
