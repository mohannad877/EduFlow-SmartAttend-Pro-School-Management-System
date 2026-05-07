import 'package:injectable/injectable.dart';
import 'package:school_schedule_app/domain/entities/schedule.dart';
import 'package:school_schedule_app/domain/entities/session.dart';
import 'package:school_schedule_app/domain/entities/enums.dart';

@injectable
class ConflictResolver {
  /// Finds an alternative slot for the given session where no conflicts exist.
  /// Returns a new Session with updated Day and SessionNumber, or null if no slot found.
  Session? findAlternativeSlot({
    required Session session,
    required Schedule schedule,
    required int dailySessions,
    required int workDays,
  }) {
    // We need to find a slot (Day, SessionNum) where:
    // 1. The classroom is free.
    // 2. The teacher is free.

    // Iterate all possible slots
    for (var dayIndex = 0; dayIndex < workDays; dayIndex++) {
      final day = WorkDay.values[dayIndex];
      for (var sessionNum = 1; sessionNum <= dailySessions; sessionNum++) {
        // Skip current slot (it's the conflict source, or just same slot)
        if (day == session.day && sessionNum == session.sessionNumber) continue;

        // Check Classroom Availability
        final isClassroomBusy = schedule.sessions.any((s) =>
                s.classId == session.classId &&
                s.day == day &&
                s.sessionNumber == sessionNum &&
                s.id !=
                    session
                        .id // Exclude self if we are moving an existing session
            );

        if (isClassroomBusy) continue;

        // Check Teacher Availability (if teacher is assigned)
        if (session.teacherId.isNotEmpty) {
          final isTeacherBusy = schedule.sessions.any((s) =>
              s.teacherId == session.teacherId &&
              s.day == day &&
              s.sessionNumber == sessionNum &&
              s.id != session.id);

          if (isTeacherBusy) continue;
        }

        // Potential Slot Found!
        return session.copyWith(
          day: day,
          sessionNumber: sessionNum,
          status: SessionStatus.scheduled, // Ensure status is valid
        );
      }
    }

    return null; // No solution found
  }
}
