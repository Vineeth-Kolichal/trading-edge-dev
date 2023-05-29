import 'package:get/get.dart';
import 'package:my_tradebook/models/trade_logs_model/trade_logs_model.dart';
import 'package:my_tradebook/services/trade_logs_services/trade_logs_services.dart';

class TradeLogScreenController extends GetxController {
  TradeLogServices tradeLogServices = TradeLogServices();
  final tradeLogList = <TradeLogsModel>[].obs;
  void addDataToList({required List<TradeLogsModel> tradeLogs}) {
    tradeLogList.clear();
    tradeLogList.addAll(tradeLogs);
  }
}
