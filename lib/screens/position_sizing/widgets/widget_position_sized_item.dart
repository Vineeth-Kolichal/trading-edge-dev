import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:my_tradebook/database/local_databse/models/positions/position_model.dart';
import 'package:my_tradebook/main.dart';
import 'package:my_tradebook/screens/home/pages/widgets/widget_trade_log_item.dart';
import 'package:my_tradebook/screens/login/screen_login.dart';

class WidgetPositionSizedItem extends StatelessWidget {
  PositionModel position;
 WidgetPositionSizedItem({super.key,required this.position});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      color: whiteColor,
      borderRadius: BorderRadius.circular(20),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                position.stockName,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              PopupMenuButton<PopupItem>(
                splashRadius: 20,
                onSelected: (PopupItem item) {
                  if (item == PopupItem.delete) {
                    print('delete');
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
            ],
          ),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 0),
          child: GridView.count(
            childAspectRatio: 3.2,
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
              gridItemColumn(title: 'Trade Type', content:(position.type==TradeType.buy)? 'Buy':'Sell'),
              gridItemColumn(title: 'Entry Price', content: position.entryPrice.toString(),),
              gridItemColumn(title: 'Target', content: 'Buy'),
              gridItemColumn(title: 'Stoploss', content: 'Buy'),
              gridItemColumn(title: 'Quantity', content: 'Buy')
            ],
          ),
        ),
      ]),
    );
  }

  Widget gridItemColumn({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey)),
        sizedBoxTen,
        Text(
          content,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: (content == 'Sell')
                ? Colors.red
                : (content == 'Buy')
                    ? Colors.green
                    : Colors.black,
          ),
        ),
      ],
    );
  }
}
