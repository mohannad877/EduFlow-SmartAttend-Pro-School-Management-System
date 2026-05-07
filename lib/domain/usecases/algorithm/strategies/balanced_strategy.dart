import 'dart:math';
import 'package:uuid/uuid.dart';
import 'package:school_schedule_app/domain/entities/schedule.dart';
import 'package:school_schedule_app/domain/entities/teacher.dart';
import 'package:school_schedule_app/domain/entities/subject.dart';
import 'package:school_schedule_app/domain/entities/classroom.dart';
import 'package:school_schedule_app/domain/entities/session.dart';
import 'package:school_schedule_app/domain/entities/enums.dart';
import 'generation_strategy.dart';

class BalancedStrategy implements GenerationStrategy {
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

    // Iterate Days and Sessions
    for (var day in workDays) {
      for (var sessionNum = 1; sessionNum <= dailySessions; sessionNum++) {
        // Shuffle classrooms to distribute "first pick" advantage
        final shuffledClassrooms = List.of(classrooms)..shuffle(random);

        for (var classroom in shuffledClassrooms) {
          if (isClassroomOccupied(classroom.id, day, sessionNum)) continue;

          if (subjects.isEmpty) continue;

          // Shuffle subjects
          final shuffledSubjects = List.of(subjects)..shuffle(random);

          for (final subject in shuffledSubjects) {
            // Find available teachers for this subject
            final availableTeachers = teachers
                .where((t) =>
                    t.subjectIds.contains(subject.id) &&
                    !isTeacherOccupied(t.id, day, sessionNum))
                .toList();

            if (availableTeachers.isEmpty) continue;

            // Pick a random teacher from available ones
            // Improvement: Pick teacher with LEAST load for "Balanced" strategy?
            // For now, random is "fair" distribution over time.
            final teacher =
                availableTeachers[random.nextInt(availableTeachers.length)];

            // Create Session
            final session = Session(
              id: const Uuid().v4(),
              day: day,
              sessionNumber: sessionNum,
              classId: classroom.id,
              teacherId: teacher.id,
              subjectId: subject.id,
              roomId: classroom.id, // Assuming room is classroom for now
              status: SessionStatus.scheduled,
            );

            // Enhanced Validation for Balanced Strategy
            final teacherWeeklySessions = generatedSessions.where((s) => s.teacherId == teacher.id).length;
            final teacherDailySessions = generatedSessions.where((s) => s.teacherId == teacher.id && s.day == day).length;
            
            if (teacherWeeklySessions >= teacher.maxWeeklyHours || teacherDailySessions >= teacher.maxDailyHours) {
              continue;
            }

            generatedSessions.add(session);
            break; // Classroom filled for this slot
          }
        }
      }
    }

    final now = DateTime.now();
    return Schedule(
      id: const Uuid().v4(),
      name: 'Balanced Schedule ${now.toIso8601String()}',
      creationDate: now,
      startDate: now,
      endDate: now.add(const Duration(days: 90)),
      schoolId: 'default_school',
      creatorId: 'system',
      status: ScheduleStatus.active,
      sessions: generatedSessions,
      metadata: const {'strategy': 'balanced'},
    );
  }
}
