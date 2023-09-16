import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trading_edge/services/current_user_data.dart';
import 'package:trading_edge/functions/check_internet.dart';
import 'package:trading_edge/utils/constants/const_values.dart';
import 'package:trading_edge/views/widgets/widget_error_snackbar.dart';

// enum EntryType { profit, loss, deposite, withdraw }

Future<bool> addTradeLoges(
    {required DateTime date,
    required EntryType type,
    required String amount,
    required BuildContext context,
    String? description,
    int? swPro,
    int? swLo,
    int? intraPro,
    int? intraLo}) async {
  bool chekInternet = await checkInternetConnetion();
  if (!chekInternet) {
    errorSnack('Please check your internet connectivity');
    return chekInternet;
  }
  final CollectionReference tradesAndFund = FirebaseFirestore.instance
      .collection('users')
      .doc(CurrentUserData.returnCurrentUserId())
      .collection('Trades_and_fund');
  final Timestamp dateTime = Timestamp.fromDate(date);
  double amt = double.parse(amount);
  late String entryType;
  // entryType = getEntryType(type: type);

  if (type == EntryType.deposite || type == EntryType.withdraw) {
    await tradesAndFund.add({
      'date': dateTime,
      // 'type': entryType,
      'amount': amt,

      // ignore: body_might_complete_normally_catch_error
    }).catchError((error) {
      // Handle the error

      String errorMessage = "Error writing data to database: $error";

      errorSnack(errorMessage);
    });
  } else {
    await tradesAndFund.add({
      'date': dateTime,
      // 'type': entryType,
      'amount': amt,
      'description': description,
      'swing_profit': swPro,
      'swing_loss': swLo,
      'intraday_profit': intraPro,
      'intraday_loss': intraLo,
      // ignore: body_might_complete_normally_catch_error
    }).catchError((error) {
      // Handle the error
      String errorMessage = "Error writing data to database: $error";

      errorSnack(errorMessage);
    });
  }
  return chekInternet;
}

Future<void> deleteDoc(String id) async {
  final DocumentReference document = FirebaseFirestore.instance
      .collection('users')
      .doc(CurrentUserData.returnCurrentUserId())
      .collection('Trades_and_fund')
      .doc(id);
  await document.delete();
}

Future<void> updateTradeLogsAndFund(
    {required String docId,
    required DateTime date,
    required EntryType type,
    required String amount,
    String? description,
    int? swPro,
    int? swLo,
    int? intraPro,
    int? intraLo}) async {
  final DocumentReference docTobeUpdated = FirebaseFirestore.instance
      .collection('users')
      .doc(CurrentUserData.returnCurrentUserId())
      .collection('Trades_and_fund')
      .doc(docId);
  final Timestamp dateTime = Timestamp.fromDate(date);
  double amt = double.parse(amount);
  late String entryType;
  // entryType = getEntryType(type: type);
  if (type == EntryType.deposite || type == EntryType.withdraw) {
    await docTobeUpdated.update({
      'date': dateTime,
      //'type': entryType,
      'amount': amt,
    }).catchError((error) {
      // Handle the error
      String errorMessage = "Error writing data to database: $error";

      errorSnack(errorMessage);
    });
  } else {
    await docTobeUpdated.update({
      'date': dateTime,
      //'type': entryType,
      'amount': amt,
      'description': description,
      'swing_profit': swPro,
      'swing_loss': swLo,
      'intraday_profit': intraPro,
      'intraday_loss': intraLo,
    }).catchError((error) {
      // Handle the error
      String errorMessage = "Error writing data to database: $error";

      errorSnack(errorMessage);
    });
  }
}
