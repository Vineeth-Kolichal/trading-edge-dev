import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trading_edge/utils/constants/const_values.dart';

class TradeOrFundModel {
  final EntryType type;
  final double amount;
  final DateTime date;
  int? swingProfit;
  int? swingLoss;
  int? intraProfit;
  int? intraLoss;
  String? comments;
  final String userId;
  String? docId;

  TradeOrFundModel(
      {required this.userId,
      required this.type,
      required this.amount,
      required this.date,
      this.comments,
      this.intraLoss,
      this.intraProfit,
      this.swingLoss,
      this.swingProfit,
      this.docId});
  factory TradeOrFundModel.fromMap(Map<String, dynamic> map) {
    if (map['type'] == "profit" || map['type'] == "loss") {
      return TradeOrFundModel(
        userId: map['userId'],
        type: map['type'] == "profit" ? EntryType.profit : EntryType.loss,
        amount: map['amount'],
        date: map['date'].toDate(),
        swingLoss: map['swing_loss'],
        swingProfit: map['swing_profit'],
        intraProfit: map['intraday_profit'],
        intraLoss: map['intraday_loss'],
        comments: map['description'],
        docId: map['docId']
      );
    } else {
      return TradeOrFundModel(
        userId: map['userId'],
        type:
            map['type'] == "deposite" ? EntryType.deposite : EntryType.withdraw,
        amount: map['amount'],
        date: map['date'].toDate(),
        docId: map['docId']
      );
    }
  }
  Map<String, dynamic> toMap() {
    if (type == EntryType.profit || type == EntryType.loss) {
      return {
        "userId": userId,
        "type": type == EntryType.profit ? "profit" : "loss",
        "amount": amount,
        "date": Timestamp.fromDate(date),
        "swing_loss": swingLoss,
        "swing_profit": swingProfit,
        "intraday_profit": intraProfit,
        "intraday_loss": intraLoss,
        "description": comments
      };
    } else {
      return {
        "userId": userId,
        "type": type == EntryType.deposite ? "deposite" : "withdraw",
        "amount": amount,
        "date": Timestamp.fromDate(date),
      };
    }
  }
}
