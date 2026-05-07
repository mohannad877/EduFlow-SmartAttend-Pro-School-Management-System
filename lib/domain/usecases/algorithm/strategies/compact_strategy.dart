import 'dart:math';
import 'package:uuid/uuid.dart';
import 'package:school_schedule_app/domain/entities/schedule.dart';
import 'package:school_schedule_app/domain/entities/teacher.dart';
import 'package:school_schedule_app/domain/entities/subject.dart';
import 'package:school_schedule_app/domain/entities/classroom.dart';
import 'package:school_schedule_app/domain/entities/session.dart';
import 'package:school_schedule_app/domain/entities/enums.dart';
import 'generation_strategy.dart';

class CompactStrategy implements GenerationStrategy {
  @override
  Future<Schedule> generate({
    required int dailySessions,
    required List<WorkDay> workDays,
    required List<Teacher> teachers,
    required List<Subject> subjects,
    required List<Classroom> classrooms,
    List<String>? targetClassroomIds,
  }) async {
    final random = Random();
    var generatedSessions = <Session>[];

    // Helper to check classroom occupancy
    bool isClassroomOccupied(String classroomId, WorkDay day, int sessionNum) {
      return generatedSessions.any((s) =>
          s.classId == classroomId &&
          s.day == day &&
          s.sessionNumber == sessionNum);
    }

    // Helper to check teacher occupancy
    bool isTeacherOccupied(String teacherId, WorkDay day, int sessionNum) {
      return generatedSessions.any((s) =>
          s.teacherId == teacherId &&
          s.day == day &&
          s.sessionNumber == sessionNum);
    }

    final days = workDays;

    // Compact Strategy:
    // Prioritize filling days completely for a teacher before moving to next day?
    // Or filling classrooms tightly?
    // Let's try to minimize teacher gaps.
    // Iterate teachers, try to fit their subjects.

    // Sort teachers by workload (heaviest first)
    // This is hard because we iterate time slots usually.
    // If we iterate teachers, we might block other teachers.

    // Alternative: Iterate time slots, but when picking a teacher, pick one who already has a session adjacent to this slot.

    for (var day in days) {
      for (var sessionNum = 1; sessionNum <= dailySessions; sessionNum++) {
        final shuffledClassrooms = List.of(classrooms)..shuffle(random);

        for (var classroom in shuffledClassrooms) {
          if (isClassroomOccupied(classroom.id, day, sessionNum)) continue;
          if (subjects.isEmpty) continue;

          final shuffledSubjects = List.of(subjects)..shuffle(random);

          for (final subject in shuffledSubjects) {
            final availableTeachers = teachers
                .where((t) =>
                    t.subjectIds.contains(subject.id) &&
                    !isTeacherOccupied(t.id, day, sessionNum))
                .toList();

            if (availableTeachers.isEmpty) continue;

            // Compact Logic:
            // Score teachers. +1 if they have a session at sessionNum-1 or sessionNum+1 on this day.
            Teacher? bestTeacher;
            var bestScore = -1;

            for (var t in availableTeachers) {
              var score = 0;
              // Check adjacency
              if (isTeacherOccupied(t.id, day, sessionNum - 1)) score += 10;
              if (isTeacherOccupied(t.id, day, sessionNum + 1)) score += 10;

              // Tie breaker: Random
              score += random.nextInt(5);

              if (score > bestScore) {
                bestScore = score;
                bestTeacher = t;
              }
            }

            bestTeacher ??= availableTeachers[random.nextInt(availableTeachers.length)];

            final session = Session(
              id: const Uuid().v4(),
              day: day,
              sessionNumber: sessionNum,
              classId: classroom.id,
              teacherId: bestTeacher.id,
              subjectId: subject.id,
              roomId: classroom.id,
              status: SessionStatus.scheduled,
            );

            generatedSessions.add(session);
            break;
          }
        }
      }
    }

    final now = DateTime.now();
    return Schedule(
      id: const Uuid().v4(),
      name: 'Compact Schedule ${now.toIso8601String()}',
      creationDate: now,
      startDate: now,
      endDate: now.add(const Duration(days: 90)),
      schoolId: 'default_school',
      creatorId: 'system',
      status: ScheduleStatus.active,
      sessions: generatedSessions,
      metadata: const {'strategy': 'compact'},
    );
  }
}
