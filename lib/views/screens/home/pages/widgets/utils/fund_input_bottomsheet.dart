import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:trading_edge/database/firebase/trade_and_fund_data/trade_log_and_fund_data.dart';
import 'package:trading_edge/main.dart';
import 'package:trading_edge/utils/constants/constant_widgets.dart';
import 'package:trading_edge/views/screens/home/screen_home.dart';
import 'package:trading_edge/views/widgets/custom_text_form_field.dart';
import 'package:trading_edge/views/widgets/widget_error_snackbar.dart';

void showFundInputBottomSheet(BuildContext context) {
  TextEditingController dateController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  showModalBottomSheet<void>(
    enableDrag: false,
    isDismissible: false,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    elevation: 1,
    context: context,
    builder: (BuildContext context) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.height,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Add Fund',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      InkWell(
                        onTap: () {
                          // initialLabelIndex = null;
                          dateController.clear();
                          amountController.clear();
                          Get.back();
                        },
                        child: const Icon(Icons.close),
                      )
                    ],
                  ),
                ),
                const Divider(),
                Form(
                    key: formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: TextFormField(
                            onTap: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now()
                                    .subtract(const Duration(days: 7)),
                                lastDate: DateTime.now(),
                              );
                              if (picked != null) {
                                final formatter =
                                    DateFormat.yMMMEd().format(picked);
                                // setState(() {
                                //   _selectedDate = picked;
                                //   dateController.text = formatter;
                                // });
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                            cursorColor: whiteColor,
                            keyboardType: TextInputType.none,
                            enabled: true,
                            controller: dateController,
                            decoration: InputDecoration(
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                              ),
                              labelText: 'Date',
                              hintText: 'Select Date',
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 20,
                              ),
                              suffixIcon: InkWell(
                                onTap: () async {
                                  final DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2020),
                                    // firstDate: DateTime.now()
                                    //     .subtract(const Duration(days: 7)),
                                    lastDate: DateTime.now(),
                                  );
                                  if (picked != null) {
                                    final formatter =
                                        DateFormat.yMMMEd().format(picked);
                                    // setState(() {
                                    //   _selectedDate = picked;
                                    //   dateController.text = formatter;
                                    // });
                                  }
                                },
                                child: const Icon(
                                  Icons.calendar_month_outlined,
                                  color: Colors.grey,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        sizedBoxTen,
                        Row(
                          children: [
                            ToggleSwitch(
                              minHeight: 43,
                              borderWidth: 0.75,
                              borderColor: const [Colors.grey],
                              minWidth: 90,
                              cornerRadius: 10.0,
                              activeBgColors: const [
                                [Colors.green],
                                [Colors.red]
                              ],
                              activeFgColor: Colors.white,
                              inactiveBgColor: Colors.white,
                              inactiveFgColor: Colors.black,
                              initialLabelIndex: 0,
                              totalSwitches: 2,
                              labels: const ['Deposit', 'Withdraw'],
                              radiusStyle: true,
                              onToggle: (index) {
                                // setState(() {
                                //   initialLabelIndex = index;
                                // });
                                // if (initialLabelIndex == 0) {
                                //   fundType = EntryType.deposite;
                                // }
                                // if (initialLabelIndex == 1) {
                                //   fundType = EntryType.withdraw;
                                // }
                              },
                            ),
                          ],
                        ),
                        sizedBoxTen,
                        CustomTextFormField(
                          isEnabled: true,
                          context: context,
                          controller: amountController,
                          label: 'Amount',
                          type: TextInputType.number,
                        ),
                        sizedBoxTen,
                      ],
                    )),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        bool retVal = await addTradeLoges(
                            context: context,
                            date: selectedDate!,
                            type: fundType,
                            amount: amountController.text);
                        if (!retVal) {
                          errorSnack('Check your internet connectivity');
                        }
                        dateController.clear();
                        amountController.clear();
                        // initialLabelIndex = null;

                        Get.back();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: const Text('Add'),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}