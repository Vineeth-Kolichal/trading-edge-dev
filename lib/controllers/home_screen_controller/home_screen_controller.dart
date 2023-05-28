import 'package:get/get.dart';

class HomeScreenController extends GetxController {
  RxInt tabIndex = 0.obs;
  RxBool isSearchOpen = false.obs;
  void setIndex(int index) {
    if (index != 3) {
      serchOpen(false);
    }
    tabIndex.value = index;
  }

  void serchOpen(bool open) {
    isSearchOpen.value = open;
  }
}
