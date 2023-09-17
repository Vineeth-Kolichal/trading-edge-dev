import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:trading_edge/data/services/current_user_data.dart';
import 'package:trading_edge/models/trade_or_fund_model/trade_or_fund_model.dart';
import 'package:trading_edge/utils/constants/const_values.dart';
import 'package:trading_edge/utils/constants/constant_widgets.dart';
import 'package:trading_edge/view_model/fund_page_viewmodel/fund_page_viewmodel.dart';
import 'package:trading_edge/views/widgets/widget_text_form_field.dart';

void updateFund(
    {required TradeOrFundModel tradeOrFundModel,
    required BuildContext context}) {
  final formKey = GlobalKey<FormState>();
  TextEditingController amountController = TextEditingController();
  amountController.text = tradeOrFundModel.amount.toString();
  DateTime selectedDate = tradeOrFundModel.date;
  context
      .read<FundPageViewModel>()
      .setDateText(DateFormat.yMMMEd().format(tradeOrFundModel.date));

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
                        Future.delayed(const Duration(microseconds: 100), (() {
                          context
                              .read<FundPageViewModel>()
                              .setDateText(formatter);
                        }));
                      }
                    },
                    icon: const Icon(Icons.calendar_month_outlined),
                  ),
                  Selector<FundPageViewModel, String>(
                      selector: (p0, p1) => p1.dateText,
                      builder: (context, dateText, _) {
                        return Text(dateText);
                      }),
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
                        Selector<FundPageViewModel, bool>(
                            selector: (p0, p1) => p1.switchValue,
                            builder: (context, switchValue, _) {
                              return Switch(
                                activeColor: Colors.red,
                                inactiveTrackColor:
                                    const Color.fromARGB(255, 119, 206, 122),
                                inactiveThumbColor: Colors.green,
                                value: switchValue,
                                onChanged: (value) => context
                                    .read<FundPageViewModel>()
                                    .setSwitchValue(value),
                              );
                            }),
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
          onPressed: () => Navigator.of(context).pop(),
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
            if (context.read<FundPageViewModel>().switchValue) {
              type = EntryType.withdraw;
            } else {
              type = EntryType.deposite;
            }
            if (formKey.currentState!.validate()) {
              TradeOrFundModel updateFund = TradeOrFundModel(
                  userId: CurrentUserData.returnCurrentUserId(),
                  type: type,
                  amount: double.parse(amountController.text),
                  date: selectedDate);
              context
                  .read<FundPageViewModel>()
                  .updateFundTransaction(updateFund, tradeOrFundModel.docId!);

              Navigator.of(context).pop();
            }
          },
        ),
      ],
    ),
  );
}
