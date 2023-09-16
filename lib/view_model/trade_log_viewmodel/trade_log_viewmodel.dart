import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trading_edge/models/trade_or_fund_model/trade_or_fund_model.dart';
import 'package:trading_edge/data/repositories/trade_or_fund_repo/trade_or_fund_repo.dart';
import 'package:trading_edge/data/services/trade_fund_services/trade_fund_services.dart';
import 'package:trading_edge/utils/constants/const_values.dart';

class TradeLogViewModel extends ChangeNotifier {
  EntryType type = EntryType.profit;
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

  void setValuesForUpdateScreen(TradeOrFundModel tradeOrFundModel) {

    final dateOld = DateFormat.yMMMEd().format(tradeOrFundModel.date);
    dateController.text = dateOld;
    pnlController.text = tradeOrFundModel.amount.toString() ;
    commentController.text = tradeOrFundModel.comments?? '';
    swingLotController.text = tradeOrFundModel.swingLoss.toString() ;
    swingProtController.text = tradeOrFundModel.swingProfit.toString();
    intraLoController.text = tradeOrFundModel.intraLoss.toString();
    intraProController.text = tradeOrFundModel.intraProfit.toString() ;
  }

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
