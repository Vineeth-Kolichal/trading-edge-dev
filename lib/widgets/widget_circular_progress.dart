import 'package:flutter/material.dart';
import 'package:my_tradebook/main.dart';

Widget progress = const SizedBox(
  width: 16,
  height: 16,
  child: CircularProgressIndicator(
    strokeWidth: 3,
    valueColor: AlwaysStoppedAnimation<Color>(customPrimaryColor),
  ),
);
