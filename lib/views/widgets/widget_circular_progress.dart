import 'package:flutter/material.dart';
import 'package:trading_edge/utils/constants/colors.dart';

Widget progress = const SizedBox(
  width: 16,
  height: 16,
  child: CircularProgressIndicator(
    strokeWidth: 3,
    valueColor: AlwaysStoppedAnimation<Color>(customPrimaryColor),
  ),
);
