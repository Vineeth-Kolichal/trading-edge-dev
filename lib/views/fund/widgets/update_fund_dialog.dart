import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_tradebook/controllers/class_switch_controller.dart';
import 'package:my_tradebook/controllers/class_text_controller.dart';
import 'package:my_tradebook/core/constants/enumarators.dart';
import 'package:my_tradebook/models/fund_model/funds_model.dart';
import 'package:my_tradebook/services/fund_services/fund_services.dart';
import 'package:my_tradebook/views/login/screen_login.dart';
import 'package:my_tradebook/views/widgets/widget_text_form_field.dart';

void updateFund(
    {required String docId,
    required BuildContext context,
    required String amount,
    required DateTime date}) {
  final SwitchController controller = SwitchController();

  FundServices fundServices = FundServices();
  final formKey = GlobalKey<FormState>();
  TextEditingController amountController = TextEditingController();
  amountController.text = amount;
  DateTime selectedDate = date;
  final TextController dateShowController =
      TextController(initalDate: DateFormat.yMMMEd().format(date));

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
                  type: TextInputType.number,
                  label: 'Amount',
                  isEnabled: true,
                  controller: amountController,
                  width: MediaQuery.of(context).size.width * 0.91),
              sizedBoxTen,
              Row(
                children: [
                  IconButton(
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate:
                            DateTime.now().subtract(const Duration(days: 7)),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        final formatter = DateFormat.yMMMEd().format(picked);
                        selectedDate = picked;
                        dateShowController.updateText(formatter);
                      }
                    },
                    icon: const Icon(Icons.calendar_month_outlined),
                  ),
                  Obx(() => Text(dateShowController.myText.value)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    child: Row(
                      children: [
                        const Text(
                          'Deposite',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, color: Colors.green),
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
                          'Withdraw',
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
                side: const BorderSide(color: Colors.deepPurple),
              ),
            ),
          ),
          child: const Text(
            "Update",
            style: TextStyle(color: Colors.black),
          ),
          onPressed: () async {
            EntryType type;
            if (controller.isEnabled) {
              type = EntryType.withdraw;
            } else {
              type = EntryType.deposite;
            }
            if (formKey.currentState!.validate()) {
              FundModel fundModel = FundModel(
                  date: selectedDate,
                  type: type,
                  amount: amountController.text);
              fundServices.updateFund(
                  documentId: docId, updatedFund: fundModel);

              Get.back();
            }
          },
        ),
      ],
    ),
  );
}
