import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_tradebook/models/positions_model/position_model.dart';
import 'package:my_tradebook/models/sizing_model/sizing_model.dart';

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
