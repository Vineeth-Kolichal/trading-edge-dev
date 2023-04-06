import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_tradebook/database/firebase/trade_and_fund_data/trade_log_and_fund_data.dart';
import 'package:my_tradebook/functions/function_short_amount.dart';
import 'package:my_tradebook/main.dart';
import 'package:my_tradebook/screens/home/pages/widgets/widget_trade_log_item.dart';
import 'package:my_tradebook/screens/login/screen_login.dart';

class WidgetFundTile extends StatelessWidget {
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
  Widget build(BuildContext context) {
    String dateOut = '';
    final formatter = DateFormat.yMMMEd().format(date);
    List<String> dateList = formatter.split(' ');
    for (var i = 1; i < dateList.length; i++) {
      dateOut = '$dateOut ${dateList[i]}';
    }
    final difference = DateTime.now().difference(date);
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
                  child: Text(
                    dateOut,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Visibility(
                  visible: ((type == 'deposite' || type == 'withdraw') &&
                      difference.inDays < 3),
                  child: PopupMenuButton<PopupItem>(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(width: 0.1),
                        borderRadius: BorderRadius.circular(15)),
                    splashRadius: 20,
                    onSelected: (PopupItem item) async {
                      if (item == PopupItem.delete) {
                        await deleteDoc(docId);
                      } else {
                        print('Update');
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
              childAspectRatio: 3,
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
                    const Text('Transaction Type',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey)),
                    sizedBoxTen,
                    (type == 'profit' || type == 'loss')
                        ? Text(
                            'P&L',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: (type == 'profit')
                                    ? Colors.green
                                    : Colors.red),
                          )
                        : (type == 'deposite')
                            ? const Text(
                                'Deposit',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green,
                                ),
                              )
                            : const Text(
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
                    const Text('Transaction Amount',
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
                      message: "₹ $amount",
                      child: Text('₹${shortenNumber(double.parse(amount))}',
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
}
