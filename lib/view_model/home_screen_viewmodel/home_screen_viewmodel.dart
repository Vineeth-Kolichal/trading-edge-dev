import 'package:flutter/material.dart';

class HomeScreenViewModel extends ChangeNotifier {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController dateController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  int index = 0;
  bool isSearch = false;
  void changePage(int index) {
    this.index = index;
    notifyListeners();
    if (index != 3 && isSearch) {
      searchOpen();
    }
  }

  void searchOpen() {
    if (isSearch) {
      isSearch = false;
    } else {
      isSearch = true;
    }
    notifyListeners();
  }
}
