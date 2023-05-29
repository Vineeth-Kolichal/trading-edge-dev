import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:my_tradebook/controllers/trades_logs_controllers/trades_log_screen_controller.dart';
import 'package:my_tradebook/core/constants/enumarators.dart';
import 'package:my_tradebook/models/trade_logs_model/trade_logs_model.dart';
import 'package:my_tradebook/repositories/trades_log_repositories/trade_logs_repositores.dart';
import 'package:my_tradebook/services/authentication/get_current_user_id.dart';

TradeLogScreenController tradeLogScreenController =
    Get.put(TradeLogScreenController());

class TradeLogServices extends TradesLogRepositories {
  factory TradeLogServices() {
    return TradeLogServices.tradeLogServices();
  }

  @override
  Future<void> addTradeLogs({required TradeLogsModel tradeLog}) async {
    final CollectionReference tradesAndFund = FirebaseFirestore.instance
        .collection('users')
        .doc(returnCurrentUserId())
        .collection('Trades_and_fund');
    final Timestamp dateTime = Timestamp.fromDate(tradeLog.date);
    double amt = double.parse(tradeLog.amount);
    String entryType = getEntryType(type: tradeLog.type);

    await tradesAndFund.add({
      'date': dateTime,
      'type': entryType,
      'amount': amt,
      'description': tradeLog.description,
      'swing_profit': tradeLog.swingProfitCount,
      'swing_loss': tradeLog.swingLossCount,
      'intraday_profit': tradeLog.intradayProfitCount,
      'intraday_loss': tradeLog.intradayLossCount,
    }).catchError((error) {});
  }

  @override
  Future<void> deleteTradeLogItem({required String id}) async {
    final DocumentReference document = FirebaseFirestore.instance
        .collection('users')
        .doc(returnCurrentUserId())
        .collection('Trades_and_fund')
        .doc(id);
    await document.delete();
  }

  @override
  Future<void> updateTradeLogs(
      {required String documentId,
      required TradeLogsModel updatedTradeLog}) async {
    final DocumentReference docTobeUpdated = FirebaseFirestore.instance
        .collection('users')
        .doc(returnCurrentUserId())
        .collection('Trades_and_fund')
        .doc(documentId);
    final Timestamp dateTime = Timestamp.fromDate(updatedTradeLog.date);
    double amt = double.parse(updatedTradeLog.amount);
    late String entryType;
    entryType = getEntryType(type: updatedTradeLog.type);
    await docTobeUpdated.update({
      'date': dateTime,
      'type': entryType,
      'amount': amt,
      'description': updatedTradeLog.description,
      'swing_profit': updatedTradeLog.swingProfitCount,
      'swing_loss': updatedTradeLog.swingLossCount,
      'intraday_profit': updatedTradeLog.intradayProfitCount,
      'intraday_loss': updatedTradeLog.intradayLossCount,
    }).catchError((error) {});
  }

  @override
  Future<void> getAllTradeLogs() async {
    List<TradeLogsModel> tradeLogsList = [];
    List<TradeLogsModel> tradeLogsListTemp = [];
    List<Map<String, dynamic>> finalResult = [];
    CollectionReference reference = FirebaseFirestore.instance
        .collection('users')
        .doc(returnCurrentUserId())
        .collection('Trades_and_fund');
    reference.snapshots().listen((event) {
      List<Map<String, dynamic>> result = [];
      for (var element in event.docs) {
        var s = element.data() as Map<String, dynamic>;
        s['id'] = element.id;
        result.add(s);
      }
      finalResult.clear();
      finalResult.addAll(result
          .where((element) =>
              element['type'] == 'profit' || element['type'] == 'loss')
          .toList());
      finalResult.sort((a, b) => b['date'].compareTo(a['date']));
      tradeLogsListTemp.clear();
      for (var data in finalResult) {
        TradeLogsModel tradeLogsModel = TradeLogsModel.fromMap(json: data);
        tradeLogsListTemp.add(tradeLogsModel);
      }
      tradeLogsList.clear();
      tradeLogsList.addAll(tradeLogsListTemp);
      tradeLogScreenController.addDataToList(tradeLogs: tradeLogsList);
    });
  }

  String getEntryType({required EntryType type}) {
    if (type == EntryType.profit) {
      return 'profit';
    }
    if (type == EntryType.loss) {
      return 'loss';
    }
    if (type == EntryType.deposite) {
      return 'deposite';
    }
    if (type == EntryType.withdraw) {
      return 'withdraw';
    }
    return '';
  }

  TradeLogServices.tradeLogServices();
}
