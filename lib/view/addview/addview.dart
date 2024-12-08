import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:hive_notes/boxes/boxes.dart';
import 'package:hive_notes/controller/selectclrcontroller.dart';
import 'package:hive_notes/models/notesmodel.dart';
import 'package:hive_notes/controller/textfieldcontroller.dart';
import 'package:hive_notes/controller/wordcountcontroller.dart';

class AddView extends StatefulWidget {
  const AddView({super.key});

  @override
  State<AddView> createState() => _AddViewState();
}

class _AddViewState extends State<AddView> {
  final TextFieldController _textFieldController =
      Get.put(TextFieldController());
  final SelectClrController selectclrcontroller =
      Get.put(SelectClrController());
  final WordCountController _wordCountController =
      Get.put(WordCountController());

  final String formattedDate =
      DateFormat('MMMM d h:mm a EE').format(DateTime.now());

  final FocusNode _focusNode = FocusNode();

  final List<Color> colors = [
    Color(0xffA7FEEA),
    Colors.orange,
    Color(0xffFFF476),
    Color(0xffE6C9A9),
    Color(0xffCBFF90),
    const Color.fromARGB(255, 206, 147, 216),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });

    selectclrcontroller.selectedIndex.value = 0;
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          backgroundColor: colors[selectclrcontroller.selectedIndex.value],
          appBar: AppBar(
            actions: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: IconButton(
                  onPressed: () async {
                    String formattedDate =
                        DateFormat('MMMM d y').format(DateTime.now());
                    if (_textFieldController.isBothFieldsFilled) {
                      final data = NotesModel(
                        title: _textFieldController.titleController.text,
                        dateandtime: formattedDate,
                        description:
                            _textFieldController.descriptionController.text,
                        color: colors[selectclrcontroller.selectedIndex.value]
                            .value,
                      );
                      final box = Boxes.getData();
                      box.add(data);
                      data.save();
                      _textFieldController.titleController.clear();
                      _textFieldController.descriptionController.clear();
                      Get.back();
                    }
                  },
                  icon: Icon(
                    Icons.done,
                    size: 30,
                    color: _textFieldController.isBothFieldsFilled
                        ? Colors.black
                        : Colors.grey,
                  ),
                ),
              ),
            ],
            backgroundColor: colors[selectclrcontroller.selectedIndex.value],
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                    shadows: const [
                      BoxShadow(
                        color: Color(0x19000000),
                        blurRadius: 25,
                        offset: Offset(0, 0),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: Icon(Platform.isAndroid
                      ? Icons.arrow_back
                      : Icons.arrow_back_ios),
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(6, (index) {
                        return GestureDetector(
                          onTap: () {
                            selectclrcontroller.selectedIndex.value = index;
                          },
                          child: Obx(() => Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: colors[index],
                                      border: Border.all(
                                          color: Colors.black, width: 2),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  if (selectclrcontroller.selectedIndex.value ==
                                      index)
                                    const Icon(
                                      Icons.done,
                                      color: Colors.white,
                                      size: 35,
                                    ),
                                ],
                              )),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _textFieldController.titleController,
                    cursorHeight: 35,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      height: 2.0,
                    ),
                    decoration: InputDecoration(
                      hintText: "Input Title",
                      hintStyle: TextStyle(
                          color: Colors.black.withOpacity(0.5),
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Obx(
                      () => Text(
                        "$formattedDate | ${_wordCountController.wordCount} words",
                        style: const TextStyle(
                          fontSize: 14,
                          letterSpacing: 0,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    maxLines: 15,
                    onChanged: (text) {
                      _wordCountController.countWords(text);
                    },
                    controller: _textFieldController.descriptionController,
                    focusNode: _focusNode,
                    style: const TextStyle(fontSize: 17, letterSpacing: 0),
                    decoration: const InputDecoration(
                      hintText: "",
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
