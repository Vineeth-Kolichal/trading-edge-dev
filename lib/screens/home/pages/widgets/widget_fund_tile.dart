import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:my_tradebook/main.dart';
import 'package:my_tradebook/screens/login/screen_login.dart';

class WidgetFundTile extends StatelessWidget {
  final String type;
  final String amount;
  final DateTime date;
  WidgetFundTile(
      {super.key,
      required this.type,
      required this.amount,
      required this.date});
  String shortenNumber(double num) {
    if (num >= 100000 && num < 1000000) {
      return '${(num / 1000).toStringAsFixed(0)}K';
    } else if (num >= 1000000) {
      return '${(num / 1000000).toStringAsFixed(0)}M';
    } else {
      return num.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    String dateOut = '';
    final formatter = DateFormat.yMMMEd().format(date);
    List<String> dateList = formatter.split(' ');
    for (var i = 1; i < dateList.length; i++) {
      dateOut = dateOut + ' ' + dateList[i];
    }
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
            Text(dateOut,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                )),
            Divider(),
            GridView.count(
              childAspectRatio: 3,
              shrinkWrap: true,
              //primary: true,
              padding: const EdgeInsets.all(8),
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              crossAxisCount: 2,
              physics: const NeverScrollableScrollPhysics(),
              // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              //     crossAxisCount: 2, childAspectRatio: 3),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Transaction Type',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey)),
                    sizedBoxTen,
                    (type == 'profit' || type == 'loss')
                        ? Text('P&L',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: (type == 'profit')
                                    ? Colors.green
                                    : Colors.red))
                        : (type == 'deposite')
                            ? Text('Deposit',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green))
                            : Text('Withdraw',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.red))
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Transaction Amount',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey)),
                    sizedBoxTen,
                    Text('₹${shortenNumber(double.parse(amount))}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        )),
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
