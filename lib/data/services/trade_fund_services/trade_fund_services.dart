import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:trading_edge/models/trade_or_fund_model/trade_or_fund_model.dart';
import 'package:trading_edge/data/repositories/trade_or_fund_repo/trade_or_fund_repo.dart';
import 'package:trading_edge/data/services/current_user_data.dart';

class TradeFundServices implements TradeOrFundRepository {
  @override
  Future<bool> addTradeLogOrFund(
      {required TradeOrFundModel tradeOrFundModel}) async {
    final CollectionReference tradesAndFund =
        FirebaseFirestore.instance.collection('trades_and_fund');
    try {
      await tradesAndFund.add(tradeOrFundModel.toMap());
      return true;
    } on FirebaseException catch (_) {
      return false;
    }
  }

  @override
  Future<void> deleteDoc(String id) async {
    final DocumentReference document =
        FirebaseFirestore.instance.collection('trades_and_fund').doc(id);
    await document.delete();
  }

  @override
  Future<void> updateTradeLogsOrFund(
      {required TradeOrFundModel tradeOrFundModel, required String id}) async {
    final DocumentReference document =
        FirebaseFirestore.instance.collection('trades_and_fund').doc(id);
    try {
      await document.update(tradeOrFundModel.toMap());
    } catch (_) {}
  }

  @override
  Future<List<TradeOrFundModel>> getTradeLogData() async {
    List<TradeOrFundModel> tradeLogList = [];
    final CollectionReference tradesAndFund =
        FirebaseFirestore.instance.collection('trades_and_fund');
    final QuerySnapshot<Object?> querySnapshot = await tradesAndFund.get();
    for (var i = querySnapshot.docs.length - 1; i >= 0; i--) {
      Map<String, dynamic> dataMap =
          querySnapshot.docs[i].data() as Map<String, dynamic>;
      dataMap['docId'] = querySnapshot.docs[i].id;
      if (dataMap['userId'] == CurrentUserData.returnCurrentUserId() &&
          (dataMap['type'] == 'profit' || dataMap['type'] == 'loss')) {
        tradeLogList.add(TradeOrFundModel.fromMap(dataMap));
      }
    }
    return tradeLogList;
  }
  @override
  Future<List<TradeOrFundModel>> getTransactions() async {
    List<TradeOrFundModel> transactionList = [];
    final CollectionReference tradesAndFund =
        FirebaseFirestore.instance.collection('trades_and_fund');
    final QuerySnapshot<Object?> querySnapshot = await tradesAndFund.get();
    for (var i = querySnapshot.docs.length - 1; i >= 0; i--) {
      Map<String, dynamic> dataMap =
          querySnapshot.docs[i].data() as Map<String, dynamic>;
      dataMap['docId'] = querySnapshot.docs[i].id;
      if (dataMap['userId'] == CurrentUserData.returnCurrentUserId() ) {
        transactionList.add(TradeOrFundModel.fromMap(dataMap));
      }
    }
    return transactionList;
  }
}
