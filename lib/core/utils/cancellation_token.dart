import 'dart:async';
import 'package:meta/meta.dart';

@immutable
class CancellationToken {
  final _Completer<void> _completer = _Completer<void>();
  
  Future<void> get cancelled => _completer.future;
  bool get isCancelled => _completer.isCompleted;
  
  void cancel() {
    if (!_completer.isCompleted) {
      _completer.complete();
    }
  }
  
  static CancellationToken createLinked(CancellationToken? token) {
    if (token == null) return CancellationToken();
    final newToken = CancellationToken();
    token.cancelled.whenComplete(() => newToken.cancel());
    return newToken;
  }
}

class _Completer<T> {
  final _future = Completer<T>();
  Future<T> get future => _future.future;
  bool get isCompleted => _future.isCompleted;
  void complete([FutureOr<T>? value]) => _future.complete(value);
}
