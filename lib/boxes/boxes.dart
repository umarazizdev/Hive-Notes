import 'package:hive/hive.dart';
import 'package:hive_notes/models/notesmodel.dart';

class Boxes {
  static Box<NotesModel> getData() => Hive.box<NotesModel>('notes');
}
