
import 'package:trading_edge/models/positions/position_model.dart';
import 'package:trading_edge/models/sizing/sizing_model.dart';

abstract class PositionSizingRepo {
  Future<void> addPosition(PositionModel position);
  Future<List<PositionModel>> getAllPositions(String? query);
  Future<void> updatePosition(PositionModel positionModel, int key);
  Future<void> clearPosition();
  Future<void> deletePosition(int key);
  Future<void> initializeSizing();
  Future<SizingModel> returnCurrentUsersSizingData();
  Future<SizingModel> getSizingData(String key);
  Future<void> addOrUpdateSizing(
      {required SizingModel sizing, required String key});
}
