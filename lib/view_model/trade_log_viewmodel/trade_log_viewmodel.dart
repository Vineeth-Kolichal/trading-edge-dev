import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trading_edge/models/trade_or_fund_model/trade_or_fund_model.dart';
import 'package:trading_edge/repositories/trade_or_fund_repo/trade_or_fund_repo.dart';
import 'package:trading_edge/services/current_user_data.dart';
import 'package:trading_edge/services/trade_fund_services/trade_fund_services.dart';

class TradeLogViewModel extends ChangeNotifier {
  bool isLoading = true;
  List<TradeOrFundModel> tradeLogList = [];
  TradeOrFundRepository tradeOrFundRepository = TradeFundServices();
  final formKey = GlobalKey<FormState>();
  DateTime? selectedDate;
  TextEditingController dateController = TextEditingController();
  TextEditingController pnlController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  TextEditingController swingLotController = TextEditingController();
  TextEditingController swingProtController = TextEditingController();
  TextEditingController intraProController = TextEditingController();
  TextEditingController intraLoController = TextEditingController();

  Future<void> addTrades(TradeOrFundModel tradeOrFundModel) async {
    tradeOrFundRepository.addTradeLogOrFund(tradeOrFundModel: tradeOrFundModel);
    await getTradeLogs();
  }

  Future<void> getTradeLogs() async {
    tradeLogList = await tradeOrFundRepository.getTradeLogData();
    notifyListeners();
    isLoading = false;
    notifyListeners();
  }

  Future<void> deleteTradeLog(String id) async {
    await tradeOrFundRepository.deleteDoc(id);
    await getTradeLogs();
  }

  Future<void> updateTradeLog(
      TradeOrFundModel tradeOrFundModel, String id) async {
    await tradeOrFundRepository.updateTradeLogsOrFund(
        tradeOrFundModel: tradeOrFundModel, id: id);
    await getTradeLogs();
  }
}
