// lib/domain/events/schedule_events.dart
// Domain-level events for the event bus (decoupled communication)

abstract class DomainEvent {
  final String traceId;
  final DateTime timestamp;

  DomainEvent({required this.traceId, DateTime? timestamp})
      : timestamp = timestamp ?? DateTime.now();
}

class ScheduleGeneratedEvent extends DomainEvent {
  final String scheduleId;
  final String schoolId;
  final dynamic qualityGrade;
  final int totalSessions;
  final String generatedBy;

  ScheduleGeneratedEvent({
    required this.scheduleId,
    required this.schoolId,
    required this.qualityGrade,
    required this.totalSessions,
    required this.generatedBy,
    required super.traceId,
    super.timestamp,
  });
}

class ScheduleIncompleteEvent extends DomainEvent {
  final String scheduleId;
  final int unassignedCount;
  final List<dynamic> details;

  ScheduleIncompleteEvent({
    required this.scheduleId,
    required this.unassignedCount,
    required this.details,
    required super.traceId,
    super.timestamp,
  });
}
