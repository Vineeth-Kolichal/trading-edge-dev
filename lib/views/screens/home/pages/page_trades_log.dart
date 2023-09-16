import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:trading_edge/main.dart';
import 'package:trading_edge/view_model/trade_log_viewmodel/trade_log_viewmodel.dart';
import 'package:trading_edge/views/screens/home/pages/widgets/widget_trade_log_item.dart';
import 'package:trading_edge/views/widgets/widget_search_gif.dart';

class PageTradesLog extends StatelessWidget {
  const PageTradesLog({super.key});

  @override
  Widget build(BuildContext context) {
    final TradeLogViewModel tradeLogViewModel =
        context.read<TradeLogViewModel>();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await tradeLogViewModel.getTradeLogs();
      },
    );

    return Consumer<TradeLogViewModel>(
      builder: (context, value, child) {
        if (value.isLoading) {
          return const Center(
              child: SpinKitCircle(
            color: whiteColor,
            duration: Duration(milliseconds: 3000),
          ));
        } else {
          return ListView.builder(
            itemBuilder: (ctx, index) {
              if (value.tradeLogList.isEmpty) {
                return const Center(child: WidgetSearchGif());
              } else {
                //return SizedBox.shrink();
                return WidgetTradeLogItem(
                  tradeOrFundModel: value.tradeLogList[index],
                );
              }
            },
            itemCount: value.tradeLogList.length,
          );
        }
      },
    );

    // return StreamBuilder(
    //     stream: tradeLogViewModel.tradeLogQuery.snapshots(),
    //     builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    // return const Center(
    //     child: SpinKitCircle(
    //   color: whiteColor,
    //   duration: Duration(milliseconds: 3000),
    // ));
    //       }
    //       if (snapshot.hasError) {
    //         return const Center(child: Text('Something went wrong 😟'));
    //       }

    //       List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = snapshot
    //           .data!.docs
    //           .cast<QueryDocumentSnapshot<Map<String, dynamic>>>();
    //       if (docs.isEmpty) {
    //         return SingleChildScrollView(
    //           child: SizedBox(
    //             height: MediaQuery.of(context).size.height * 0.7,
    //             width: MediaQuery.of(context).size.width,
    //             child: const Column(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: [
    //                 WidgetSearchGif(),
    //                 Text('No trade entries found! 😧')
    //               ],
    //             ),
    //           ),
    //         );
    //       } else {
    //         return ListView.builder(
    //           itemBuilder: (ctx, index) {
    //             Map<String, dynamic> data = docs[index].data();
    //             String docId = docs[index].id;
    //             if (docs.isEmpty) {
    //               return const Center(child: WidgetSearchGif());
    //             } else {
    //               return WidgetTradeLogItem(
    //                 docId: docId,
    //                 type: data['type'],
    //                 amount: data['amount'],
    //                 date: data['date'].toDate(),
    //                 swp: data['swing_profit'],
    //                 swl: data['swing_loss'],
    //                 intp: data['intraday_profit'],
    //                 intl: data['intraday_loss'],
    //                 comments: data['description'],
    //               );
    //             }
    //           },
    //           itemCount: docs.length,
    //         );
    //       }
    //     });
  }
}
