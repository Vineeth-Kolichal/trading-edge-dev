import 'package:flutter/material.dart';
import 'package:get/get.dart';

void sizingSettingAlert(String title,BuildContext context) {
  Get.dialog(
    AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 5,
      title: const Text('Warning!'),
      content: Text('Please add $title before adding new data '),
      actions: [
        ElevatedButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ))),
          child: const Text("close"),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    ),
  );
}
