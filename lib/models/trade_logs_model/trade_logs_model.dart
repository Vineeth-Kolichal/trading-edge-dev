
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
  int? docId;

  TradeLogsModel({
    required this.date,
    required this.type,
    required this.amount,
    required this.description,
    required this.swingProfitCount,
    required this.swingLossCount,
    required this.intradayProfitCount,
    required this.intradayLossCount,
  });
  factory TradeLogsModel.fromJson(Map<String, dynamic> json) {
    return TradeLogsModel(
      date: json['date'].toDate(),
      type: json['type'] == 'profit' ? EntryType.profit : EntryType.loss,
      amount: json['amount'].toString(),
      description: json['description'],
      swingProfitCount: json['swingProfitCount'] ?? 0,
      swingLossCount: json['swingLossCount'] ?? 0,
      intradayProfitCount: json['intradayProfitCount'] ?? 0,
      intradayLossCount: json['intradayLossCount'] ?? 0,
     // docId:json[]
    );
  }
}
