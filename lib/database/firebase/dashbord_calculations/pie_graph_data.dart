import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_tradebook/database/firebase/common_functions/tradeFundCollectionReferences.dart';

Future<Map<String, int>> pieGraphValues(int index) async {
  List<DocumentSnapshot> documents = [];

  //Last day
  if (index == 0) {
    final Timestamp dateTime =
        Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 1)));
    final tradesAndFundCollection = tradeFundCollectionReference();
    final querySnapshot = await tradesAndFundCollection
        .where('date', isGreaterThanOrEqualTo: dateTime)
        .get();
    documents = querySnapshot.docs;

    //This week
  } else if (index == 1) {
    DateTime now = DateTime.now();
    DateTime startOfWeek =
        now.subtract(Duration(days: now.weekday - DateTime.monday));
    DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));
    Timestamp startTimestamp = Timestamp.fromDate(startOfWeek);
    Timestamp endTimestamp = Timestamp.fromDate(endOfWeek);
    final tradesAndFundCollection = tradeFundCollectionReference();
    final querySnapshot = await tradesAndFundCollection
        .where('date', isGreaterThanOrEqualTo: startTimestamp)
        .where('date', isLessThanOrEqualTo: endTimestamp)
        .get();
    documents = querySnapshot.docs;

    //this quarter
  } else if (index == 2) {
    DateTime now = DateTime.now();
    int currentMonth = now.month;
    int startMonth = 4; 
    int endMonth = 3;
    int startYear = (currentMonth < startMonth) ? now.year - 1 : now.year;
    int endYear = (currentMonth > endMonth) ? now.year + 1 : now.year;
    int yearOffset = (currentMonth >= startMonth) ? 0 : -1;
    int currentQuarter =
        ((currentMonth - startMonth + yearOffset) / 3).floor() + 1;
    DateTime startOfQuarter =
        DateTime(startYear, startMonth + (currentQuarter - 1) * 3, 1);
    DateTime endOfQuarter =
        DateTime(endYear, startMonth + currentQuarter * 3 - 1, 0);
    Timestamp startTimestamp = Timestamp.fromDate(startOfQuarter);
    Timestamp endTimestamp = Timestamp.fromDate(endOfQuarter);
    final tradesAndFundCollection = tradeFundCollectionReference();
    final querySnapshot = await tradesAndFundCollection
        .where('date', isGreaterThanOrEqualTo: startTimestamp)
        .where('date', isLessThanOrEqualTo: endTimestamp)
        .get();
    documents = querySnapshot.docs;

    //this FY
  } else {
    DateTime now = DateTime.now();
    int currentYear = now.year;
    int startYear = (now.month >= 4) ? currentYear : currentYear - 1;
    int endYear = startYear + 1;
    DateTime startOfYear = DateTime(startYear, 4, 1);
    DateTime endOfYear = DateTime(endYear, 3, 31);
    Timestamp startTimestamp = Timestamp.fromDate(startOfYear);
    Timestamp endTimestamp = Timestamp.fromDate(endOfYear);
    final tradesAndFundCollection = tradeFundCollectionReference();
    final querySnapshot = await tradesAndFundCollection
        .where('date', isGreaterThanOrEqualTo: startTimestamp)
        .where('date', isLessThanOrEqualTo: endTimestamp)
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
