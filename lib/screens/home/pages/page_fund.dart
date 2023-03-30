import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:my_tradebook/screens/home/pages/widgets/widget_fund_tile.dart';
import 'package:my_tradebook/screens/login/screen_login.dart';

class PageFund extends StatelessWidget {
  const PageFund({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListView.separated(
        //shrinkWrap: true,
        itemBuilder: ((context, index) {
          final DateTime today = DateTime.now();
          return WidgetFundTile(
            amount: '100000.00',
            type: 'loss',
            date: today,
          );
        }),
        separatorBuilder: (context, index) => sizedBoxTen,
        itemCount: 5,
      ),
    );
  }
}
