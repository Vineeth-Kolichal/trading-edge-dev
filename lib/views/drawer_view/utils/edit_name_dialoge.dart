import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trading_edge/utils/constants/colors.dart';
import 'package:trading_edge/view_model/user_profile_viewmodel/user_profile_viewmodel.dart';

void editNameDialoge(BuildContext context, String name) async {
  final formGlobalKey = GlobalKey<FormState>();

  UserProfileViewModel userProfileViewModel =
      context.read<UserProfileViewModel>();
  userProfileViewModel.nameController.text = name;

  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                    contentPadding:
                        const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
                controller: userProfileViewModel.nameController,
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
                onPressed: () => Navigator.of(context).pop(),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
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
                    await userProfileViewModel.updateName();
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ));
}
