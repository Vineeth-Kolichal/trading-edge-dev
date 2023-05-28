import 'package:flutter/material.dart';




// ignore: must_be_immutable
class InputTextFormField extends StatelessWidget {
  InputTextFormField({super.key, required this.isEnabled, required this.controller,this.hint,this.label,this.sufixItem,this.type});
  final bool isEnabled;
  String? label;
  String? sufixItem;
  final TextEditingController controller;
  TextInputType? type;
  String? hint;

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
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      ),
    );
  }
}
