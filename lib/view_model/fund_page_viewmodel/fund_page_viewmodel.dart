import 'package:flutter/material.dart';

class FundPageViewModel extends ChangeNotifier {
  bool switchValue = false;
  String dateText = '';
  void changeSwitchState() {
    if (switchValue) {
      switchValue = false;
    } else {
      switchValue = true;
    }
    notifyListeners();
  }

  void setSwitchValue(bool value) {
    switchValue = value;
    notifyListeners();
  }

  void setDateText(String dateText) {
    this.dateText = dateText;
    notifyListeners();
  }
}
