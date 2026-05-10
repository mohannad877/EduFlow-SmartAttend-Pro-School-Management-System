// lib/domain/services/event_bus_service.dart
// Simple event bus for decoupled domain event publishing

import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:school_schedule_app/domain/events/schedule_events.dart';

@lazySingleton
class EventBusService {
  final _controller = StreamController<DomainEvent>.broadcast();

  Stream<DomainEvent> get events => _controller.stream;

  Future<void> publish(DomainEvent event) async {
    _controller.add(event);
  }

  Stream<T> on<T extends DomainEvent>() {
    return _controller.stream.where((event) => event is T).cast<T>();
  }

  void dispose() {
    _controller.close();
  }
}
