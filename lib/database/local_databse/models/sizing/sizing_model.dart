import 'package:hive_flutter/hive_flutter.dart';
part 'sizing_model.g.dart';

@HiveType(typeId: 0)
class SizingModel {
  @HiveField(0)
  double targetAmount;
  @HiveField(1)
  double targetPercentage;
  @HiveField(2)
  double stoplossPercentage;
  SizingModel(
      {required this.targetAmount,
      required this.targetPercentage,
      required this.stoplossPercentage});
}
