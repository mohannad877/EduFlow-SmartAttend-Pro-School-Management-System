import 'dart:math';
import 'package:uuid/uuid.dart';
import 'package:school_schedule_app/domain/entities/schedule.dart';
import 'package:school_schedule_app/domain/entities/teacher.dart';
import 'package:school_schedule_app/domain/entities/subject.dart';
import 'package:school_schedule_app/domain/entities/classroom.dart';
import 'package:school_schedule_app/domain/entities/session.dart';
import 'package:school_schedule_app/domain/entities/enums.dart';
import 'generation_strategy.dart';

class PriorityStrategy implements GenerationStrategy {
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

    // Priority Strategy:
    // Sort subjects by priority: High > Medium > Low.
    // Iterate slots (Day/Session).
    // For each slot, try to assign Highest priority subjects first.

    // Actually, iterating slots means we fill slots chronologically.
    // If we want high priority subjects to have *any* slot, we should iterate subjects and find slots for them?
    // But we need to fill classrooms.
    // Let's stick to slot-iteration but pick best subject for the slot.
    // Or better: Iterate Classrooms. For each classroom, fill its schedule.
    // When filling a classroom's schedule, prioritize High priority subjects.

    // Let's use the standard loop: Day -> Session -> Classroom.
    // But when choosing a subject for a classroom-slot:
    // fail-fast if no subject fits.
    // Pick from available subjects, sorted by Priority.

    for (var day in days) {
      for (var sessionNum = 1; sessionNum <= dailySessions; sessionNum++) {
        final shuffledClassrooms = List.of(classrooms)..shuffle(random);

        for (var classroom in shuffledClassrooms) {
          if (isClassroomOccupied(classroom.id, day, sessionNum)) continue;
          if (subjects.isEmpty) continue;

          // Filter available subjects for this classroom/slot (must have available teacher)
          // validSubjects = subjects where teacher is available.
          // Then sort by priority.

          var validSubjects = <Subject>[];
          for (var subject in subjects) {
            final availableTeachers = teachers
                .where((t) =>
                    t.subjectIds.contains(subject.id) &&
                    !isTeacherOccupied(t.id, day, sessionNum))
                .toList();

            if (availableTeachers.isNotEmpty) {
              validSubjects.add(subject);
            }
          }

          if (validSubjects.isEmpty) continue;

          // Sort by Priority
          validSubjects.sort((a, b) {
            // High (0) < Medium (1) < Low (2) ?
            // Enum SubjectPriority { high, medium, low }
            // So index 0 is high.
            return a.priority.index.compareTo(b.priority.index);
          });

          // Take top priority. If multiple with same priority, pick random or first?
          // Pick one of the highest priority ones to avoid deterministic repetition.
          final highestPriority = validSubjects.first.priority;
          final contentenders = validSubjects
              .where((s) => s.priority == highestPriority)
              .toList();
          final subject = contentenders[random.nextInt(contentenders.length)];

          // Find teacher for this subject (we know one exists)
          final availableTeachers = teachers
              .where((t) =>
                  t.subjectIds.contains(subject.id) &&
                  !isTeacherOccupied(t.id, day, sessionNum))
              .toList();

          final teacher =
              availableTeachers[random.nextInt(availableTeachers.length)];

          final session = Session(
            id: const Uuid().v4(),
            day: day,
            sessionNumber: sessionNum,
            classId: classroom.id,
            teacherId: teacher.id,
            subjectId: subject.id,
            roomId: classroom.id,
            status: SessionStatus.scheduled,
          );

          generatedSessions.add(session);
          break;
        }
      }
    }

    final now = DateTime.now();
    return Schedule(
      id: const Uuid().v4(),
      name: 'Priority Schedule ${now.toIso8601String()}',
      creationDate: now,
      startDate: now,
      endDate: now.add(const Duration(days: 90)),
      schoolId: 'default_school',
      creatorId: 'system',
      status: ScheduleStatus.active,
      sessions: generatedSessions,
      metadata: const {'strategy': 'priority'},
    );
  }
}
