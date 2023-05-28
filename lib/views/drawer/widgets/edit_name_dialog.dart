import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_tradebook/core/constants/colors.dart';
import 'package:my_tradebook/views/drawer/widgets/profile_secrion.dart';

void editNameDialoge(String name) async {
  final formGlobalKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();

  nameController.text = name;
  Get.dialog(AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    title: const Text(
      'Edit Name',
      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
    ),
    content: Form(
      key: formGlobalKey,
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your name ';
          }
          return null;
        },
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
        controller: nameController,
      ),
    ),
    actions: [
      ElevatedButton(
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ))),
        child: const Text("Cancel"),
        onPressed: () => Get.back(),
      ),
      ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: const BorderSide(color: customPrimaryColor),
            ),
          ),
        ),
        child: const Text(
          "Update",
          style: TextStyle(color: Colors.black),
        ),
        onPressed: () async {
          if (formGlobalKey.currentState!.validate()) {
            await profileController.changeName(nameController.text.trim());
            Get.back();
          }
        },
      ),
    ],
  ));
}
