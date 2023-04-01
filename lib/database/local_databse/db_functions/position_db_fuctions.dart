import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_tradebook/database/local_databse/models/positions/position_model.dart';

ValueNotifier<List<PositionModel>> positionNotifier = ValueNotifier([]);
Future<void> addPosition(PositionModel position) async {
  final positionDB = await Hive.openBox<PositionModel>('position_db');
  positionDB.add(position);
  await getAllPositions();
}

Future<void> getAllPositions() async {
  final positionDB = await Hive.openBox<PositionModel>('position_db');
  positionNotifier.value.clear();
  positionNotifier.value.addAll(positionDB.values);
  positionNotifier.notifyListeners();
}

Future<void> deletePosition(int key) async {
  final positionDB = await Hive.openBox<PositionModel>('position_db');
  positionDB.delete(key);
  await getAllPositions();
}
