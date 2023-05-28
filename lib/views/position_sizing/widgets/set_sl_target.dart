  import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_tradebook/core/constants/colors.dart';
import 'package:my_tradebook/models/sizing_model/sizing_model.dart';
import 'package:my_tradebook/services/authentication/get_current_user_id.dart';
import 'package:my_tradebook/services/position_sizing_services/sizing_services.dart';
import 'package:my_tradebook/views/login/screen_login.dart';
import 'package:my_tradebook/views/widgets/widget_text_form_field.dart';

void setTargetAndStoploss() {
    SizingServices sizingServices = SizingServices();
    final formKey = GlobalKey<FormState>();
    TextEditingController targetAmountController = TextEditingController();
    TextEditingController targetPercentageController = TextEditingController();
    TextEditingController stopLossPercentageController =
        TextEditingController();

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 5,
        content: SizedBox(
          height: 160,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widgetInputTextFormField(
                  type: TextInputType.number,
                  label: 'Target Amount',
                  isEnabled: true,
                  controller: targetAmountController,
                  width: 300,
                ),
                sizedBoxTen,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widgetInputTextFormField(
                      type: TextInputType.number,
                      label: 'Target(%)',
                      isEnabled: true,
                      controller: targetPercentageController,
                      width: 100,
                    ),
                    widgetInputTextFormField(
                      type: TextInputType.number,
                      label: 'SL(%)',
                      isEnabled: true,
                      controller: stopLossPercentageController,
                      width: 100,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
            ),
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
              "Confirm",
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                SizingModel sm = SizingModel(
                  targetAmount: double.parse(
                    targetAmountController.text.trim(),
                  ),
                  targetPercentage: double.parse(
                    targetPercentageController.text.trim(),
                  ),
                  stoplossPercentage: double.parse(
                    stopLossPercentageController.text.trim(),
                  ),
                );
                sizingServices.addOrUpdateSizing(
                    sizing: sm, key: returnCurrentUserId());
                Get.back();
              }
            },
          ),
        ],
      ),
    );
  }