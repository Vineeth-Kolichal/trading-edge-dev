import 'package:my_tradebook/models/trade_logs_model/trade_logs_model.dart';

abstract class TradesLogRepositories {
  Future<void> addTradeLogs({required TradeLogsModel tradeLog});
  Future<void> deleteTradeLogItem({required String id});
  Future<void> updateTradeLogs(
      {required String documentId, required TradeLogsModel updatedTradeLog});
Future<void> getAllTradeLogs();
}
