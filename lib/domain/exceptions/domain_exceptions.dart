// lib/domain/exceptions/domain_exceptions.dart

class DomainException implements Exception {
  final String message;
  final String? traceId;
  final dynamic cause;

  const DomainException(this.message, {this.traceId, this.cause});

  @override
  String toString() => 'DomainException: $message (traceId: $traceId)';
}

class DataValidationException extends DomainException {
  const DataValidationException(super.message, {super.traceId, super.cause});

  @override
  String toString() => 'DataValidationException: $message';
}
