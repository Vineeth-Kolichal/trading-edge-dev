import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_tradebook/models/positions_model/position_model.dart';
import 'package:my_tradebook/services/authentication/get_current_user_id.dart';

ValueNotifier<List<PositionModel>> positionNotifier = ValueNotifier([]);
Future<void> addPosition(PositionModel position) async {
  final positionDB = await Hive.openBox<PositionModel>('position_db');
  positionDB.add(position);
  await refreshUi(null);
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
  await refreshUi(null);
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
  refreshUi(null);
}

Future<List<PositionModel>> search(String query) async {
  List<PositionModel> data = await getAllPositions();
  List<PositionModel> results = [];
  if (query.isNotEmpty) {
    results = data
        .where((item) =>
            item.stockName.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return results;
  } else {
    return data;
  }
}

Future<void> updatePosition(PositionModel positionModel, int key) async {
  final positionDB = await Hive.openBox<PositionModel>('position_db');

  positionDB.put(key, positionModel);
  refreshUi(null);
}

Future<void> refreshUi(String? query) async {
  String searchQuery = query ?? '';
  final list = await search(searchQuery);
  //final list = await getAllPositions();
  list.sort((first, second) => (second.key).compareTo(first.key));
  positionNotifier.value.clear();
  positionNotifier.value.addAll(list);
  positionNotifier.notifyListeners();
}
