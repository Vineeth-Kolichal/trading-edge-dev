import 'package:get/get.dart';

class TextController extends GetxController {
  // ignore: prefer_typing_uninitialized_variables
  var myText;

  TextController({required String initalDate}) {
    myText = initalDate.obs;
  }

  void updateText(String newText) {
    myText.value = newText;
  }
}
