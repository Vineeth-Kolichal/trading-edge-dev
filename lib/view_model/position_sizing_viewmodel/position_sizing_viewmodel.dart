import 'package:flutter/material.dart';
import 'package:trading_edge/services/current_user_data.dart';
import 'package:trading_edge/services/position_sizing/position_sizing_services.dart';
import 'package:trading_edge/models/positions/position_model.dart';
import 'package:trading_edge/models/sizing/sizing_model.dart';
import 'package:trading_edge/repositories/position_sizing_repo/position_sizing_repo.dart';

class PositionSizingViewModel extends ChangeNotifier {
  PositionSizingRepo positionSizingRepo = PositionSizingServices();
  List<PositionModel> positionList = [];
  SizingModel? sizingModel;
  bool switchValue = false;
  void changeSwitchState() {
    if (switchValue) {
      switchValue = false;
    } else {
      switchValue = true;
    }
    notifyListeners();
  }

  void setSwitchValue(bool value) {
    switchValue = value;
    notifyListeners();
  }

  Future<void> getSizingData() async {
    final currentUserId = CurrentUserData.returnCurrentUserId();
    sizingModel = await positionSizingRepo.getSizingData(currentUserId);
    notifyListeners();
  }

  Future<void> getAllPositions(String? query) async {
    positionList = await positionSizingRepo.getAllPositions(query);
    notifyListeners();
  }

  Future<void> addPosition(PositionModel positionModel) async {
    await positionSizingRepo.addPosition(positionModel);
    await getAllPositions(null);
  }

  Future<void> updatePosition(PositionModel positionModel, int key) async {
    await positionSizingRepo.updatePosition(positionModel, key);
    await getAllPositions(null);
  }

  Future<void> clearPositions() async {
    await positionSizingRepo.clearPosition();
    await getAllPositions(null);
  }

  Future<void> deletePosition(int key) async {
    await positionSizingRepo.deletePosition(key);
    await getAllPositions(null);
  }

  Future<void> addOrUpdateSizing(
      {required SizingModel sizing, required String key}) async {
    await positionSizingRepo.addOrUpdateSizing(sizing: sizing, key: key);
    await getSizingData();
    await getAllPositions(null);
  }

  Future<void> initializeSizing() async {
    await positionSizingRepo.initializeSizing();
  }
}
