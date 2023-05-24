import 'package:my_tradebook/models/fund_model/funds_model.dart';

abstract class FundRepositories {
  Future<void> addFund({required FundModel fund});
  Future<void> deleteFUnd({required String documentId});
  Future<void> updateFund(
      {required String documentId, required FundModel updatedFund});
}
