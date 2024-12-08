import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TextFieldController extends GetxController {
  var titleController = TextEditingController();
  var descriptionController = TextEditingController();

  var isTitleEmpty = true.obs;
  var isDescriptionEmpty = true.obs;

  @override
  void onInit() {
    super.onInit();
    titleController.addListener(() {
      isTitleEmpty.value = titleController.text.isEmpty;
    });
    descriptionController.addListener(() {
      isDescriptionEmpty.value = descriptionController.text.isEmpty;
    });
  }

  bool get isBothFieldsFilled =>
      !isTitleEmpty.value && !isDescriptionEmpty.value;
}
