import 'package:school_schedule_app/core/navigation/app_router.dart';
import 'package:school_schedule_app/core/utils/l10n_extension.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:drift/drift.dart' as drift;
import 'package:school_schedule_app/core/database/attendance_database.dart';
import 'package:school_schedule_app/domain/repositories/i_subject_repository.dart';
import 'package:school_schedule_app/domain/repositories/i_classroom_repository.dart';
import 'package:school_schedule_app/domain/entities/classroom.dart';
import 'package:school_schedule_app/domain/entities/subject.dart';

// ============================================================================
// SchoolDataBridge — Timetable → Attendance Synchronization Service
// ============================================================================

class SyncOptions {
  final bool syncSubjects;
  final bool syncClassroomsAsSections;
  final bool syncTeachers;
  final bool updateExisting;
  final bool deleteOrphans;
  final String defaultStageName;
  final String defaultGradeName;
  final VoidCallback? onProgress;

  SyncOptions({
    this.syncSubjects = true,
    this.syncClassroomsAsSections = true,
    this.syncTeachers = false, // disabled: AttendanceDB has no teachers table
    this.updateExisting = true,
    this.deleteOrphans = false,
    String? defaultStageName,
    String? defaultGradeName,
    this.onProgress,
  })  : defaultStageName = defaultStageName ?? AppNavigator.navigatorKey.currentContext!.l10n.primaryLevel,
        defaultGradeName = defaultGradeName ?? AppNavigator.navigatorKey.currentContext!.l10n.generalGrades;
}

class SyncResult {
  // Mutable accumulators — filled during sync then exposed as getters
  int _subjectsAdded = 0;
  int _subjectsUpdated = 0;
  int _subjectsDeleted = 0;
  int _sectionsAdded = 0;
  int _sectionsUpdated = 0;
  int _sectionsDeleted = 0;
  final List<String> errors = [];

  int get subjectsAdded => _subjectsAdded;
  int get subjectsUpdated => _subjectsUpdated;
  int get subjectsDeleted => _subjectsDeleted;
  int get sectionsAdded => _sectionsAdded;
  int get sectionsUpdated => _sectionsUpdated;
  int get sectionsDeleted => _sectionsDeleted;

  int get teachersAdded => 0; // Legacy support
  int get teachersUpdated => 0;

  bool get hasErrors => errors.isNotEmpty;

  @override
  String toString() =>
      'SyncResult(subjects: +$_subjectsAdded/~$_subjectsUpdated/-$_subjectsDeleted, '
      'sections: +$_sectionsAdded/~$_sectionsUpdated/-$_sectionsDeleted, '
      'errors: ${errors.length})';
}

