import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_tradebook/database/firebase/trade_and_fund_data/trade_log_and_fund_data.dart';
import 'package:my_tradebook/functions/function_short_amount.dart';
import 'package:my_tradebook/getx_controller_classes/class_switch_controller.dart';
import 'package:my_tradebook/getx_controller_classes/class_text_controller.dart';
import 'package:my_tradebook/main.dart';
import 'package:my_tradebook/screens/home/pages/widgets/widget_trade_log_item.dart';
import 'package:my_tradebook/screens/login/screen_login.dart';
import 'package:my_tradebook/widgets/widget_text_form_field.dart';

class WidgetFundTile extends StatefulWidget {
  final String type;
  final String amount;
  final DateTime date;
  final String docId;
  const WidgetFundTile(
      {super.key,
      required this.type,
      required this.amount,
      required this.date,
      required this.docId});

  @override
  State<WidgetFundTile> createState() => _WidgetFundTileState();
}

class _WidgetFundTileState extends State<WidgetFundTile> {
  final SwitchController controller = Get.put(SwitchController());

  @override
  Widget build(BuildContext context) {
    String dateOut = '';
    final formatter = DateFormat.yMMMEd().format(widget.date);
    List<String> dateList = formatter.split(' ');
    for (var i = 1; i < dateList.length; i++) {
      dateOut = '$dateOut ${dateList[i]}';
    }
    final difference = DateTime.now().difference(widget.date);
    return Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: whiteColor,
        ),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: AutoSizeText(
                    maxLines: 1,
                    dateOut,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Visibility(
                  visible: ((widget.type == 'deposite' ||
                          widget.type == 'withdraw') &&
                      difference.inDays < 3),
                  child: PopupMenuButton<PopupItem>(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(width: 0.1),
                        borderRadius: BorderRadius.circular(15)),
                    splashRadius: 20,
                    onSelected: (PopupItem item) async {
                      if (item == PopupItem.delete) {
                        await deleteDoc(widget.docId);
                      } else {
                        if (widget.type == 'deposite') {
                          controller.switchValue.value = false;
                        } else {
                          controller.switchValue.value = true;
                        }
                        updateFund(
                            docId: widget.docId,
                            context: context,
                            amount: widget.amount,
                            date: widget.date);
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<PopupItem>>[
                      const PopupMenuItem<PopupItem>(
                        value: PopupItem.edit,
                        child: Text('Edit'),
                      ),
                      const PopupMenuItem<PopupItem>(
                        value: PopupItem.delete,
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const Divider(),
            GridView.count(
              childAspectRatio: 2.5,
              shrinkWrap: true,
              padding: const EdgeInsets.all(8),
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              crossAxisCount: 2,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AutoSizeText('Transaction Type',
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey)),
                    sizedBoxTen,
                    (widget.type == 'profit' || widget.type == 'loss')
                        ? AutoSizeText(
                            maxLines: 1,
                            'P&L',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: (widget.type == 'profit')
                                    ? Colors.green
                                    : Colors.red),
                          )
                        : (widget.type == 'deposite')
                            ? const AutoSizeText(
                                maxLines: 1,
                                'Deposit',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green,
                                ),
                              )
                            : const AutoSizeText(
                                maxLines: 1,
                                'Withdraw',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red,
                                ),
                              ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AutoSizeText('Transaction Amount',
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey)),
                    sizedBoxTen,
                    Tooltip(
                      textStyle: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500),
                      waitDuration: const Duration(milliseconds: 100),
                      showDuration: const Duration(milliseconds: 5000),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 0.4),
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            whiteColor,
                            Color.fromARGB(255, 238, 238, 247),
                          ],
                        ),
                        // color: customPrimaryColor[200],
                      ),
                      message: "₹ ${widget.amount}",
                      child: AutoSizeText(
                          shortenNumber(double.parse(widget.amount)),
                          maxLines: 1,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          )),
                    ),
                  ],
                )
              ],
            )
          ]),
        ),
      ),
    );
  }

  void updateFund(
      {required String docId,
      required BuildContext context,
      required String amount,
      required DateTime date}) {
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
                await updateTradeLogsAndFund(
                    docId: docId,
                    date: selectedDate,
                    type: type,
                    amount: amountController.text);

                Get.back();
              }
            },
          ),
        ],
      ),
    );
  }
}
