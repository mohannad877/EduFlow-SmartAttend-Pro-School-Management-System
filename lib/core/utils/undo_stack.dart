import 'dart:collection';

class UndoStack<T> {
  final int limit;
  final Queue<T> _history = Queue<T>();
  final Queue<T> _redoHistory = Queue<T>();

  UndoStack({this.limit = 20});

  void add(T item) {
    if (_history.length >= limit) {
      _history.removeFirst();
    }
    _history.addLast(item);
    _redoHistory.clear();
  }

  T? undo() {
    if (_history.isEmpty) return null;
    final item = _history.removeLast();
    _redoHistory.addLast(item);
    return item;
  }

  T? redo() {
    if (_redoHistory.isEmpty) return null;
    final item = _redoHistory.removeLast();
    _history.addLast(item);
    return item;
  }

  bool get canUndo => _history.isNotEmpty;
  bool get canRedo => _redoHistory.isNotEmpty;

  void clear() {
    _history.clear();
    _redoHistory.clear();
  }
}
