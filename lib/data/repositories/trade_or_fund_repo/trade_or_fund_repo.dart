import 'package:trading_edge/models/trade_or_fund_model/trade_or_fund_model.dart';

abstract class TradeOrFundRepository {
  Future<bool> addTradeLogOrFund({required TradeOrFundModel tradeOrFundModel});
  Future<void> deleteDoc(String id);
  Future<void> updateTradeLogsOrFund(
      {required TradeOrFundModel tradeOrFundModel, required String id});
  Future<List<TradeOrFundModel>> getTradeLogData();
}
