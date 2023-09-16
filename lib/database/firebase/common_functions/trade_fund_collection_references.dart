import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trading_edge/data/services/current_user_data.dart';

CollectionReference tradeFundCollectionReference() {
  final CollectionReference tradesAndFund = FirebaseFirestore.instance
      .collection('users')
      .doc(CurrentUserData.returnCurrentUserId())
      .collection('Trades_and_fund');
  return tradesAndFund;
}
