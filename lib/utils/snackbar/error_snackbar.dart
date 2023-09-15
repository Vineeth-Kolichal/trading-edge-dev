import 'package:flutter/material.dart';

SnackBar errorSnackbar() {
    return const SnackBar(
      behavior: SnackBarBehavior.floating,
      padding: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      content: Text('Error while sign in'),
      backgroundColor: Colors.red,
    );
  }