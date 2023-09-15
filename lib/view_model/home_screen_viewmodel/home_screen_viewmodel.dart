import 'package:flutter/material.dart';

class HomeScreenViewModel extends ChangeNotifier {
  TextEditingController dateController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  int index = 0;
  bool isSearch = false;
  void changePage(int index) {
    this.index = index;
    notifyListeners();
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
