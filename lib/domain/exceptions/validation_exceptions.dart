// lib/domain/exceptions/validation_exceptions.dart

class ValidationError {
  final String field;
  final String message;
  final dynamic value;

  const ValidationError(this.field, this.message, [this.value]);

  @override
  String toString() => 'ValidationError($field): $message';
}

class ValidationException implements Exception {
  final String message;
  final List<ValidationError> errors;
  final String? traceId;

  const ValidationException(this.message, {this.errors = const [], this.traceId});

  @override
  String toString() => 'ValidationException: $message (${errors.length} errors)';
}

/// Thrown when required data (teachers, classrooms, subjects) is missing or insufficient.
class DataValidationException implements Exception {
  final String message;
  final String? traceId;

  const DataValidationException(this.message, {this.traceId});

  @override
  String toString() => 'DataValidationException: $message';
}
