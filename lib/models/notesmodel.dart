import 'package:hive_flutter/adapters.dart';
part 'notesmodel.g.dart';

@HiveType(typeId: 0)
class NotesModel extends HiveObject {
  @HiveField(0)
  String title;
  @HiveField(1)
  String description;
  @HiveField(2)
  String dateandtime;
  @HiveField(3)
  int color;
  NotesModel(
      {required this.title,
      required this.dateandtime,
      required this.color,
      required this.description});
}
