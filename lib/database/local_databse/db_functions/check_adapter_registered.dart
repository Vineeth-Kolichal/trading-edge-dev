import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_tradebook/database/local_databse/models/sizing/sizing_model.dart';

void checkAdapterRegistered() {
  if (!Hive.isAdapterRegistered(SizingModelAdapter().typeId)) {
    Hive.registerAdapter(SizingModelAdapter());
  }
}
