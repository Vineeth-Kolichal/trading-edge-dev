import 'package:cloud_firestore/cloud_firestore.dart';
import 'filter_data_with_date.dart';

Future<double> totalPnlCalculations(int index) async {
  List<DocumentSnapshot> documents = [];
  double total = 0.0;
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

  total = filterDataAndFindSum(documents);
  return total;
}

double filterDataAndFindSum(List<DocumentSnapshot> documents) {
  double total = 0.0;
  for (var x in documents) {
    if (x['type'] == 'profit' || x['type'] == 'loss') {
      if (x['type'] == 'profit') {
        total += x['amount'];
      } else {
        total = total - x['amount'];
      }
    }
  }
  return total;
}
