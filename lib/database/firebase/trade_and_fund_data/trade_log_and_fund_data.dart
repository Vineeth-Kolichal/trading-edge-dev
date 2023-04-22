import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:my_tradebook/authentication/get_current_user_id.dart';
import 'package:my_tradebook/database/firebase/user_profile/user_profile_photo_name_uplaod.dart';
import 'package:my_tradebook/functions/check_internet.dart';

enum EntryType { profit, loss, deposite, withdraw }

Future<void> addTradeLoges(
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
    print('is it');
    errorSnack('Please check your internet connectivity');
    return;
  }
  final CollectionReference tradesAndFund = FirebaseFirestore.instance
      .collection('users')
      .doc(returnCurrentUserId())
      .collection('Trades_and_fund');
  final Timestamp dateTime = Timestamp.fromDate(date);
  double amt = double.parse(amount);
  late String entryType;
  entryType = getEntryType(type: type);

  if (type == EntryType.deposite || type == EntryType.withdraw) {
    await tradesAndFund.add({
      'date': dateTime,
      'type': entryType,
      'amount': amt,
      // 'description': description,
      // ignore: body_might_complete_normally_catch_error
    }).catchError((error) {
      // Handle the error
      print('object');
      String errorMessage = "Error writing data to database: $error";

      errorSnack(errorMessage);
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
      // ignore: body_might_complete_normally_catch_error
    }).catchError((error) {
      // Handle the error
      String errorMessage = "Error writing data to database: $error";

      errorSnack(errorMessage);
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
      .doc(returnCurrentUserId())
      .collection('Trades_and_fund')
      .doc(docId);
  final Timestamp dateTime = Timestamp.fromDate(date);
  double amt = double.parse(amount);
  late String entryType;
  entryType = getEntryType(type: type);
  if (type == EntryType.deposite || type == EntryType.withdraw) {
    await docTobeUpdated.update({
      'date': dateTime,
      'type': entryType,
      'amount': amt,
    }).catchError((error) {
      // Handle the error
      String errorMessage = "Error writing data to database: $error";

      errorSnack(errorMessage);
    });
  } else {
    await docTobeUpdated.update({
      'date': dateTime,
      'type': entryType,
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

String getEntryType({required EntryType type}) {
  if (type == EntryType.profit) {
    return 'profit';
  }
  if (type == EntryType.loss) {
    return 'loss';
  }
  if (type == EntryType.deposite) {
    return 'deposite';
  }
  if (type == EntryType.withdraw) {
    return 'withdraw';
  }
  return '';
}
