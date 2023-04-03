import 'package:flutter/material.dart';

Widget inputTextFormField(
    {required bool isEnabled,
    String? label,
    String? sufixItem,
    required TextEditingController controller,
    TextInputType? type,
    String? hint,
    required double width}) {
  return SizedBox(
    width: width,
    child: TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Fill details';
        }
        if (value == '0') {
          return 'please add corrent value';
        }
        return null;
      },
      keyboardType: type,
      enabled: isEnabled,
      controller: controller,
      decoration: InputDecoration(
          hintText: hint,
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.grey)),
          labelText: label,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          suffixText: sufixItem,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    ),
  );
}
