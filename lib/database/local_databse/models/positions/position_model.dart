import 'package:hive_flutter/hive_flutter.dart';
part 'position_model.g.dart';

@HiveType(typeId: 1)
enum TradeType {
  @HiveField(0)
  buy,
  @HiveField(1)
  sell,
}

@HiveType(typeId: 2)
class PositionModel extends HiveObject {
  @HiveField(0)
  String stockName;
  @HiveField(1)
  double entryPrice;
  @HiveField(2)
  TradeType type;
  PositionModel(
      {required this.stockName, required this.entryPrice, required this.type});
}
