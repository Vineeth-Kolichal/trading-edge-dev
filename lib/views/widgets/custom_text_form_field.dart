import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.isEnabled,
    required this.context,
    this.label,
    this.sufixItem,
    required this.controller,
    this.type,
    this.hint,
  });
  final bool isEnabled;
  final BuildContext context;
  final String? label;
  final String? sufixItem;
  final TextEditingController controller;
  final TextInputType? type;
  final String? hint;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Required!';
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
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
