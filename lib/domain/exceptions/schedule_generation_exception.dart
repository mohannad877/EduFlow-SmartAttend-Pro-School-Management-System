// lib/domain/exceptions/schedule_generation_exception.dart

class ScheduleGenerationException implements Exception {
  final String message;
  final String? traceId;
  final dynamic cause;
  final Map<String, dynamic>? details;

  const ScheduleGenerationException(
    this.message, {
    this.traceId,
    this.cause,
    this.details,
  });

  @override
  String toString() => 'ScheduleGenerationException: $message';
}
