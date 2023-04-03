import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_tradebook/authentication/get_current_user_id.dart';
import 'package:my_tradebook/database/local_databse/models/positions/position_model.dart';

ValueNotifier<List<PositionModel>> positionNotifier = ValueNotifier([]);
Future<void> addPosition(PositionModel position) async {
  final positionDB = await Hive.openBox<PositionModel>('position_db');
  positionDB.add(position);
  await refreshUi();
}

Future<List<PositionModel>> getAllPositions() async {
  final positionDB = await Hive.openBox<PositionModel>('position_db');
  List<PositionModel> currentUsersData = [];
  String currenUseId = returnCurrentUserId();
  positionDB.values
      .where((element) => element.currentUserId == currenUseId)
      .forEach((element) {
    currentUsersData.add(element);
  });
  return currentUsersData;
}

Future<void> deletePosition(int key) async {
  final positionDB = await Hive.openBox<PositionModel>('position_db');
  positionDB.delete(key);
  await refreshUi();
}

Future<void> clearPosition() async {
  final positionDB = await Hive.openBox<PositionModel>('position_db');
  List<int> userKeys = [];
  String currenUseId = returnCurrentUserId();
  positionDB.values
      .where((element) => element.currentUserId == currenUseId)
      .forEach((element) {
    userKeys.add(element.key);
  });
  await positionDB.deleteAll(userKeys);
  refreshUi();
}

Future<void> updatePosition(PositionModel positionModel, int key) async {
  final positionDB = await Hive.openBox<PositionModel>('position_db');
  positionDB.put(key, positionModel);
  refreshUi();
}

Future<void> refreshUi() async {
  final list = await getAllPositions();
  list.sort((first, second) => (second.key).compareTo(first.key));
  positionNotifier.value.clear();
  positionNotifier.value.addAll(list);
  positionNotifier.notifyListeners();
}
