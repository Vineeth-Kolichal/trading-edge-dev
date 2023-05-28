import 'package:get/get.dart';
import 'package:my_tradebook/services/trade_logs_services/trade_logs_services.dart';

class TradeLogScreenController extends GetxController {
  TradeLogServices tradeLogServices = TradeLogServices();
  RxList tradeLogList = [].obs;
  void getAllTradeLogs() async {
    tradeLogList.addAll(await tradeLogServices.getAllTradeLogs());
  }
}
