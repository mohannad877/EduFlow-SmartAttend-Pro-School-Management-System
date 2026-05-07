// lib/domain/exceptions/repository_exceptions.dart

class RepositoryException implements Exception {
  final String message;
  final String? traceId;
  final dynamic cause;

  const RepositoryException(this.message, {this.traceId, this.cause});

  @override
  String toString() => 'RepositoryException: $message';
}
