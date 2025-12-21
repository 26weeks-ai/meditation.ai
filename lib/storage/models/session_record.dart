import 'package:isar/isar.dart';

part 'session_record.g.dart';

@collection
class SessionRecord {
  Id id = Isar.autoIncrement;

  late DateTime startTime;
  late DateTime endTime;
  late int plannedDurationMinutes;
  int actualDurationMinutes = 0;
  bool completed = false;
  bool interrupted = false;
  String? note;
}
