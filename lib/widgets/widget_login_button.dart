import 'package:flutter/material.dart';

Widget widgetLoginButton(
    {required String label, void Function()? onPressedFunction}) {
  return SizedBox(
    width: double.infinity,
    child: Padding(
      padding: const EdgeInsets.all(4.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 5, // the elevation of the button
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // the radius of the button
          ),
        ),
        onPressed: () async {
          print('is it');
          onPressedFunction;
          print('work');
        },
        child: Text(
          label,
          style: TextStyle(fontSize: 16),
        ),
      ),
    ),
  );
}
