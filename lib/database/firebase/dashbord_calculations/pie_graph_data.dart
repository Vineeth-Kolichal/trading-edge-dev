import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_tradebook/database/firebase/common_functions/tradeFundCollectionReferences.dart';

Future<Map<String, int>> pieGraphValues(int index) async {
  List<DocumentSnapshot> documents = [];
  if (index == 0) {
    final Timestamp dateTime =
        Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 2)));
    final tradesAndFundCollection = tradeFundCollectionReference();
    final querySnapshot = await tradesAndFundCollection
        .where('date', isGreaterThanOrEqualTo: dateTime)
        .get();
    documents = querySnapshot.docs;
  } else if (index == 1) {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday % 7));
    DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));
    Timestamp startTimestamp = Timestamp.fromDate(startOfWeek);
    Timestamp endTimestamp = Timestamp.fromDate(endOfWeek);
    final tradesAndFundCollection = tradeFundCollectionReference();
    final querySnapshot = await tradesAndFundCollection
        .where('date', isGreaterThanOrEqualTo: startTimestamp)
        .where('date', isLessThanOrEqualTo: endTimestamp)
        .get();
    documents = querySnapshot.docs;
  } else if (index == 2) {
    final Timestamp dateTime =
        Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 2)));
    final tradesAndFundCollection = tradeFundCollectionReference();
    final querySnapshot = await tradesAndFundCollection
        .where('date', isGreaterThanOrEqualTo: dateTime)
        .get();
    documents = querySnapshot.docs;
  } else {
    final Timestamp dateTime =
        Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 2)));
    final tradesAndFundCollection = tradeFundCollectionReference();
    final querySnapshot = await tradesAndFundCollection
        .where('date', isGreaterThanOrEqualTo: dateTime)
        .get();
    documents = querySnapshot.docs;
  }

  List<int> graphPercentages = putPieGraphpercentages(documents);
  Map<String, int> lastDayValues = {
    'Profit-swing': graphPercentages[0],
    'Loss-swing': graphPercentages[1],
    'Profit-intraday': graphPercentages[2],
    'Loss-intraday': graphPercentages[2]
  };
  return lastDayValues;
}

int percentage({required int total, required int value}) {
  return ((value / total) * 100).round();
}

List<int> putPieGraphpercentages(List<DocumentSnapshot> documents) {
  List<int> returnValues = [];
  int totalIntraProfit = 0;
  int totalIntraLoss = 0;
  int totalSwingProfit = 0;
  int totalSwingLoss = 0;

  for (var x in documents) {
    if (x['type'] == 'profit' || x['type'] == 'loss') {
      totalSwingProfit += x['swing_profit'] as int;
      totalSwingLoss += x['swing_loss'] as int;
      totalIntraProfit += x['intraday_profit'] as int;
      totalIntraLoss += x['intraday_loss'] as int;
    }
  }
  var totalTrades =
      totalSwingLoss + totalSwingProfit + totalIntraLoss + totalIntraProfit;
  returnValues.add(percentage(total: totalTrades, value: totalSwingProfit));
  returnValues.add(percentage(total: totalTrades, value: totalSwingLoss));
  returnValues.add(percentage(total: totalTrades, value: totalIntraProfit));
  returnValues.add(percentage(total: totalTrades, value: totalIntraLoss));

  return returnValues;
}
