import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trading_edge/database/firebase/trade_and_fund_data/trade_log_and_fund_data.dart';
import 'package:trading_edge/utils/constants/constant_widgets.dart';
import 'package:trading_edge/views/widgets/widget_appbar.dart';
import 'package:trading_edge/views/widgets/widget_error_snackbar.dart';
import 'package:toggle_switch/toggle_switch.dart';

// ignore: must_be_immutable
class PageAddUpdateTradeLog extends StatefulWidget {
  String? docId;
  String? type;
  DateTime? date;
  String? pnl;
  String? comment;
  String? swpro;
  String? swlo;
  String? intPro;
  String? intLo;
  final String operation;

  PageAddUpdateTradeLog(
      {super.key,
      this.docId,
      this.type,
      this.date,
      this.pnl,
      this.comment,
      this.swpro,
      this.swlo,
      this.intPro,
      this.intLo,
      required this.operation});

  @override
  State<PageAddUpdateTradeLog> createState() => _PageAddUpdateTradeLogState();
}

class _PageAddUpdateTradeLogState extends State<PageAddUpdateTradeLog> {
  @override
  void initState() {
    setState(() {
      _selectedDate = widget.date;
      if (widget.date != null) {
        dateOld = DateFormat.yMMMEd().format(widget.date!);
      }
      dateController.text = dateOld ?? '';
      pnlController.text = widget.pnl ?? '';
      commentController.text = widget.comment ?? '';
      swingLotController.text = widget.swlo ?? '';
      swingProtController.text = widget.swpro ?? '';
      intraLoController.text = widget.intLo ?? '';
      intraProController.text = widget.intPro ?? '';
    });
    super.initState();
  }

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
  int? seletedIndex;
  String? dateOld;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetAppbar(title: '${widget.operation} Trade'),
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
                            setState(() {
                              _selectedDate = picked;
                              dateController.text = formatter;
                            });
                          }
                        },
                        controller: dateController,
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
                        type: TextInputType.number,
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
              inputTextFormField(
                type: TextInputType.number,
                isEnabled: true,
                hint: '0',
                controller: swingProtController,
                sufixItem: 'Profit Trades',
              ),
              sizedBoxTen,
              inputTextFormField(
                  type: TextInputType.number,
                  isEnabled: true,
                  hint: '0',
                  controller: swingLotController,
                  sufixItem: 'Lose Trades'),
              sizedBoxTen,
              const Text('Intraday',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
              inputTextFormField(
                  type: TextInputType.number,
                  isEnabled: true,
                  hint: '0',
                  controller: intraProController,
                  sufixItem: 'Profit Trades'),
              sizedBoxTen,
              inputTextFormField(
                  type: TextInputType.number,
                  isEnabled: true,
                  hint: '0',
                  controller: intraLoController,
                  sufixItem: 'Lose Trades'),
              sizedBoxTen,
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.915,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (widget.operation == 'Add') {
                        bool retVal = await addTradeLoges(
                          context: context,
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
                        if (!retVal) {
                          errorSnack('Check your internet connectivity');
                        }
                        Get.back();
                      } else {
                        await updateTradeLogsAndFund(
                          docId: widget.docId!,
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

                        Get.back();
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(widget.operation),
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
              borderSide: const BorderSide(color: Colors.grey)),
          labelText: label,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          suffixText: sufixItem,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
