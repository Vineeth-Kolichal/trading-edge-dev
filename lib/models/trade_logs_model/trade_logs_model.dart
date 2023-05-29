import 'package:my_tradebook/core/constants/enumarators.dart';

class TradeLogsModel {
  final DateTime date;
  final EntryType type;
  final String amount;
  final String description;
  final int swingProfitCount;
  final int swingLossCount;
  final int intradayProfitCount;
  final int intradayLossCount;
  final String? docId;

  TradeLogsModel(
      {required this.date,
      required this.type,
      required this.amount,
      required this.description,
      required this.swingProfitCount,
      required this.swingLossCount,
      required this.intradayProfitCount,
      required this.intradayLossCount,
      this.docId});
  factory TradeLogsModel.fromMap({required Map<String, dynamic> json}) {
    return TradeLogsModel(
        date: json['date'].toDate(),
        type: json['type'] == 'profit' ? EntryType.profit : EntryType.loss,
        amount: json['amount'].toString(),
        description: json['description'] ?? '',
        swingProfitCount: json['swing_profit'],
        swingLossCount: json['swing_loss'],
        intradayProfitCount: json['intraday_profit'],
        intradayLossCount: json['intraday_loss'],
        docId: json['id']);
  }
}
