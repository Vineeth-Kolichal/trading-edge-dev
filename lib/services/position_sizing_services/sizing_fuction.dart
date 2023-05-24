import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_tradebook/models/sizing_model/sizing_model.dart';
import 'package:my_tradebook/services/authentication/get_current_user_id.dart';

ValueNotifier<SizingModel?> sizingNotifier = ValueNotifier(null);
Future<void> addOrUpdateSizing(
    {required SizingModel sizing, required String key}) async {
  final sizingDB = await Hive.openBox<SizingModel>('sizing_db');
  sizingDB.put(key, sizing);
  await getSizingData(key);
}

Future<void> getSizingData(String key) async {
  final sizingDB = await Hive.openBox<SizingModel>('sizing_db');
  sizingNotifier.value = sizingDB.get(key);
  sizingNotifier.notifyListeners();
}

Future<void> initializeSizing() async {
  final sizingDB = await Hive.openBox<SizingModel>('sizing_db');
  final sizing = sizingDB.get(returnCurrentUserId());
  if (sizing?.stoplossPercentage == null ||
      sizing?.targetPercentage == null ||
      sizing?.targetAmount == null) {
    SizingModel sm = SizingModel(
        targetAmount: 0.0, targetPercentage: 0.0, stoplossPercentage: 0.0);
    await addOrUpdateSizing(key: returnCurrentUserId(), sizing: sm);
  }
}

Future<SizingModel> returnCurrentUsersSizingData() async {
  final sizingDB = await Hive.openBox<SizingModel>('sizing_db');
  final sizing = sizingDB.get(returnCurrentUserId());
  return sizing!;
}
