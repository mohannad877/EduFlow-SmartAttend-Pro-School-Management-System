import 'package:school_schedule_app/domain/entities/enums.dart';
import 'package:school_schedule_app/domain/entities/schedule.dart';
import 'package:school_schedule_app/domain/entities/teacher.dart';
import 'package:school_schedule_app/domain/entities/subject.dart';
import 'package:school_schedule_app/domain/entities/classroom.dart';

abstract class GenerationStrategy {
  Future<Schedule> generate({
    required int dailySessions,
    required List<WorkDay> workDays,
    required List<Teacher> teachers,
    required List<Subject> subjects,
    required List<Classroom> classrooms,
    List<String>? targetClassroomIds,
  });
}
