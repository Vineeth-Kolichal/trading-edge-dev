import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_tradebook/database/firebase/dashbord_calculations/filter_data_with_date.dart';

Future<List<Map<String, dynamic>>> lineGraphData() async {
  List totalAmountList = List.generate(10, (index) => null);
  List displayAmountList = List.generate(10, (index) => null);
  List<List<DocumentSnapshot<Object?>>> lastTenData;
  double sum = 0.0;
  lastTenData = await lastTenWeeksData();
  int k = lastTenData.length - 1;
  for (var x in lastTenData) {
    for (var y in x) {
      if (y['type'] == 'profit' || y['type'] == 'deposite') {
        sum += y['amount'];
      } else {
        sum -= y['amount'];
      }
    }
    totalAmountList[k] = sum;
    k--;
    sum = 0;
  }
  for (var i = 0; i < totalAmountList.length; i++) {
    if (i == 0) {
      displayAmountList[i] = totalAmountList[i];
    } else {
      if (totalAmountList[i] != null) {
        displayAmountList[i] = displayAmountList[i - 1] + totalAmountList[i];
      }
    }
  }
  List<Map<String, dynamic>> chartData = [];
  for (int a = 0; a <= 10; a++) {
    if (a == 0) {
      chartData.add(
        {'domain': 0, 'measure': 0},
      );
    } else {
      chartData.add(
        {'domain': a, 'measure': displayAmountList[a - 1]},
      );
    }
  }
  return chartData;
}
