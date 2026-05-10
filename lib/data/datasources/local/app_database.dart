import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:school_schedule_app/domain/entities/enums.dart'; // Import for generated code
import 'tables.dart';
import 'converters.dart'; // Import for generated code

part 'app_database.g.dart';

@DriftDatabase(tables: [
  SchoolsTable,
  TeachersTable,
  SubjectsTable,
  ClassroomsTable,
  SessionsTable,
  SchedulesTable
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 6) {
          // recreate SessionsTable to apply new unique constraints
          // Since SQLite doesn't support adding table constraints easily via ALTER TABLE,
          // we'll just drop and recreate it for simplicity (data loss in draft schedules is acceptable here, or use complex migration).
          await customStatement('DROP TABLE IF EXISTS sessions_table');
          await m.createTable(sessionsTable);
        }
        
        // Migration from 1 to 2
        if (from < 2) {
          try {
            await m.addColumn(teachersTable, teachersTable.workDays);
          } catch (e) {
            // Ignore if column exists
          }
        }

        // Migration to version 3 (Robust Repair)
        if (from < 3) {
          try {
            await customStatement(
                "ALTER TABLE teachers_table ADD COLUMN work_days TEXT DEFAULT '[]'");
          } catch (e) {
            // Ignore if column exists
          }

          // Fix any invalid data
          await customStatement(
            "UPDATE teachers_table SET work_days = '[0,1,2,3,4,5]' WHERE work_days IS NULL OR work_days = '' OR work_days = '[]'",
          );
        }

        // Migration to version 4 (Subjects classPeriods)
        if (from < 4) {
          try {
            await customStatement(
                "ALTER TABLE subjects_table ADD COLUMN class_periods TEXT DEFAULT '{}'");
          } catch (e) {
            // Ignore if column exists
          }
        }

        // Migration to version 5 (Add weeklyHours to Subjects)
        if (from < 5) {
          try {
            await customStatement(
                "ALTER TABLE subjects_table ADD COLUMN weekly_hours INTEGER DEFAULT 0");
          } catch (e) {
            // Ignore if column exists
          }
        }
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'school_timetable.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
