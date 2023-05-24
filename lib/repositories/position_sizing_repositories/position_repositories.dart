import 'package:my_tradebook/models/positions_model/position_model.dart';

abstract class PositionRepositories {
  Future<void> addPosition({required PositionModel position});
  Future<List<PositionModel>> getAllPositions();
  Future<void> deletePosition({required int key});
  Future<void> clearPosition();
  Future<List<PositionModel>> search({required String query});
  Future<void> updatePosition(
      {required PositionModel positionModel, required int key});
  Future<void> refreshUi({String? query});
}
