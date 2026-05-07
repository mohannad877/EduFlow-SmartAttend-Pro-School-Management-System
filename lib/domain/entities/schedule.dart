import 'package:equatable/equatable.dart';
import 'enums.dart';
import 'session.dart';

class Schedule extends Equatable {
  final String id;
  final String name;
  final DateTime creationDate;
  final DateTime startDate;
  final DateTime endDate;
  final String schoolId;
  final String creatorId; // User ID
  final ScheduleStatus status;
  final List<Session> sessions;
  final Map<String, dynamic> metadata;

  const Schedule({
    required this.id,
    required this.name,
    required this.creationDate,
    required this.startDate,
    required this.endDate,
    required this.schoolId,
    required this.creatorId,
    required this.status,
    required this.sessions,
    required this.metadata,
  });

  Schedule copyWith({
    String? id,
    String? name,
    DateTime? creationDate,
    DateTime? startDate,
    DateTime? endDate,
    String? schoolId,
    String? creatorId,
    ScheduleStatus? status,
    List<Session>? sessions,
    Map<String, dynamic>? metadata,
  }) {
    return Schedule(
      id: id ?? this.id,
      name: name ?? this.name,
      creationDate: creationDate ?? this.creationDate,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      schoolId: schoolId ?? this.schoolId,
      creatorId: creatorId ?? this.creatorId,
      status: status ?? this.status,
      sessions: sessions ?? this.sessions,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        creationDate,
        startDate,
        endDate,
        schoolId,
        creatorId,
        status,
        sessions,
        metadata,
      ];
}
