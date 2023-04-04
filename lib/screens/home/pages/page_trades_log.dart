import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_tradebook/authentication/get_current_user_id.dart';
import 'package:my_tradebook/database/firebase/trade_and_fund_data/trade_log_and_fund_data.dart';
import 'package:my_tradebook/screens/home/pages/widgets/widget_trade_log_item.dart';

class PageTradesLog extends StatelessWidget {
  CollectionReference tradesAndFund = FirebaseFirestore.instance
      .collection('users')
      .doc(returnCurrentUserId())
      .collection('Trades_and_fund');
  PageTradesLog({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: tradesAndFund
            // .where('type', whereIn: ['profit', 'loss'])
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('Loading');
          }

          List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = snapshot
              .data!.docs
              .cast<QueryDocumentSnapshot<Map<String, dynamic>>>();

          return ListView.builder(
            itemBuilder: (ctx, index) {
              Map<String, dynamic> data = docs[index].data();
              return WidgetTradeLogItem(
                  type: data['type'],
                  amount: data['amount'],
                  date: data['date'].toDate(),
                  swp: data['swing_profit'],
                  swl: data['swing_loss'],
                  intp: data['intraday_profit'],
                  intl: data['intraday_loss'],
                  comments: data['description']);
            },
            itemCount: docs.length,
          );
        });
  }
}
