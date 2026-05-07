import 'package:equatable/equatable.dart';

/// Represents a single scheduled session slot in the timetable
/// This is different from Schedule which is a container for multiple sessions
class ScheduleEntry extends Equatable {
  final String id;
  final String teacherId;
  final String classroomId;
  final String subjectId;
  final int dayIndex; // 0 = Sunday, 1 = Monday, etc.
  final int sessionIndex; // 0-based session number in the day

  const ScheduleEntry({
    required this.id,
    required this.teacherId,
    required this.classroomId,
    required this.subjectId,
    required this.dayIndex,
    required this.sessionIndex,
  });

  @override
  List<Object?> get props => [
        id,
        teacherId,
        classroomId,
        subjectId,
        dayIndex,
        sessionIndex,
      ];
}
