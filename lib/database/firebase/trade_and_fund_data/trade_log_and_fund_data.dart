import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_tradebook/authentication/get_current_user_id.dart';

enum EntryType { profit, loss, deposite, withdraw }

Future<void> addTradeLoges(
    {required DateTime date,
    required EntryType type,
    required String amount,
    String? description,
    int? swPro,
    int? swLo,
    int? intraPro,
    int? intraLo}) async {
  final CollectionReference tradesAndFund = FirebaseFirestore.instance
      .collection('users')
      .doc(returnCurrentUserId())
      .collection('Trades_and_fund');
  final Timestamp dateTime = Timestamp.fromDate(date);
  double amt = double.parse(amount);
  late String entryType;
  if (type == EntryType.profit) {
    entryType = 'profit';
  }
  if (type == EntryType.loss) {
    entryType = 'loss';
  }
  if (type == EntryType.deposite) {
    entryType = 'deposite';
  }
  if (type == EntryType.withdraw) {
    entryType = 'withdraw';
  }
  if (type == EntryType.deposite || type == EntryType.withdraw) {
    await tradesAndFund.add({
      'date': dateTime,
      'type': entryType,
      'amount': amt,
      // 'description': description,
    });
  } else {
    await tradesAndFund.add({
      'date': dateTime,
      'type': entryType,
      'amount': amt,
      'description': description,
      'swing_profit': swPro,
      'swing_loss': swLo,
      'intraday_profit': intraPro,
      'intraday_loss': intraLo,
    });
  }
}

Future<void> deleteDoc(String id) async {
  final DocumentReference document = FirebaseFirestore.instance
      .collection('users')
      .doc(returnCurrentUserId())
      .collection('Trades_and_fund')
      .doc(id);
  await document.delete();
}
