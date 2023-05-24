import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_tradebook/services/authentication/get_current_user_id.dart';

CollectionReference tradeFundCollectionReference() {
  final CollectionReference tradesAndFund = FirebaseFirestore.instance
      .collection('users')
      .doc(returnCurrentUserId())
      .collection('Trades_and_fund');
  return tradesAndFund;
}
