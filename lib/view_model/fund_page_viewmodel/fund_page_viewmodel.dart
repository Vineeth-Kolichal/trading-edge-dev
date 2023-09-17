import 'package:flutter/material.dart';
import 'package:trading_edge/data/repositories/trade_or_fund_repo/trade_or_fund_repo.dart';
import 'package:trading_edge/data/services/trade_fund_services/trade_fund_services.dart';
import 'package:trading_edge/models/trade_or_fund_model/trade_or_fund_model.dart';

class FundPageViewModel extends ChangeNotifier {
  TradeOrFundRepository tradeOrFundRepository = TradeFundServices();
  final formKey = GlobalKey<FormState>();
  List<TradeOrFundModel> allTrasaction = [];
  bool isLoading = true;
  bool switchValue = false;
  String dateText = '';
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

  void setDateText(String dateText) {
    this.dateText = dateText;
    notifyListeners();
  }

  Future<void> addFund(TradeOrFundModel tradeOrFundModel) async {
    await tradeOrFundRepository.addTradeLogOrFund(
        tradeOrFundModel: tradeOrFundModel);
    await getAllTransactions();
  }

  Future<void> updateFundTransaction(
      TradeOrFundModel tradeOrFundModel, String id) async {
    await tradeOrFundRepository.updateTradeLogsOrFund(
        tradeOrFundModel: tradeOrFundModel, id: id);
    await getAllTransactions();
  }

  Future<void> deleteFund(String id) async {
    await tradeOrFundRepository.deleteDoc(id);
    await getAllTransactions();
  }

  Future<void> getAllTransactions() async {
    allTrasaction = await tradeOrFundRepository.getTransactions();
    notifyListeners();
    isLoading = false;
    notifyListeners();
  }
}
