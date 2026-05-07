import 'package:equatable/equatable.dart';
import 'enums.dart';
import 'subject.dart';

class Classroom extends Equatable {
  final String id;
  final String name;
  final String section; // e.g., A, B, C
  final int studentCount;
  final String roomNumber;
  final ClassLevel level;
  final String? supervisorId; // Teacher ID
  final RoomType roomType;
  final List<Subject>
      subjects; // This might be better as definitions or requirements

  const Classroom({
    required this.id,
    required this.name,
    required this.section,
    required this.studentCount,
    required this.roomNumber,
    required this.level,
    this.supervisorId,
    this.roomType = RoomType.lecture,
    required this.subjects,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        section,
        studentCount,
        roomNumber,
        level,
        supervisorId,
        roomType,
        subjects,
      ];
}
