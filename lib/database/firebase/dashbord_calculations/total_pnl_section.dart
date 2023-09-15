import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trading_edge/database/firebase/common_functions/trade_fund_collection_references.dart';
Future<double> getCurrentBalance() async {
  final CollectionReference tradesAndFund = tradeFundCollectionReference();
  final QuerySnapshot querySnapshot = await tradesAndFund.get();
  double sum = 0;
  for (final DocumentSnapshot documentSnapshot in querySnapshot.docs) {
    final Map<String, dynamic> data =
        documentSnapshot.data() as Map<String, dynamic>;
    final double value = data['amount'];
    if (data['type'] == 'loss' || data['type'] == 'withdraw') {
      sum += (value * -1);
    } else {
      sum += value;
    }
  }
  return sum;
}


