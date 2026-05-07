// lib/core/exceptions/app_exceptions.dart
// Universal App Exception used across all layers

class AppException implements Exception {
  final String code;
  final String message;
  final dynamic cause;
  final Map<String, dynamic>? details;

  const AppException(
    this.code, {
    this.message = '',
    this.cause,
    this.details,
  });

  @override
  String toString() => 'AppException($code): $message';
}

class OperationCancelledException extends AppException {
  const OperationCancelledException([String message = 'Operation was cancelled'])
      : super('operation_cancelled', message: message);
}
