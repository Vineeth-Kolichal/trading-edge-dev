import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:trading_edge/utils/constants/colors.dart';
import 'package:trading_edge/view_model/trade_log_viewmodel/trade_log_viewmodel.dart';
import 'package:trading_edge/views/screen_view/home/pages/widgets/widget_trade_log_item.dart';
import 'package:trading_edge/views/widgets/no_data_animation.dart';

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
          if (value.tradeLogList.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  NoDataAnimation(),
                  Text('No trade entries found! 😧')
                ],
              ),
            );
          }
          return ListView.builder(
            itemBuilder: (ctx, index) {
              if (value.tradeLogList.isEmpty) {
                return const Center(child: NoDataAnimation());
              } else {
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
  }
}
