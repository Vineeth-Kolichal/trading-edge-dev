import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trading_edge/data/current_user_data.dart';

class TradeLogViewModel extends ChangeNotifier {
  static final CollectionReference tradesAndFund = FirebaseFirestore.instance
      .collection('users')
      .doc(CurrentUserData.returnCurrentUserId())
      .collection('Trades_and_fund');
  final Query<Object?> tradeLogQuery = tradesAndFund.where('type',
      whereIn: ['profit', 'loss']).orderBy('date', descending: true);
}
