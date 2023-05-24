import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_tradebook/core/constants/enumarators.dart';
import 'package:my_tradebook/models/fund_model/funds_model.dart';
import 'package:my_tradebook/repositories/fund_repositories/fund_repositories.dart';
import 'package:my_tradebook/services/authentication/get_current_user_id.dart';

class FundServices extends FundRepositories {
  factory FundServices() {
    return FundServices.fundServices();
  }
  @override
  Future<void> addFund({required FundModel fund}) async {
    final CollectionReference tradesAndFund = FirebaseFirestore.instance
        .collection('users')
        .doc(returnCurrentUserId())
        .collection('Trades_and_fund');
    final Timestamp dateTime = Timestamp.fromDate(fund.date);
    double amt = double.parse(fund.amount);
     String entryType = getEntryType(type: fund.type);
    await tradesAndFund.add({
      'date': dateTime,
      'type': entryType,
      'amount': amt,
    }).catchError((error) {});
  }

  @override
  Future<void> deleteFUnd({required String documentId}) async {
    final DocumentReference document = FirebaseFirestore.instance
        .collection('users')
        .doc(returnCurrentUserId())
        .collection('Trades_and_fund')
        .doc(documentId);
    await document.delete();
  }

  @override
  Future<void> updateFund(
      {required String documentId, required FundModel updatedFund}) async {
   final DocumentReference docTobeUpdated = FirebaseFirestore.instance
      .collection('users')
      .doc(returnCurrentUserId())
      .collection('Trades_and_fund')
      .doc(documentId);
  final Timestamp dateTime = Timestamp.fromDate(updatedFund.date);
  double amt = double.parse(updatedFund.amount);
   String 
  entryType = getEntryType(type: updatedFund.type);
await docTobeUpdated.update({
      'date': dateTime,
      'type': entryType,
      'amount': amt,
    }).catchError((error) {
      // Handle the error
    
    });

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

  FundServices.fundServices();
}
