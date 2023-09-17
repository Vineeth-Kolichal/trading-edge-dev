import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:trading_edge/data/services/current_user_data.dart';
import 'package:trading_edge/models/trade_or_fund_model/trade_or_fund_model.dart';
import 'package:trading_edge/utils/constants/colors.dart';
import 'package:trading_edge/utils/constants/const_values.dart';
import 'package:trading_edge/utils/constants/constant_widgets.dart';
import 'package:trading_edge/view_model/fund_page_viewmodel/fund_page_viewmodel.dart';
import 'package:trading_edge/views/widgets/custom_text_form_field.dart';

void showFundInputBottomSheet(BuildContext context) {
  EntryType fundType = EntryType.deposite;
  TextEditingController dateController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  DateTime? selectedDate;
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
                          Navigator.of(context).pop();
                        },
                        child: const Icon(Icons.close),
                      )
                    ],
                  ),
                ),
                const Divider(),
                Form(
                    key: context.read<FundPageViewModel>().formKey,
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
                                selectedDate = picked;
                                dateController.text = formatter;
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
                                    selectedDate = picked;
                                    dateController.text = formatter;
                                    log(selectedDate.toString());
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
                              initialLabelIndex: null,
                              minHeight: 43,
                              borderWidth: 0.75,
                              borderColor: const [Colors.grey],
                              minWidth: 90,
                              cornerRadius: 10.0,
                              activeBgColors: const [
                                [greenTextColor],
                                [redTextColor]
                              ],
                              activeFgColor: Colors.white,
                              inactiveBgColor: Colors.white,
                              inactiveFgColor: Colors.black,
                              totalSwitches: 2,
                              labels: const ['Deposit', 'Withdraw'],
                              radiusStyle: true,
                              onToggle: (index) {
                                if (index == 0) {
                                  fundType = EntryType.deposite;
                                }
                                if (index == 1) {
                                  fundType = EntryType.withdraw;
                                }
                              },
                            ),
                          ],
                        ),
                        sizedBoxTen,
                        CustomTextFormField(
                          isEnabled: true,
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
                      if (context
                          .read<FundPageViewModel>()
                          .formKey
                          .currentState!
                          .validate()) {
                        TradeOrFundModel tradeOrFundModel = TradeOrFundModel(
                          userId: CurrentUserData.returnCurrentUserId(),
                          type: fundType,
                          amount: double.parse(amountController.text.trim()),
                          date: selectedDate!,
                        );
                        context
                            .read<FundPageViewModel>()
                            .addFund(tradeOrFundModel);

                        dateController.clear();
                        amountController.clear();

                        Navigator.of(context).pop();
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
