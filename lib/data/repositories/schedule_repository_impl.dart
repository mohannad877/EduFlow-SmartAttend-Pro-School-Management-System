import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart'; // Added back
import 'package:uuid/uuid.dart'; // Added back
import 'package:school_schedule_app/domain/entities/schedule.dart';
import 'package:school_schedule_app/domain/entities/enums.dart';
import 'package:school_schedule_app/domain/repositories/i_schedule_repository.dart';
import 'package:school_schedule_app/domain/entities/session.dart';
import 'package:school_schedule_app/data/datasources/local/app_database.dart';
import 'package:school_schedule_app/data/models/mappers.dart';

@LazySingleton(as: IScheduleRepository)
class ScheduleRepositoryImpl implements IScheduleRepository {
  final AppDatabase _db;

  ScheduleRepositoryImpl(this._db);

  @override
  bool get supportsTransactions => true;

  @override
  Future<T> executeInTransaction<T>(Future<T> Function() action) {
    return _db.transaction(action);
  }

  @override
  Future<void> deleteSchedule(String id) async {
    await _db.transaction(() async {
      await (_db.delete(_db.sessionsTable)
            ..where((t) => t.scheduleId.equals(id)))
          .go();
      await (_db.delete(_db.schedulesTable)..where((t) => t.id.equals(id)))
          .go();
    });
  }

  @override
  Future<Schedule?> getScheduleById(String id) async {
    final scheduleDto = await (_db.select(_db.schedulesTable)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (scheduleDto == null) return null;

    final sessionsDto = await (_db.select(_db.sessionsTable)
          ..where((t) => t.scheduleId.equals(id)))
        .get();
    final sessions = sessionsDto.map((e) => e.toDomain()).toList();

    return scheduleDto.toDomain(sessions: sessions);
  }

  @override
  Future<List<Schedule>> getSchedules() async {
    final result = await _db.select(_db.schedulesTable).get();
    // For list view, we might not load sessions to be efficient
    return result.map((e) => e.toDomain()).toList();
  }

  @override
  Future<Schedule?> getActiveSchedule() async {
    final scheduleDto = await (_db.select(_db.schedulesTable)
          ..where((t) => t.status.equals(ScheduleStatus.active.index))
          ..orderBy([
            (t) => OrderingTerm(
                expression: t.creationDate, mode: OrderingMode.desc)
          ])
          ..limit(1))
        .getSingleOrNull();

    if (scheduleDto == null) return null;

    final sessionsDto = await (_db.select(_db.sessionsTable)
          ..where((t) => t.scheduleId.equals(scheduleDto.id)))
        .get();
    final sessions = sessionsDto.map((e) => e.toDomain()).toList();

    return scheduleDto.toDomain(sessions: sessions);
  }

  @override
  Future<List<Session>> getSessionsByScheduleId(String scheduleId) async {
    final sessionsDto = await (_db.select(_db.sessionsTable)
          ..where((t) => t.scheduleId.equals(scheduleId)))
        .get();
    return sessionsDto.map((e) => e.toDomain()).toList();
  }

  @override
  Future<void> updateSession(Session session) async {
    // Get the scheduleId from the session's metadata or find it
    final schedules = await _db.select(_db.schedulesTable).get();
    final activeSchedule = schedules.firstWhere(
      (s) => s.status == ScheduleStatus.active,
      orElse: () => schedules.first,
    );

    final dto = session.toDto(activeSchedule.id);
    await _db.into(_db.sessionsTable).insertOnConflictUpdate(dto);
  }

  @override
  Future<void> deleteSession(String sessionId) async {
    await (_db.delete(_db.sessionsTable)..where((t) => t.id.equals(sessionId)))
        .go();
  }

  @override
  Future<void> saveSchedule(Schedule schedule) async {
    await _db.transaction(() async {
      await _db
          .into(_db.schedulesTable)
          .insertOnConflictUpdate(schedule.toDto());

      // First, delete existing sessions for this schedule to avoid duplicates/orphans if fully replacing
      // Or we can be smarter about updates. For now, simple replacement strategy if needed.
      // But let's just insert/update sessions provided.
      await (_db.delete(_db.sessionsTable)
            ..where((t) => t.scheduleId.equals(schedule.id)))
          .go();

      for (var session in schedule.sessions) {
        await _db
            .into(_db.sessionsTable)
            .insertOnConflictUpdate(session.toDto(schedule.id));
      }
    });
  }

  @override
  Future<Schedule> generateSchedule(String schoolId) {
    // Placeholder for real generation
    return Future.value(Schedule(
      id: const Uuid().v4(),
      name: 'Generated Schedule',
      creationDate: DateTime.now(),
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 30)),
      schoolId: schoolId,
      creatorId: 'system',
      status: ScheduleStatus.draft,
      sessions: const [],
      metadata: const {},
    ));
  }
}
