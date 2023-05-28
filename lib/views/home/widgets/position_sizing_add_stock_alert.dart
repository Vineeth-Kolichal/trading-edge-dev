import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_tradebook/core/constants/colors.dart';
import 'package:my_tradebook/models/positions_model/position_model.dart';
import 'package:my_tradebook/services/authentication/get_current_user_id.dart';
import 'package:my_tradebook/services/position_sizing_services/position_services.dart';
import 'package:my_tradebook/views/login/screen_login.dart';
import 'package:my_tradebook/views/widgets/widget_text_form_field.dart';

void addStock(BuildContext context) {
    PositionServices positionServices = PositionServices();
    final formKey = GlobalKey<FormState>();
    TextEditingController stockNameController = TextEditingController();

    TextEditingController entryPriceController = TextEditingController();

    var controller;
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 5,
        content: SizedBox(
          height: 160,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widgetInputTextFormField(
                    type: TextInputType.name,
                    label: 'Stock Name',
                    isEnabled: true,
                    controller: stockNameController,
                    width: MediaQuery.of(context).size.width * 0.91),
                sizedBoxTen,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widgetInputTextFormField(
                      type: TextInputType.number,
                      label: 'Entry Price',
                      isEnabled: true,
                      controller: entryPriceController,
                      width: MediaQuery.of(context).size.width * 0.3,
                    ),
                    SizedBox(
                      child: Row(
                        children: [
                          const Text(
                            'Buy',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.green),
                          ),
                          Obx(
                            () => Switch(
                              activeColor: Colors.red,
                              inactiveTrackColor:
                                  const Color.fromARGB(255, 119, 206, 122),
                              inactiveThumbColor: Colors.green,
                              value: controller.switchValue.value,
                              onChanged: (value) =>
                                  controller.toggleSwitch(value),
                            ),
                          ),
                          const Text(
                            'Sell',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
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
              "Confirm",
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () async {
              TradeType type;
              if (controller.isEnabled) {
                type = TradeType.sell;
              } else {
                type = TradeType.buy;
              }
              if (formKey.currentState!.validate()) {
                PositionModel position = PositionModel(
                  currentUserId: returnCurrentUserId(),
                  stockName: stockNameController.text.toUpperCase().trim(),
                  entryPrice: double.parse(entryPriceController.text),
                  type: type,
                );
                await positionServices.addPosition(position: position);
                Get.back();
              }
            },
          ),
        ],
      ),
    );
  }