import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_tradebook/authentication/get_current_user_id.dart';
import 'package:my_tradebook/database/local_databse/models/sizing/sizing_model.dart';

ValueNotifier<SizingModel?> sizingNotifier = ValueNotifier(null);
Future<void> addOrUpdateSizing(SizingModel sizing) async {
  final sizingDB = await Hive.openBox<SizingModel>('sizing_db');
  sizingDB.put(0, sizing);
  await getSizingData();
}

Future<void> getSizingData() async {
  final sizingDB = await Hive.openBox<SizingModel>('sizing_db');
  sizingNotifier.value = sizingDB.get(0);
  sizingNotifier.notifyListeners();
}
