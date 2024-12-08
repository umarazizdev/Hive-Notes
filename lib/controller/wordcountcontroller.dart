import 'package:get/get.dart';

class WordCountController extends GetxController {
  var wordCount = 0.obs;

  void countWords(String text) {
    int words = text.replaceAll(RegExp(r'[^a-zA-Z]'), '').length;
    wordCount.value = words;
  }
}
