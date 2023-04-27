import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:intl/intl.dart';
import 'package:my_tradebook/database/firebase/trade_and_fund_data/trade_log_and_fund_data.dart';
import 'package:my_tradebook/functions/function_short_amount.dart';
import 'package:my_tradebook/main.dart';
import 'package:my_tradebook/screens/home/pages/page_add_update_trade_logs.dart';
import 'package:my_tradebook/screens/login/screen_login.dart';
import 'widget_grid_item_of_trade_log_item.dart';

enum PopupItem {
  edit,
  delete,
}

// ignore: must_be_immutable
class WidgetTradeLogItem extends StatelessWidget {
  final String type;
  final double amount;
  final DateTime date;
  final int swp;
  final int swl;
  final int intp;
  final int intl;
  final String comments;
  final String docId;
  WidgetTradeLogItem(
      {super.key,
      required this.type,
      required this.amount,
      required this.date,
      required this.swp,
      required this.swl,
      required this.intp,
      required this.intl,
      required this.comments,
      required this.docId});

  PopupItem? selectedMenu;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 9;
    final double itemWidth = size.width / 2;
    final difference = DateTime.now().difference(date);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Material(
        color: whiteColor,
        borderRadius: BorderRadius.circular(20),
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Text(
                      toBeginningOfSentenceCase(type)!,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color:
                              (type == 'profit') ? Colors.green : Colors.red),
                    ),
                  ),
                  Visibility(
                    visible: difference.inDays < 3,
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
                          Get.to(PageAddUpdateTradeLog(
                            docId: docId,
                            operation: 'Update',
                            pnl: amount.toString(),
                            comment: comments,
                            date: date,
                            swpro: swp.toString(),
                            swlo: swl.toString(),
                            intPro: intp.toString(),
                            intLo: intl.toString(),
                            type: type,
                          ));
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
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 0.2,
                    color: const Color.fromARGB(255, 206, 205, 205),
                  ),
                  borderRadius: BorderRadius.circular(15),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      whiteColor,
                      Color.fromARGB(255, 238, 238, 247),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 0),
                  child: GridView.count(
                    childAspectRatio: (itemWidth / itemHeight),
                    // childAspectRatio: 6.5 / 2,
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
                          const Text(
                            'PNL',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey),
                          ),
                          sizedBoxTen,
                          Tooltip(
                            textStyle: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                            waitDuration: const Duration(milliseconds: 100),
                            showDuration: const Duration(milliseconds: 5000),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.grey, width: 0.4),
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
                            child: Text(
                              shortenNumber(amount),
                              // amount.toString(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Trade Date',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey)),
                          sizedBoxTen,
                          SizedBox(
                            width: double.infinity,
                            child: AutoSizeText(
                              DateFormat.yMMMEd().format(date),
                              maxLines: 1,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              sizedBoxTen,
              GridView.count(
                childAspectRatio: 1.72,
                shrinkWrap: true,
                padding: const EdgeInsets.all(8),
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                crossAxisCount: 4,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  gridColumnItem(
                      context: context,
                      title: 'Swing(Profit)',
                      content: swp.toString()),
                  gridColumnItem(
                      context: context,
                      content: swl.toString(),
                      title: 'Swing(Loss)'),
                  gridColumnItem(
                      context: context,
                      title: 'Intraday(Profit)',
                      content: intp.toString()),
                  gridColumnItem(
                      context: context,
                      title: 'Intraday(Loss)',
                      content: intl.toString()),
                ],
              ),
              const Divider(),
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: const Text(
                    'Comments',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                  ),
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        comments,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    )
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
