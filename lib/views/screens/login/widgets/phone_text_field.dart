
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:trading_edge/view_model/login_screen_viewmodel/authentication_viewmodel.dart';

class PhoneInputField extends StatelessWidget {
  const PhoneInputField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Form(
        key: context.read<AuthenticationViewModel>().formKey,
        child: IntlPhoneField(
          style: const TextStyle(fontSize: 17),
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: 'Phone Number',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(),
            ),
          ),
          initialCountryCode: 'IN',
          onChanged: (phone) {
            context
                .read<AuthenticationViewModel>()
                .setCompletePhone(phone.completeNumber);
          },
        ),
      ),
    );
  }
}
