import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:school_schedule_app/domain/repositories/i_school_repository.dart';
import 'package:school_schedule_app/domain/repositories/i_schedule_repository.dart';
import 'package:school_schedule_app/domain/entities/session.dart';
import 'package:school_schedule_app/domain/entities/school.dart';

// ============================================================================
// CurrentSessionService
// ============================================================================
/// Detects the current running period from the active timetable and school
/// configuration. Uses the school's firstSessionTime (TimeOfDay) and
/// sessionDuration (int minutes) to compute which period is now active.
// ============================================================================

class CurrentSessionResult {
  final int periodNumber;
  final String classId;
  final String teacherId;
  final String subjectId;
  final DateTime sessionStart;
  final DateTime sessionEnd;

  const CurrentSessionResult({
    required this.periodNumber,
    required this.classId,
    required this.teacherId,
    required this.subjectId,
    required this.sessionStart,
    required this.sessionEnd,
  });

  bool get isActive {
    final now = DateTime.now();
    return now.isAfter(sessionStart) && now.isBefore(sessionEnd);
  }

  Duration get remainingTime => sessionEnd.difference(DateTime.now());
}

class CurrentSessionService {
  /// Returns the [CurrentSessionResult] for the period happening right now,
  /// or `null` if outside school hours or no schedule is set.
  static Future<CurrentSessionResult?> getCurrentSession({
    String? classroomId,
  }) async {
    try {
      final schoolRepo = GetIt.I<ISchoolRepository>();
      final scheduleRepo = GetIt.I<IScheduleRepository>();

      final school = await schoolRepo.getSchool();
      if (school == null) return null;

      final schedules = await scheduleRepo.getSchedules();
      if (schedules.isEmpty) return null;

      final active = schedules.firstWhere(
        (s) => s.status.name == 'active',
        orElse: () => schedules.first,
      );

      final now = DateTime.now();
      final todayKey = _weekdayKey(now);
      if (todayKey == null) return null;

      if (!school.workDays.any((d) => d.name == todayKey)) return null;

      // Convert TimeOfDay → total minutes from midnight
      final firstMinutes = _todToMinutes(school.firstSessionTime);
      final duration = school.sessionDuration;
      const breakMinutes = 5;
      final nowMinutes = now.hour * 60 + now.minute;

      int? currentPeriod;
      DateTime? periodStart;
      DateTime? periodEnd;

      for (var i = 1; i <= school.dailySessions; i++) {
        final startMin = firstMinutes + (i - 1) * (duration + breakMinutes);
        final endMin = startMin + duration;

        if (nowMinutes >= startMin && nowMinutes < endMin) {
          currentPeriod = i;
          periodStart = DateTime(now.year, now.month, now.day,
              startMin ~/ 60, startMin % 60);
          periodEnd = DateTime(now.year, now.month, now.day,
              endMin ~/ 60, endMin % 60);
          break;
        }
      }

      if (currentPeriod == null) return null;

      final matchingSession = _findSession(
        sessions: active.sessions,
        dayKey: todayKey,
        period: currentPeriod,
        classroomId: classroomId,
      );

      if (matchingSession == null) return null;

      return CurrentSessionResult(
        periodNumber: currentPeriod,
        classId: matchingSession.classId,
        teacherId: matchingSession.teacherId,
        subjectId: matchingSession.subjectId,
        sessionStart: periodStart!,
        sessionEnd: periodEnd!,
      );
    } catch (e, stack) {
      debugPrint('CurrentSessionService.getCurrentSession error: $e\n$stack');
      return null;
    }
  }

  /// Returns all sessions scheduled for today ordered by period number.
  static Future<List<TodaySession>> getTodaySessions() async {
    try {
      final schoolRepo = GetIt.I<ISchoolRepository>();
      final scheduleRepo = GetIt.I<IScheduleRepository>();

      final school = await schoolRepo.getSchool();
      if (school == null) return [];

      final schedules = await scheduleRepo.getSchedules();
      if (schedules.isEmpty) return [];

      final active = schedules.firstWhere(
        (s) => s.status.name == 'active',
        orElse: () => schedules.first,
      );

      final now = DateTime.now();
      final todayKey = _weekdayKey(now);
      if (todayKey == null) return [];

      if (!school.workDays.any((d) => d.name == todayKey)) return [];

      final todaySessions = active.sessions
          .where((s) => s.day.name == todayKey)
          .toList()
        ..sort((a, b) => a.sessionNumber.compareTo(b.sessionNumber));

      final firstMinutes = _todToMinutes(school.firstSessionTime);
      const breakMinutes = 5;

      return todaySessions.map((s) {
        final idx = s.sessionNumber - 1;
        final startMin = firstMinutes + idx * (school.sessionDuration + breakMinutes);
        final endMin = startMin + school.sessionDuration;
        final start = DateTime(now.year, now.month, now.day, startMin ~/ 60, startMin % 60);
        final end = DateTime(now.year, now.month, now.day, endMin ~/ 60, endMin % 60);

        return TodaySession(
          session: s,
          periodStart: start,
          periodEnd: end,
          school: school,
        );
      }).toList();
    } catch (e) {
      debugPrint('CurrentSessionService.getTodaySessions error: $e');
      return [];
    }
  }

  // ── Private helpers ───────────────────────────────────────────────────────

  /// Converts Flutter's [TimeOfDay] to total minutes from midnight.
  static int _todToMinutes(TimeOfDay tod) => tod.hour * 60 + tod.minute;

  /// Maps [DateTime.weekday] (1=Mon…7=Sun) to the School entity's day name.
  static String? _weekdayKey(DateTime dt) => const {
        1: 'monday',
        2: 'tuesday',
        3: 'wednesday',
        4: 'thursday',
        5: 'friday',
        6: 'saturday',
        7: 'sunday',
      }[dt.weekday];

  static Session? _findSession({
    required List<Session> sessions,
    required String dayKey,
    required int period,
    String? classroomId,
  }) {
    try {
      if (classroomId != null) {
        return sessions.firstWhere(
          (s) =>
              s.day.name == dayKey &&
              s.sessionNumber == period &&
              s.classId == classroomId,
        );
      }
      return sessions.firstWhere(
        (s) => s.day.name == dayKey && s.sessionNumber == period,
      );
    } catch (_) {
      return null;
    }
  }
}

// ── TodaySession DTO ─────────────────────────────────────────────────────────

class TodaySession {
  final Session session;
  final DateTime periodStart;
  final DateTime periodEnd;
  final School school;

  const TodaySession({
    required this.session,
    required this.periodStart,
    required this.periodEnd,
    required this.school,
  });

  bool get isActive {
    final now = DateTime.now();
    return now.isAfter(periodStart) && now.isBefore(periodEnd);
  }

  bool get isPast => DateTime.now().isAfter(periodEnd);
  bool get isUpcoming => DateTime.now().isBefore(periodStart);

  String get timeRange => '${_fmt(periodStart)}–${_fmt(periodEnd)}';

  String _fmt(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
}
