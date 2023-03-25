import 'package:flutter/material.dart';
import 'package:my_tradebook/screens/home/pages/widgets/widget_trade_log_item.dart';

class PageTradesLog extends StatelessWidget {
  const PageTradesLog({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (ctx, index) {
        return WidgetTradeLogItem();
      },
      itemCount: 20,
    );
  }
}
