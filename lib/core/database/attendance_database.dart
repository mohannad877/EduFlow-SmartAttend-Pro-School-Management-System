import 'package:school_schedule_app/core/navigation/app_router.dart';
import 'package:school_schedule_app/core/utils/l10n_extension.dart';
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:crypto/crypto.dart';
import 'dart:convert';

part 'attendance_database.g.dart';

// ============================================================================
// TABLES
// ============================================================================

/// جدول الطلاب
@DataClassName('AttStudent')
class AttStudents extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 2, max: 100)();
  TextColumn get stage => text()(); // المرحلة التعليمية
  TextColumn get grade => text()(); // الصف
  TextColumn get section => text()(); // الشعبة
  TextColumn get barcode => text().unique()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

/// جدول المستخدمين
@DataClassName('AttUser')
class AttUsers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 2, max: 100)();
  TextColumn get username => text().unique()();
  TextColumn get passwordHash => text()();
  TextColumn get role => text()(); // admin, teacher
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get lastLogin => dateTime().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

/// جدول المراحل التعليمية
@DataClassName('AttStage')
class AttStages extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

/// جدول الصفوف
@DataClassName('AttGrade')
class AttGrades extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get stageId => integer().references(AttStages, #id)();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  List<Set<Column>> get uniqueKeys => [
        {name, stageId}
      ];
}

/// جدول الشعب
@DataClassName('AttSection')
class AttSections extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get gradeId => integer().references(AttGrades, #id)();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  List<Set<Column>> get uniqueKeys => [
        {name, gradeId}
      ];
}

/// جدول المواد الدراسية (للحضور)
@DataClassName('AttSubject')
class AttSubjects extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get gradeId => integer().references(AttGrades, #id)();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  @override
  List<Set<Column>> get uniqueKeys => [
        {name, gradeId}
      ];
}

/// جدول جلسات التحضير
@DataClassName('AttSession')
class AttSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  IntColumn get gradeId => integer().references(AttGrades, #id)();
  IntColumn get sectionId => integer().references(AttSections, #id)();
  IntColumn get subjectId => integer().references(AttSubjects, #id)();
  IntColumn get periodNumber => integer()();
  IntColumn get teacherId => integer().references(AttUsers, #id).nullable()();
  TextColumn get status => text().withDefault(const Constant('active'))(); // active, closed
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get closedAt => dateTime().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {date, gradeId, sectionId, subjectId, periodNumber}
      ];
}

/// جدول الحضور
@DataClassName('AttRecord')
class AttRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get studentId => integer().references(AttStudents, #id)();
  IntColumn get sessionId => integer().references(AttSessions, #id)();
  TextColumn get status => text()(); // present, absent, late, excused
  DateTimeColumn get recordedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get notes => text().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {studentId, sessionId}
      ];
}

/// سجل التعديلات
@DataClassName('AuditEntry')
class AuditLog extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(AttUsers, #id).nullable()();
  TextColumn get action => text()(); // create, update, delete
  TextColumn get targetTable => text()();
  IntColumn get recordId => integer()();
  TextColumn get oldValue => text().nullable()();
  TextColumn get newValue => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// جدول الإعدادات
@DataClassName('AttSetting')
class AttSettings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get key => text().unique()();
  TextColumn get value => text()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

// ============================================================================
// DATABASE
// ============================================================================

@DriftDatabase(tables: [
  AttStudents,
  AttUsers,
  AttStages,
  AttGrades,
  AttSections,
  AttSubjects,
  AttSessions,
  AttRecords,
  AuditLog,
  AttSettings,
])
class AttendanceDatabase extends _$AttendanceDatabase {
  AttendanceDatabase() : super(_openAttendanceConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          await _insertInitialData();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          // Future migrations
        },
      );

  Future<void> _insertInitialData() async {
    final context = AppNavigator.navigatorKey.currentContext;
    final l10n = context?.l10n;

    // المراحل التعليمية
    await into(attStages).insert(AttStagesCompanion.insert(
      name: l10n?.primaryLevel ?? 'Primary',
      sortOrder: const Value(1),
    ));
    await into(attStages).insert(AttStagesCompanion.insert(
      name: l10n?.middleSchool ?? 'Middle',
      sortOrder: const Value(2),
    ));
    await into(attStages).insert(AttStagesCompanion.insert(
      name: l10n?.highSchool ?? 'High',
      sortOrder: const Value(3),
    ));

    // المشرف الافتراضي
    await into(attUsers).insert(AttUsersCompanion.insert(
      name: l10n?.admin ?? 'Administrator',
      username: 'admin',
      passwordHash: _hashPassword('admin123'),
      role: 'admin',
    ));

    // الإعدادات
    await into(attSettings).insert(AttSettingsCompanion.insert(
      key: 'school_name',
      value: l10n?.schoolName ?? 'My School',
    ));
    await into(attSettings).insert(AttSettingsCompanion.insert(key: 'academic_year', value: '2024-2025'));
    await into(attSettings).insert(AttSettingsCompanion.insert(key: 'periods_per_day', value: '7'));
    await into(attSettings).insert(AttSettingsCompanion.insert(key: 'dark_mode', value: 'false'));
  }

  static String _hashPassword(String password) {
    final bytes = utf8.encode('${password}school_att_salt_2024');
    return sha256.convert(bytes).toString();
  }

  static String hashPasswordStatic(String password) {
    return _hashPassword(password);
  }
}

LazyDatabase _openAttendanceConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'school_attendance.db'));
    return NativeDatabase.createInBackground(file);
  });
}
