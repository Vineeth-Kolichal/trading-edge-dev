import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:trading_edge/models/trade_or_fund_model/trade_or_fund_model.dart';
import 'package:trading_edge/data/services/current_user_data.dart';
import 'package:trading_edge/utils/constants/const_values.dart';
import 'package:trading_edge/utils/constants/constant_widgets.dart';
import 'package:trading_edge/view_model/trade_log_viewmodel/trade_log_viewmodel.dart';
import 'package:trading_edge/views/widgets/custom_text_form_field.dart';
import 'package:trading_edge/views/widgets/widget_appbar.dart';
import 'package:toggle_switch/toggle_switch.dart';

class AddUpdateTradeLogScreen extends StatelessWidget {
 final TradeOrFundModel? tradeModel;
 const  AddUpdateTradeLogScreen({super.key, this.tradeModel});


  @override
  Widget build(BuildContext context) {
    TradeLogViewModel tlvm = context.read<TradeLogViewModel>();
    if (tradeModel != null) {
      tlvm.setValuesForUpdateScreen(tradeModel!);
    }
    return Scaffold(
      appBar:
          WidgetAppbar(title: '${tradeModel == null ? 'Add' : 'Update'} Trade'),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                key: tlvm.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.915,
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.none,
                        enabled: true,
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

                            tlvm.selectedDate = picked;
                            tlvm.dateController.text = formatter;
                          }
                        },
                        controller: tlvm.dateController,
                        decoration: InputDecoration(
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          labelText: 'Trade Date',
                          hintText: 'Select Date',
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          suffixIcon: const Icon(
                            Icons.calendar_month_outlined,
                            color: Colors.grey,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    sizedBoxTen,
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
                      initialLabelIndex: tradeModel != null
                          ? tradeModel!.type == EntryType.profit
                              ? 0
                              : 1
                          : null,
                      totalSwitches: 2,
                      labels: const ['Profit', 'Loss'],
                      radiusStyle: true,
                      onToggle: (index) {
                        if (index == 0) {
                         tlvm. type = EntryType.profit;
                        } else {
                         tlvm. type = EntryType.loss;
                        }
                      },
                    ),
                    sizedBoxTen,
                    CustomTextFormField(
                        type: TextInputType.number,
                        isEnabled: true,
                        label: 'Net Realized P&L',
                        controller: tlvm.pnlController),
                    sizedBoxTen,
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.915,
                      child: TextFormField(
                        controller: tlvm.commentController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                        minLines: 3,
                        maxLines: 4,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.grey)),
                          labelText: "What's on your mind (comments)",
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    sizedBoxTen,
                  ],
                ),
              ),
              const Text(
                'Additional Details(Optional)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              sizedBoxTen,
              const Text(
                'Swing',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
              CustomTextFormField(
                type: TextInputType.number,
                isEnabled: true,
                hint: '0',
                controller: tlvm.swingProtController,
                sufixItem: 'Profit Trades',
              ),
              sizedBoxTen,
              CustomTextFormField(
                  type: TextInputType.number,
                  isEnabled: true,
                  hint: '0',
                  controller: tlvm.swingLotController,
                  sufixItem: 'Lose Trades'),
              sizedBoxTen,
              const Text('Intraday',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
              CustomTextFormField(
                  type: TextInputType.number,
                  isEnabled: true,
                  hint: '0',
                  controller: tlvm.intraProController,
                  sufixItem: 'Profit Trades'),
              sizedBoxTen,
              CustomTextFormField(
                  type: TextInputType.number,
                  isEnabled: true,
                  hint: '0',
                  controller: tlvm.intraLoController,
                  sufixItem: 'Lose Trades'),
              sizedBoxTen,
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.915,
                child: ElevatedButton(
                  onPressed: () async {
                    if (tlvm.formKey.currentState!.validate()) {
                      if (tradeModel == null) {
                        TradeOrFundModel tradeOrFundModel = TradeOrFundModel(
                            userId: CurrentUserData.returnCurrentUserId(),
                            type:tlvm. type,
                            amount:
                                double.parse(tlvm.pnlController.text.trim()),
                            date: tlvm.selectedDate!,
                            comments: tlvm.commentController.text,
                            swingProfit: tlvm.swingProtController.text.isEmpty
                                ? 0
                                : int.parse(
                                    tlvm.swingProtController.text.trim()),
                            swingLoss: tlvm.swingLotController.text.isEmpty
                                ? 0
                                : int.parse(
                                    tlvm.swingLotController.text.trim()),
                            intraLoss: tlvm.intraLoController.text.isEmpty
                                ? 0
                                : int.parse(tlvm.intraLoController.text.trim()),
                            intraProfit: tlvm.intraProController.text.isEmpty
                                ? 0
                                : int.parse(
                                    tlvm.intraProController.text.trim()));
                        tlvm.addTrades(tradeOrFundModel);

                        Navigator.of(context).pop();
                      } else {
                        TradeOrFundModel tradeOrFundModel = TradeOrFundModel(
                          userId: CurrentUserData.returnCurrentUserId(),
                          type:tlvm. type,
                          amount: double.parse(tlvm.pnlController.text.trim()),
                          date: tlvm.selectedDate!,
                          comments: tlvm.commentController.text,
                          swingProfit: tlvm.swingProtController.text.isEmpty
                              ? 0
                              : int.parse(tlvm.swingProtController.text.trim()),
                          swingLoss: tlvm.swingLotController.text.isEmpty
                              ? 0
                              : int.parse(tlvm.swingLotController.text.trim()),
                          intraLoss: tlvm.intraLoController.text.isEmpty
                              ? 0
                              : int.parse(tlvm.intraLoController.text.trim()),
                          intraProfit: tlvm.intraProController.text.isEmpty
                              ? 0
                              : int.parse(
                                  tlvm.intraProController.text.trim(),
                                ),
                        );
                        tlvm.updateTradeLog(
                            tradeOrFundModel, tradeModel!.docId!);

                        Navigator.of(context).pop();
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(tradeModel == null ? 'Add' : 'Update'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
