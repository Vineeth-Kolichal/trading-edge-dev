import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_tradebook/models/positions_model/position_model.dart';
import 'package:my_tradebook/repositories/position_sizing_repositories/position_repositories.dart';
import 'package:my_tradebook/services/authentication/get_current_user_id.dart';

ValueNotifier<List<PositionModel>> positionNotifier = ValueNotifier([]);

class PositionServices implements PositionRepositories {
  factory PositionServices() {
    return PositionServices.positionServices();
  }
  @override
  Future<void> addPosition({required PositionModel position}) async {
    final positionDB = await Hive.openBox<PositionModel>('position_db');
    positionDB.add(position);
    await refreshUi(query: null);
  }

  @override
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
    refreshUi(query: null);
  }

  @override
  Future<void> deletePosition({required int key}) async {
    final positionDB = await Hive.openBox<PositionModel>('position_db');
    positionDB.delete(key);
    await refreshUi(query: null);
  }

  @override
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

  @override
  Future<void> refreshUi({String? query}) async {
    String searchQuery = query ?? '';
    final list = await search(query: searchQuery);
    //final list = await getAllPositions();
    list.sort((first, second) => (second.key).compareTo(first.key));
    positionNotifier.value.clear();
    positionNotifier.value.addAll(list);
    positionNotifier.notifyListeners();
  }

  @override
  Future<List<PositionModel>> search({required String query}) async {
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

  @override
  Future<void> updatePosition(
      {required PositionModel positionModel, required int key}) async {
    final positionDB = await Hive.openBox<PositionModel>('position_db');

    positionDB.put(key, positionModel);
    refreshUi(query: null);
  }

  PositionServices.positionServices();
}
