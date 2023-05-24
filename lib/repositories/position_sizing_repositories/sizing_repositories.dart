import 'package:my_tradebook/models/sizing_model/sizing_model.dart';

abstract class SizingRepositories {
  Future<void> addOrUpdateSizing(
      {required SizingModel sizing, required String key});
  Future<void> getSizigData({required String key});
  Future<void> initializeSizing();
  Future<SizingModel> returnCurrentUserSizingData();
}
