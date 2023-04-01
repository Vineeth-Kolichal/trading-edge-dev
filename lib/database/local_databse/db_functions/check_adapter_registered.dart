import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_tradebook/database/local_databse/models/positions/position_model.dart';
import 'package:my_tradebook/database/local_databse/models/sizing/sizing_model.dart';

void checkAdapterRegistered() {
  if (!Hive.isAdapterRegistered(SizingModelAdapter().typeId)) {
    Hive.registerAdapter(SizingModelAdapter());
  }
  if (!Hive.isAdapterRegistered(PositionModelAdapter().typeId)) {
    Hive.registerAdapter(PositionModelAdapter());
  }
  if (!Hive.isAdapterRegistered(TradeTypeAdapter().typeId)) {
    Hive.registerAdapter(TradeTypeAdapter());
  }
}
