
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:my_tradebook/core/constants/colors.dart';
import 'package:my_tradebook/services/firebase/common_functions/tradeFundCollectionReferences.dart';
import 'package:my_tradebook/views/trade_logs/widgets/widget_trade_log_item.dart';
import 'package:my_tradebook/views/widgets/widget_search_gif.dart';

// ignore: must_be_immutable
class PageTradesLog extends StatelessWidget {
  CollectionReference tradesAndFund = tradeFundCollectionReference();
  PageTradesLog({super.key});

  @override
  Widget build(BuildContext context) {
    // TradeLogScreenController tradeLogScreenController =
    //     Get.put(TradeLogScreenController());
    // TradeLogServices tradeLogServicestra = TradeLogServices();
    // TradeLogServices().getAllTradeLogs();
//tradeLogScreenController.getAllTradeLogs();
    // return GetBuilder<TradeLogScreenController>(
    //     init: TradeLogScreenController(),
    //     builder: (controller) {
    //       if (controller.tradeLogsList.isEmpty) {
    //         return SingleChildScrollView(
    //           child: SizedBox(
    //             height: MediaQuery.of(context).size.height * 0.7,
    //             width: MediaQuery.of(context).size.width,
    //             child: Column(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: const [
    //                 WidgetSearchGif(),
    //                 Text('No trade entries found! 😧')
    //               ],
    //             ),
    //           ),
    //         );
    //       } else {
    //         return ListView.builder(
    //           itemBuilder: (ctx, index) {
    //             TradeLogsModel data = controller.tradeLogsList[index];
    //            // String docId = data.id;
    //             if (controller.tradeLogsList.isEmpty) {
    //               return const Center(child: WidgetSearchGif());
    //             } else {
    //               return WidgetTradeLogItem(
    //                // docId: docId,
    //                 type: data.type == EntryType.profit ? 'Profit' : 'Loss',
    //                 amount: double.parse(data.amount),
    //                 date: data.date,
    //                 swp: data.swingProfitCount,
    //                 swl: data.swingLossCount,
    //                 intp: data.intradayProfitCount,
    //                 intl: data.intradayLossCount,
    //                 comments: data.description,
    //               );
    //             }
    //           },
    //           itemCount: controller.tradeLogsList.length,
    //         );
    //       }
    //     });
    return StreamBuilder(
        stream: tradesAndFund
            .where('type', whereIn: ['profit', 'loss'])
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: SpinKitCircle(
              color: whiteColor,
              duration: Duration(milliseconds: 3000),
            ));
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong 😟'));
          }

          List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = snapshot
              .data!.docs
              .cast<QueryDocumentSnapshot<Map<String, dynamic>>>();
          if (docs.isEmpty) {
            return SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width,
                child:const  Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  [
                    WidgetSearchGif(),
                    Text('No trade entries found! 😧')
                  ],
                ),
              ),
            );
          } else {
            return ListView.builder(
              itemBuilder: (ctx, index) {
                Map<String, dynamic> data = docs[index].data();
                String docId = docs[index].id;
                if (docs.isEmpty) {
                  return const Center(child: WidgetSearchGif());
                } else {
                  return WidgetTradeLogItem(
                      docId: docId,
                      type: data['type'],
                      amount: data['amount'],
                      date: data['date'].toDate(),
                      swp: data['swing_profit'],
                      swl: data['swing_loss'],
                      intp: data['intraday_profit'],
                      intl: data['intraday_loss'],
                      comments: data['description']);
                }
              },
              itemCount: docs.length,
            );
          }
        });
  }
}
