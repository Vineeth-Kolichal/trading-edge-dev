import 'package:get/get.dart';

class SwitchController extends GetxController {
  RxBool switchValue = false.obs;
  void toggleSwitch(bool value) {
    switchValue.value = value;
  }

  bool get isEnabled => switchValue.value;
}
