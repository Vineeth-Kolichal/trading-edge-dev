import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:trading_edge/models/trade_or_fund_model/trade_or_fund_model.dart';
import 'package:trading_edge/utils/constants/colors.dart';
import 'package:trading_edge/utils/functions/function_short_amount.dart';
import 'package:trading_edge/utils/constants/const_values.dart';
import 'package:trading_edge/utils/constants/constant_widgets.dart';
import 'package:trading_edge/view_model/fund_page_viewmodel/fund_page_viewmodel.dart';
import 'package:trading_edge/views/screen_view/home/pages/fund_page/utils/update_fund_dialoge.dart';
import 'package:trading_edge/views/screen_view/home/pages/trade_logs_page/widgets/widget_trade_log_item.dart';

class WidgetFundTile extends StatelessWidget {
  final TradeOrFundModel tradeOrFundModel;
  const WidgetFundTile({
    super.key,
    required this.tradeOrFundModel,
  });

  @override
  Widget build(BuildContext context) {
    String dateOut = '';
    final formatter = DateFormat.yMMMEd().format(tradeOrFundModel.date);
    List<String> dateList = formatter.split(' ');
    for (var i = 1; i < dateList.length; i++) {
      dateOut = '$dateOut ${dateList[i]}';
    }
    final difference = DateTime.now().difference(tradeOrFundModel.date);
    FundPageViewModel fundPageViewModel = context.read<FundPageViewModel>();
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: whiteColor,
      ),
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                visible: ((tradeOrFundModel.type == EntryType.deposite ||
                        tradeOrFundModel.type == EntryType.deposite) &&
                    difference.inDays < 3),
                child: PopupMenuButton<PopupItem>(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 0.1),
                      borderRadius: BorderRadius.circular(15)),
                  splashRadius: 20,
                  onSelected: (PopupItem item) async {
                    if (item == PopupItem.delete) {
                      context
                          .read<FundPageViewModel>()
                          .deleteFund(tradeOrFundModel.docId!);
                    } else {
                      if (tradeOrFundModel.type == EntryType.deposite) {
                        fundPageViewModel.setSwitchValue(false);
                      } else {
                        fundPageViewModel.setSwitchValue(true);
                      }
                      updateFund(
                        tradeOrFundModel: tradeOrFundModel,
                        context: context,
                      );
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
                  (tradeOrFundModel.type == EntryType.profit ||
                          tradeOrFundModel.type == EntryType.loss)
                      ? AutoSizeText(
                          maxLines: 1,
                          'P&L',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: (tradeOrFundModel.type == EntryType.profit)
                                  ? greenTextColor
                                  : redTextColor),
                        )
                      : (tradeOrFundModel.type == EntryType.deposite)
                          ? const AutoSizeText(
                              maxLines: 1,
                              'Deposit',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: greenTextColor,
                              ),
                            )
                          : const AutoSizeText(
                              maxLines: 1,
                              'Withdraw',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: redTextColor,
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
                    message: "₹ ${tradeOrFundModel.amount}",
                    child: AutoSizeText(
                        shortenNumber(
                            double.parse(tradeOrFundModel.amount.toString())),
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
    );
  }
}
