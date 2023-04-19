import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_tradebook/database/firebase/common_functions/tradeFundCollectionReferences.dart';

Future<List<DocumentSnapshot<Object?>>> lastDayData() async {
  final Timestamp dateTime =
      Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 2)));
  final tradesAndFundCollection = tradeFundCollectionReference();
  final querySnapshot = await tradesAndFundCollection
      .where('date', isGreaterThanOrEqualTo: dateTime)
      .get();
  final documents = querySnapshot.docs;
  return documents;
}

Future<List<DocumentSnapshot<Object?>>> thisWeekData() async {
  DateTime now = DateTime.now();
  DateTime startOfWeek = now.subtract(Duration(days: now.weekday % 7));
  DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));
  Timestamp startTimestamp = Timestamp.fromDate(startOfWeek);
  Timestamp endTimestamp = Timestamp.fromDate(endOfWeek);
  final tradesAndFundCollection = tradeFundCollectionReference();
  final querySnapshot = await tradesAndFundCollection
      .where('date', isGreaterThanOrEqualTo: startTimestamp)
      .where('date', isLessThanOrEqualTo: endTimestamp)
      .get();
  final documents = querySnapshot.docs;
  return documents;
}

Future<List<DocumentSnapshot<Object?>>> thisQuartertData() async {
  DateTime now = DateTime.now();
  int currentMonth = now.month;
  int startMonth = 4;
  int endMonth = 3;
  int startYear = (currentMonth < startMonth) ? now.year - 1 : now.year;
  int endYear = (currentMonth > endMonth) ? now.year + 1 : now.year;
  int yearOffset = (currentMonth >= startMonth) ? 0 : -1;
  int currentQuarter =
      ((currentMonth - startMonth + yearOffset) / 3).floor() + 1;
  DateTime startOfQuarter =
      DateTime(startYear, startMonth + (currentQuarter - 1) * 3, 1);
  DateTime endOfQuarter = DateTime(endYear, startMonth + currentQuarter * 3, 0);
  Timestamp startTimestamp = Timestamp.fromDate(startOfQuarter);
  Timestamp endTimestamp = Timestamp.fromDate(endOfQuarter);
  final tradesAndFundCollection = tradeFundCollectionReference();
  final querySnapshot = await tradesAndFundCollection
      .where('date', isGreaterThanOrEqualTo: startTimestamp)
      .where('date', isLessThanOrEqualTo: endTimestamp)
      .get();
  final documents = querySnapshot.docs;
  return documents;
}

Future<List<DocumentSnapshot<Object?>>> thisFinancialYearData() async {
  DateTime now = DateTime.now();
  int currentYear = now.year;
  int startYear = (now.month >= 4) ? currentYear : currentYear - 1;
  int endYear = startYear + 1;
  DateTime startOfYear = DateTime(startYear, 4, 1);
  DateTime endOfYear = DateTime(endYear, 3, 31);
  Timestamp startTimestamp = Timestamp.fromDate(startOfYear);
  Timestamp endTimestamp = Timestamp.fromDate(endOfYear);
  final tradesAndFundCollection = tradeFundCollectionReference();
  final querySnapshot = await tradesAndFundCollection
      .where('date', isGreaterThanOrEqualTo: startTimestamp)
      .where('date', isLessThanOrEqualTo: endTimestamp)
      .get();
  final documents = querySnapshot.docs;
  return documents;
}

Future<List<List<DocumentSnapshot<Object?>>>> lastTenWeeksData() async {
  List<List<DocumentSnapshot<Object?>>> data = [];
  DateTime now = DateTime.now();
  for (int i = 1; i <= 10; i++) {
    DateTime startOfWeek = now
        .subtract(Duration(days: now.weekday - DateTime.sunday))
        .subtract(Duration(days: i * 7));
    DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));
    Timestamp startTimestamp = Timestamp.fromDate(startOfWeek);
    Timestamp endTimestamp = Timestamp.fromDate(endOfWeek);
    final tradesAndFundCollection = tradeFundCollectionReference();
    final querySnapshot = await tradesAndFundCollection
        .where('date', isGreaterThanOrEqualTo: startTimestamp)
        .where('date', isLessThanOrEqualTo: endTimestamp)
        .get();

    final documents = querySnapshot.docs;
    // print("$i th doc length ${documents.length}");
    //   if (documents.isNotEmpty) {
    // print('inside');
    data.add(documents);
    // }
  }
  return data;
}
