import 'package:my_tradebook/core/constants/enumarators.dart';

class FundModel {
  final DateTime date;
  final EntryType type;
  final String amount;

  FundModel({
    required this.date,
    required this.type,
    required this.amount,
  });
}