class SchoolDataBridge {
  /// Primary entry point: sync Timetable → Attendance DB.
  static Future<SyncResult> syncFromTimetableToAttendance({
    AttendanceDatabase? attDb,
    SyncOptions? options,
  }) async {
    final syncOptions = options ?? SyncOptions();
    final attendanceDb = attDb ?? GetIt.I<AttendanceDatabase>();
    final result = SyncResult();

    try {
      debugPrint('SchoolDataBridge: starting sync...');

      final subjectRepo = GetIt.I<ISubjectRepository>();
      final classroomRepo = GetIt.I<IClassroomRepository>();

      final subjects = await subjectRepo.getSubjects();
      final classrooms = await classroomRepo.getClassrooms();

      if (subjects.isEmpty && classrooms.isEmpty) {
        debugPrint('SchoolDataBridge: nothing to sync.');
        return result;
      }

      await attendanceDb.transaction(() async {
        final stageId = await _getOrCreateStage(attendanceDb, syncOptions.defaultStageName);
        final gradeId = await _getOrCreateGrade(attendanceDb, syncOptions.defaultGradeName, stageId);

        if (syncOptions.syncClassroomsAsSections) {
          await _syncSections(attendanceDb, classrooms, gradeId, result, syncOptions);
          syncOptions.onProgress?.call();
        }

        if (syncOptions.syncSubjects) {
          await _syncSubjects(attendanceDb, subjects, gradeId, result, syncOptions);
          syncOptions.onProgress?.call();
        }
      });

      debugPrint('SchoolDataBridge: sync complete — $result');
    } catch (e, stack) {
      final msg = 'SchoolDataBridge sync failed: $e';
      debugPrint('$msg\n$stack');
      result.errors.add(msg);
    }

    return result;
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  static Future<int> _getOrCreateStage(AttendanceDatabase db, String name) async {
    final existing = await (db.select(db.attStages)
          ..where((s) => s.name.equals(name)))
        .getSingleOrNull();
    if (existing != null) return existing.id;

    return db.into(db.attStages).insert(
          AttStagesCompanion.insert(name: name, sortOrder: const drift.Value(1)),
        );
  }

  static Future<int> _getOrCreateGrade(AttendanceDatabase db, String name, int stageId) async {
    final existing = await (db.select(db.attGrades)
          ..where((g) => g.name.equals(name) & g.stageId.equals(stageId)))
        .getSingleOrNull();
    if (existing != null) return existing.id;

    return db.into(db.attGrades).insert(
          AttGradesCompanion.insert(name: name, stageId: stageId),
        );
  }

  static Future<void> _syncSections(
    AttendanceDatabase db,
    List<Classroom> classrooms,
    int gradeId,
    SyncResult result,
    SyncOptions options,
  ) async {
    final existingSections = await (db.select(db.attSections)
          ..where((s) => s.gradeId.equals(gradeId)))
        .get();
    final existingMap = {for (var s in existingSections) s.name: s};

    for (final classroom in classrooms) {
      try {
        final existing = existingMap[classroom.name];
        if (existing == null) {
          await db.into(db.attSections).insert(
                AttSectionsCompanion.insert(name: classroom.name, gradeId: gradeId),
              );
          result._sectionsAdded++;
        } else if (options.updateExisting) {
          result._sectionsUpdated++;
        }
      } catch (e) {
        result.errors.add('Section sync error (${classroom.name}): $e');
      }
    }

    if (options.deleteOrphans) {
      final sourceNames = classrooms.map((c) => c.name).toSet();
      for (final section in existingSections) {
        if (!sourceNames.contains(section.name)) {
          try {
            await (db.delete(db.attSections)
                  ..where((t) => t.id.equals(section.id)))
                .go();
            result._sectionsDeleted++;
          } catch (e) {
            result.errors.add('Section delete error (${section.name}): $e');
          }
        }
      }
    }
  }

  static Future<void> _syncSubjects(
    AttendanceDatabase db,
    List<Subject> subjects,
    int gradeId,
    SyncResult result,
    SyncOptions options,
  ) async {
    final existingSubjects = await (db.select(db.attSubjects)
          ..where((s) => s.gradeId.equals(gradeId)))
        .get();
    final existingMap = {for (var s in existingSubjects) s.name: s};

    for (final subject in subjects) {
      try {
        final existing = existingMap[subject.name];
        if (existing == null) {
          await db.into(db.attSubjects).insert(
                AttSubjectsCompanion.insert(name: subject.name, gradeId: gradeId),
              );
          result._subjectsAdded++;
        } else if (options.updateExisting) {
          await db.update(db.attSubjects).replace(
                existing.copyWith(name: subject.name),
              );
          result._subjectsUpdated++;
        }
      } catch (e) {
        result.errors.add('Subject sync error (${subject.name}): $e');
      }
    }

    if (options.deleteOrphans) {
      final sourceNames = subjects.map((s) => s.name).toSet();
      for (final sub in existingSubjects) {
        if (!sourceNames.contains(sub.name)) {
          try {
            await (db.delete(db.attSubjects)..where((t) => t.id.equals(sub.id))).go();
            result._subjectsDeleted++;
          } catch (e) {
            result.errors.add('Subject delete error (${sub.name}): $e');
          }
        }
      }
    }
  }
}
