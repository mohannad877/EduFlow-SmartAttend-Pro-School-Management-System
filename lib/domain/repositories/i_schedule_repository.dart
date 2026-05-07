import 'package:school_schedule_app/domain/entities/schedule.dart';
import 'package:school_schedule_app/domain/entities/session.dart';

abstract class IScheduleRepository {
  Future<List<Schedule>> getSchedules();
  Future<Schedule?> getScheduleById(String id);
  Future<Schedule?> getActiveSchedule();
  Future<void> saveSchedule(Schedule schedule);
  Future<void> deleteSchedule(String id);
  Future<List<Session>> getSessionsByScheduleId(String scheduleId);
  Future<void> updateSession(Session session);
  Future<void> deleteSession(String sessionId);
  Future<Schedule> generateSchedule(String schoolId);

  /// Whether this repository supports database transactions
  bool get supportsTransactions => false;

  /// Execute a block of code in a transaction, if supported
  Future<T> executeInTransaction<T>(Future<T> Function() block) async {
    return await block();
  }
}
