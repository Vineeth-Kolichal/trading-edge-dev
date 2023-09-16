import 'package:hive_flutter/hive_flutter.dart';
import 'package:trading_edge/services/current_user_data.dart';
import 'package:trading_edge/models/positions/position_model.dart';
import 'package:trading_edge/models/sizing/sizing_model.dart';
import 'package:trading_edge/repositories/position_sizing_repo/position_sizing_repo.dart';

class PositionSizingServices implements PositionSizingRepo {
  @override
  Future<void> addPosition(PositionModel position) async {
    final positionDB = await Hive.openBox<PositionModel>('position_db');
    positionDB.add(position);
  }

  Future<List<PositionModel>> getAllPositionsFromDb() async {
    final positionDB = await Hive.openBox<PositionModel>('position_db');
    List<PositionModel> currentUsersData = [];
    String currenUseId = CurrentUserData.returnCurrentUserId();
    positionDB.values
        .where((element) => element.currentUserId == currenUseId)
        .forEach((element) {
      currentUsersData.add(element);
    });
    return currentUsersData;
  }

  @override
  Future<void> deletePosition(int key) async {
    final positionDB = await Hive.openBox<PositionModel>('position_db');
    positionDB.delete(key);
  }

  @override
  Future<void> clearPosition() async {
    final positionDB = await Hive.openBox<PositionModel>('position_db');
    List<int> userKeys = [];
    String currenUseId = CurrentUserData.returnCurrentUserId();
    positionDB.values
        .where((element) => element.currentUserId == currenUseId)
        .forEach((element) {
      userKeys.add(element.key);
    });
    await positionDB.deleteAll(userKeys);
  }

  Future<List<PositionModel>> search(String query) async {
    List<PositionModel> data = await getAllPositionsFromDb();
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
  Future<void> updatePosition(PositionModel positionModel, int key) async {
    final positionDB = await Hive.openBox<PositionModel>('position_db');
    positionDB.put(key, positionModel);
  }

  @override
  Future<List<PositionModel>> getAllPositions(String? query) async {
    String searchQuery = query ?? '';
    final list = await search(searchQuery);
    list.sort((first, second) => (second.key).compareTo(first.key));
    return list;
  }

  //sizing
  @override
  Future<void> addOrUpdateSizing(
      {required SizingModel sizing, required String key}) async {
    final sizingDB = await Hive.openBox<SizingModel>('sizing_db');
    sizingDB.put(key, sizing);
    await getSizingData(key);
  }

  @override
  Future<SizingModel> getSizingData(String key) async {
    final sizingDB = await Hive.openBox<SizingModel>('sizing_db');
    final SizingModel? sizingModel = sizingDB.get(key);
    return sizingModel ??
        SizingModel(
            targetAmount: 0, targetPercentage: 0, stoplossPercentage: 0);
  }

  @override
  Future<void> initializeSizing() async {
    final sizingDB = await Hive.openBox<SizingModel>('sizing_db');
    final sizing = sizingDB.get(CurrentUserData.returnCurrentUserId());
    if (sizing?.stoplossPercentage == null ||
        sizing?.targetPercentage == null ||
        sizing?.targetAmount == null) {
      SizingModel sm = SizingModel(
          targetAmount: 0.0, targetPercentage: 0.0, stoplossPercentage: 0.0);
      await addOrUpdateSizing(
          key: CurrentUserData.returnCurrentUserId(), sizing: sm);
    }
  }

  @override
  Future<SizingModel> returnCurrentUsersSizingData() async {
    final sizingDB = await Hive.openBox<SizingModel>('sizing_db');
    final sizing = sizingDB.get(CurrentUserData.returnCurrentUserId());
    return sizing!;
  }

 static void checkAdapterRegistered() {
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
}
