import 'package:equatable/equatable.dart';
import 'enums.dart';

class Session extends Equatable {
  final String id;
  final WorkDay day;
  final int sessionNumber; // 1-based index
  final String classId;
  final String teacherId;
  final String subjectId;
  final String roomId;
  final SessionStatus status;
  final DateTime? actualDate;
  final String? notes;

  const Session({
    required this.id,
    required this.day,
    required this.sessionNumber,
    required this.classId,
    required this.teacherId,
    required this.subjectId,
    required this.roomId,
    required this.status,
    this.actualDate,
    this.notes,
  });

  factory Session.empty() {
    return const Session(
      id: '',
      day: WorkDay.sunday,
      sessionNumber: 1,
      classId: '',
      teacherId: '',
      subjectId: '',
      roomId: '',
      status: SessionStatus.pending,
    );
  }

  Session copyWith({
    String? id,
    WorkDay? day,
    int? sessionNumber,
    String? classId,
    String? teacherId,
    String? subjectId,
    String? roomId,
    SessionStatus? status,
    DateTime? actualDate,
    String? notes,
  }) {
    return Session(
      id: id ?? this.id,
      day: day ?? this.day,
      sessionNumber: sessionNumber ?? this.sessionNumber,
      classId: classId ?? this.classId,
      teacherId: teacherId ?? this.teacherId,
      subjectId: subjectId ?? this.subjectId,
      roomId: roomId ?? this.roomId,
      status: status ?? this.status,
      actualDate: actualDate ?? this.actualDate,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [
        id,
        day,
        sessionNumber,
        classId,
        teacherId,
        subjectId,
        roomId,
        status,
        actualDate,
        notes,
      ];
}
