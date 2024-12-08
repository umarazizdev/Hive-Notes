import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_notes/models/notesmodel.dart';
import 'package:hive_notes/controller/textfieldcontroller.dart';
import 'package:hive_notes/controller/wordcountcontroller.dart';
import 'package:intl/intl.dart';

class EditView extends StatefulWidget {
  String title, description, dateandtime;
  int color;
  NotesModel notesmodel;
  EditView(
      {super.key,
      required this.description,
      required this.title,
      required this.color,
      required this.dateandtime,
      required this.notesmodel});

  @override
  State<EditView> createState() => _EditViewState();
}

class _EditViewState extends State<EditView> {
  final TextFieldController _textFieldController =
      Get.put(TextFieldController());
  String formattedDate = DateFormat('MMMM d h:mm a EE').format(DateTime.now());

  final WordCountController _wordCountController =
      Get.put(WordCountController());

  @override
  Widget build(BuildContext context) {
    _textFieldController.titleController.text = widget.title;
    _textFieldController.descriptionController.text = widget.description;
    _wordCountController.countWords(widget.description);
    return Scaffold(
      backgroundColor: Color(widget.color),
      appBar: AppBar(
        backgroundColor: Color(widget.color),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      deleteNote(widget.notesmodel);
                      Get.back();
                    },
                    icon: const Icon(
                      Icons.delete,
                      size: 30,
                      color: Colors.red,
                    )),
                const SizedBox(
                  width: 5,
                ),
                Obx(
                  () => IconButton(
                      onPressed: () async {
                        String formattedDate =
                            DateFormat('MMMM d, y').format(DateTime.now());
                        widget.notesmodel.title = _textFieldController
                            .titleController.text
                            .toString();
                        widget.notesmodel.description = _textFieldController
                            .descriptionController.text
                            .toString();
                        widget.notesmodel.dateandtime = formattedDate;
                        widget.notesmodel.save();
                        _textFieldController.titleController.clear();
                        _textFieldController.descriptionController.clear();
                        Get.back();
                      },
                      icon: Icon(
                        Icons.done,
                        size: 30,
                        color: _textFieldController.isBothFieldsFilled
                            ? Colors.black
                            : Colors.grey,
                      )),
                ),
              ],
            ),
          )
        ],
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
              child: Icon(
                  Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _textFieldController.titleController,
                cursorHeight: 35,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  height: 2.0,
                ),
                decoration: InputDecoration(
                  hintText: "Input Title",
                  hintStyle: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                ),
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Obx(
                    () => Text(
                      "${widget.dateandtime} | ${_wordCountController.wordCount} words",
                      style: TextStyle(
                          letterSpacing: 0,
                          fontSize: 14,
                          color: Colors.grey[600]),
                    ),
                  )),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                maxLines: 15,
                onChanged: (text) {
                  _wordCountController.countWords(text);
                },
                controller: _textFieldController.descriptionController,
                style: const TextStyle(fontSize: 17, letterSpacing: 0),
                decoration: const InputDecoration(
                  hintText: "",
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void deleteNote(NotesModel notesModel) async {
    await notesModel.delete();
  }
}
