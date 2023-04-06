import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:my_tradebook/database/firebase/trade_and_fund_data/trade_log_and_fund_data.dart';
import 'package:my_tradebook/main.dart';
import 'package:my_tradebook/screens/login/screen_login.dart';
import 'package:my_tradebook/widgets/widget_appbar.dart';
import 'package:toggle_switch/toggle_switch.dart';

class PageAddTradeLog extends StatefulWidget {
  const PageAddTradeLog({super.key});

  @override
  State<PageAddTradeLog> createState() => _PageAddTradeLogState();
}

class _PageAddTradeLogState extends State<PageAddTradeLog> {
  FocusNode focusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  TextEditingController dateController = TextEditingController();
  TextEditingController pnlController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  TextEditingController swingLotController = TextEditingController();
  TextEditingController swingProtController = TextEditingController();
  TextEditingController intraProController = TextEditingController();
  TextEditingController intraLoController = TextEditingController();
  EntryType type = EntryType.profit;
  int? seletedIndex = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetAppbar(title: 'Add Trade'),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate:
                              DateTime.now().subtract(const Duration(days: 7)),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          final formatter = DateFormat.yMMMEd().format(picked);
                          setState(() {
                            _selectedDate = picked;
                            dateController.text = formatter;
                          });
                        }
                      },
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.915,
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Fill details';
                            }
                            return null;
                          },
                          cursorColor: whiteColor,
                          enabled: false,
                          onTap: () async {},
                          controller: dateController,
                          decoration: InputDecoration(
                              disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.grey)),
                              labelText: 'Trade Date',
                              hintText: 'Select Date',
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              suffixIcon: Icon(
                                Icons.calendar_month_outlined,
                                color: Colors.grey,
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
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
                      initialLabelIndex: seletedIndex,
                      totalSwitches: 2,
                      labels: const ['Profit', 'Loss'],
                      radiusStyle: true,
                      onToggle: (index) {
                        setState(() {
                          seletedIndex = index;
                        });
                        if (index == 0) {
                          type = EntryType.profit;
                        } else {
                          type = EntryType.loss;
                        }
                      },
                    ),
                    sizedBoxTen,
                    inputTextFormField(
                        isEnabled: true,
                        label: 'Net Realized P&L',
                        controller: pnlController),
                    sizedBoxTen,
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.915,
                      child: TextFormField(
                        controller: commentController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Fill details';
                          }
                          return null;
                        },
                        minLines: 3, // Set this
                        maxLines: 4, // and this
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                            disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.grey)),
                            labelText: "What's on your mind (comments)",
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    ),
                    sizedBoxTen,
                  ],
                ),
              ),
              Text(
                'Additional Details(Optional)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              sizedBoxTen,
              Text(
                'Swing',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
              inputTextFormField(
                isEnabled: true,
                hint: '0',
                controller: swingProtController,
                sufixItem: 'Profit Trades',
              ),
              sizedBoxTen,
              inputTextFormField(
                  isEnabled: true,
                  hint: '0',
                  controller: swingLotController,
                  sufixItem: 'Lose Trades'),
              sizedBoxTen,
              Text('Intraday',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
              inputTextFormField(
                  isEnabled: true,
                  hint: '0',
                  controller: intraProController,
                  sufixItem: 'Profit Trades'),
              sizedBoxTen,
              inputTextFormField(
                  isEnabled: true,
                  hint: '0',
                  controller: intraLoController,
                  sufixItem: 'Lose Trades'),
              sizedBoxTen,
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.915,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {}
                    await addTradeLoges(
                      date: _selectedDate!,
                      type: type,
                      amount: pnlController.text,
                      description: commentController.text,
                      swPro: (swingProtController.text.isNotEmpty)
                          ? int.parse(swingProtController.text)
                          : 0,
                      swLo: (swingLotController.text.isNotEmpty)
                          ? int.parse(swingLotController.text)
                          : 0,
                      intraPro: (intraProController.text.isNotEmpty)
                          ? int.parse(intraProController.text)
                          : 0,
                      intraLo: (intraLoController.text.isNotEmpty)
                          ? int.parse(intraLoController.text)
                          : 0,
                    );
                    // await addTradeCount(
                    //   swPro: (swingProtController.text.isNotEmpty)
                    //       ? int.parse(swingProtController.text)
                    //       : 0,
                    //   swLo: (swingLotController.text.isNotEmpty)
                    //       ? int.parse(swingLotController.text)
                    //       : 0,
                    //   intraPro: (intraProController.text.isNotEmpty)
                    //       ? int.parse(intraProController.text)
                    //       : 0,
                    //   intraLo: (intraLoController.text.isNotEmpty)
                    //       ? int.parse(intraLoController.text)
                    //       : 0,
                    // );
                    Get.back();
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
  }

  Widget inputTextFormField(
      {required bool isEnabled,
      String? label,
      String? sufixItem,
      required TextEditingController controller,
      TextInputType? type,
      String? hint}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.915,
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Fill details';
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
                borderSide: BorderSide(color: Colors.grey)),
            labelText: label,
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            suffixText: sufixItem,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      ),
    );
  }
}
