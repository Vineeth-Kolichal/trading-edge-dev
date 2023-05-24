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
}
