import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_tradebook/controllers/trades_logs_controllers/trades_log_screen_controller.dart';
import 'package:my_tradebook/core/constants/enumarators.dart';
import 'package:my_tradebook/models/trade_logs_model/trade_logs_model.dart';
import 'package:my_tradebook/services/trade_logs_services/trade_logs_services.dart';
import 'package:my_tradebook/views/trade_logs/widgets/widget_trade_log_item.dart';
import 'package:my_tradebook/views/widgets/widget_search_gif.dart';

class PageTradesLog extends StatelessWidget {
 const  PageTradesLog({super.key});

  @override
  Widget build(BuildContext context) {
    TradeLogScreenController tradeLogScreenController =
        Get.put(TradeLogScreenController());
    TradeLogServices().getAllTradeLogs();
    return Obx(() {
      if (tradeLogScreenController.tradeLogList.isEmpty) {
        return SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            width: MediaQuery.of(context).size.width,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [WidgetSearchGif(), Text('No trade entries found! 😧')],
            ),
          ),
        );
      } else {
        return ListView.builder(
          itemBuilder: (ctx, index) {
            TradeLogsModel data = tradeLogScreenController.tradeLogList[index];
            if (tradeLogScreenController.tradeLogList.isEmpty) {
              return const Center(child: WidgetSearchGif());
            } else {
              return WidgetTradeLogItem(
                docId: data.docId!,
                type: data.type == EntryType.profit ? 'profit' : 'loss',
                amount: double.parse(data.amount),
                date: data.date,
                swp: data.swingProfitCount,
                swl: data.swingLossCount,
                intp: data.intradayProfitCount,
                intl: data.intradayLossCount,
                comments: data.description,
              );
            }
          },
          itemCount: tradeLogScreenController.tradeLogList.length,
        );
      }
    });
  }
}
