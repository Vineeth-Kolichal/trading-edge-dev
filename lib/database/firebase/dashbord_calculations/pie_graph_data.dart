import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_tradebook/database/firebase/dashbord_calculations/filter_data_with_date.dart';

Future<Map<String, int>> pieGraphValues(int index) async {
  List<DocumentSnapshot> documents = [];

  //Last day
  if (index == 0) {
    documents = await lastDayData();

    //This week
  } else if (index == 1) {
    documents = await thisWeekData();

    //this quarter
  } else if (index == 2) {
    documents = await thisQuartertData();

    //this FY
  } else {
    documents = await thisFinancialYearData();
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

//this fuction is used to calculate percentage
int percentage({required int total, required int value}) {
  return ((value / total) * 100).round();
}

//this function is return the data to be put the map for the pie graph
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
