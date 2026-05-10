import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:school_schedule_app/core/database/attendance_database.dart';
import 'package:school_schedule_app/core/database/attendance_providers.dart';
import 'package:school_schedule_app/data/datasources/local/app_database.dart';
import 'package:school_schedule_app/core/di/injection.dart';
import 'package:school_schedule_app/domain/entities/enums.dart';

class TestDataSeeder {
  static final _random = Random();
  static const _uuid = Uuid();

  static Future<void> seedAll(WidgetRef ref) async {
    final appDb = getIt<AppDatabase>();
    final attDb = ref.read(attendanceDatabaseProvider);

    // 1. مسح البيانات القديمة
    await _clearDatabases(appDb, attDb);

    // 2. إدراج بيانات الجدول
    await appDb.transaction(() async {
      await _seedCoreDataAppDb(appDb);
    });

    // 3. إدراج بيانات الحضور
    await attDb.transaction(() async {
      await _seedAttendanceDb(attDb);
    });
  }

  static Future<void> _clearDatabases(AppDatabase appDb, AttendanceDatabase attDb) async {
    // AppDb
    await appDb.delete(appDb.schoolsTable).go();
    await appDb.delete(appDb.schedulesTable).go();
    await appDb.delete(appDb.sessionsTable).go();
    await appDb.delete(appDb.classroomsTable).go();
    await appDb.delete(appDb.subjectsTable).go();
    await appDb.delete(appDb.teachersTable).go();

    // AttDb
    await attDb.delete(attDb.attRecords).go();
    await attDb.delete(attDb.attSessions).go();
    await attDb.delete(attDb.attSubjects).go();
    await attDb.delete(attDb.attStudents).go();
    await attDb.delete(attDb.attSections).go();
    await attDb.delete(attDb.attGrades).go();
  }

  static Future<void> _seedCoreDataAppDb(AppDatabase appDb) async {
    // 0. School (required for schedule generation)
    await appDb.into(appDb.schoolsTable).insertOnConflictUpdate(
      SchoolsTableCompanion.insert(
        id: 'school_default',
        name: 'مدرسة النموذجية',
        address: 'المملكة العربية السعودية',
        phone: '0112345678',
        email: 'school@example.com',
        dailySessions: 6,
        workDays: [WorkDay.sunday, WorkDay.monday, WorkDay.tuesday, WorkDay.wednesday, WorkDay.thursday],
        firstSessionTime: 8 * 60, // 8:00 ص بالدقائق منذ منتصف الليل
        sessionDuration: 45,
        academicYear: '2025-2026',
      ),
    );

    // 1. Subjects
    final subjects = [
      ('القرآن الكريم', 4),
      ('اللغة العربية', 5),
      ('الرياضيات', 5),
      ('العلوم', 4),
      ('اللغة الإنجليزية', 3),
      ('التاريخ', 2),
      ('التربية البدنية', 2),
      ('الحاسب الآلي', 2),
    ];

    List<String> subjectIds = [];
    for (int i = 0; i < subjects.length; i++) {
      final id = _uuid.v4();
      subjectIds.add(id);
      await appDb.into(appDb.subjectsTable).insert(
        SubjectsTableCompanion.insert(
          id: id,
          name: subjects[i].$1,
          code: Value('SUBJ-$i'),
          priority: SubjectPriority.medium,
          weeklyHours: Value(subjects[i].$2),
          color: 0xFF1976D2 + (i * 10000), // ألوان عشوائية
          qualifiedTeacherIds: const [],
        ),
      );
    }

    // 2. Teachers
    final teacherNames = [
      'أحمد محمد', 'عبدالله صالح', 'خالد علي', 'عمر سعيد', 'فهد سعد',
      'ياسر عبدالرحمن', 'محمد إبراهيم', 'سالم طارق', 'ماجد يوسف', 'وليد سامي'
    ];

    List<String> teacherIds = [];
    for (int i = 0; i < teacherNames.length; i++) {
      final id = _uuid.v4();
      teacherIds.add(id);
      
      // ربط المعلم بمادتين عشوائياً
      final subj1 = subjectIds[_random.nextInt(subjectIds.length)];
      final subj2 = subjectIds[_random.nextInt(subjectIds.length)];

      await appDb.into(appDb.teachersTable).insert(
        TeachersTableCompanion.insert(
          id: id,
          fullName: teacherNames[i],
          specialization: 'عام',
          phone: '05${_random.nextInt(90000000) + 10000000}',
          maxWeeklyHours: 24,
          maxDailyHours: 6,
          type: TeacherType.primary,
          subjectIds: [subj1, subj2],
          classIds: const [],
          workDays: const Value([WorkDay.sunday, WorkDay.monday, WorkDay.tuesday, WorkDay.wednesday, WorkDay.thursday]),
          unavailablePeriods: const {},
        ),
      );
    }

    // 3. Classrooms
    final classLevels = ['الأول', 'الثاني', 'الثالث'];
    final sections = ['أ', 'ب'];
    
    for (int i = 0; i < classLevels.length; i++) {
      for (int j = 0; j < sections.length; j++) {
        await appDb.into(appDb.classroomsTable).insert(
          ClassroomsTableCompanion.insert(
            id: _uuid.v4(),
            name: 'الصف ${classLevels[i]}',
            section: sections[j],
            studentCount: 15,
            roomNumber: '${i + 1}0${j + 1}',
            level: ClassLevel.primary,
            subjectIds: Value(subjectIds),
          ),
        );
      }
    }
  }

  static Future<void> _seedAttendanceDb(AttendanceDatabase attDb) async {
    final stages = await attDb.select(attDb.attStages).get();
    int stageId;
    String stageName;
    if (stages.isEmpty) {
      stageId = await attDb.into(attDb.attStages).insert(
        AttStagesCompanion.insert(name: 'الابتدائية'),
      );
      stageName = 'الابتدائية';
    } else {
      stageId = stages.first.id;
      stageName = stages.first.name;
    }

    final classLevels = ['الأول', 'الثاني', 'الثالث'];
    final sections = ['أ', 'ب'];
    
    final firstNames = ['أحمد', 'محمد', 'علي', 'عمر', 'سعد', 'ياسر', 'خالد', 'عبدالرحمن', 'إبراهيم', 'سالم', 'فيصل', 'سلطان'];
    final lastNames = ['الزهراني', 'الغامدي', 'القحطاني', 'الشهراني', 'الدوسري', 'العنزي', 'المطيري', 'العتيبي', 'الشمري', 'الجهني'];

    int studentCounter = 1;

    for (int i = 0; i < classLevels.length; i++) {
      final gradeId = await attDb.into(attDb.attGrades).insert(
        AttGradesCompanion.insert(
          name: 'الصف ${classLevels[i]}',
          stageId: stageId,
        ),
      );

      final subjectNames = ['القرآن الكريم', 'اللغة العربية', 'الرياضيات', 'العلوم', 'اللغة الإنجليزية'];
      List<int> attSubjIds = [];
      for (final sName in subjectNames) {
        final sid = await attDb.into(attDb.attSubjects).insert(
          AttSubjectsCompanion.insert(name: sName, gradeId: gradeId),
        );
        attSubjIds.add(sid);
      }

      for (int j = 0; j < sections.length; j++) {
        final sectionId = await attDb.into(attDb.attSections).insert(
          AttSectionsCompanion.insert(
            name: sections[j],
            gradeId: gradeId,
          ),
        );

        List<int> studentIds = [];
        for (int s = 0; s < 15; s++) {
          final fName = firstNames[_random.nextInt(firstNames.length)];
          final lName = lastNames[_random.nextInt(lastNames.length)];
          
          final barcode = '2026${gradeId}${sectionId}${studentCounter.toString().padLeft(3, '0')}';
          studentCounter++;

          final stuId = await attDb.into(attDb.attStudents).insert(
            AttStudentsCompanion.insert(
              name: '$fName $lName',
              stage: stageName,
              grade: 'الصف ${classLevels[i]}',
              section: sections[j],
              barcode: barcode,
            ),
          );
          studentIds.add(stuId);
        }

        // توليد تاريخ الحضور لـ 30 يوماً
        final now = DateTime.now();
        for (int d = 0; d < 30; d++) {
          final date = now.subtract(Duration(days: d));
          if (date.weekday == DateTime.friday || date.weekday == DateTime.saturday) continue;

          for (final sid in attSubjIds) {
            if (_random.nextDouble() > 0.2) { // 80% احتمال حدوث الحصة
              final sessionId = await attDb.into(attDb.attSessions).insert(
                AttSessionsCompanion.insert(
                  date: DateTime(date.year, date.month, date.day),
                  gradeId: gradeId,
                  sectionId: sectionId,
                  subjectId: sid,
                  periodNumber: _random.nextInt(6) + 1,
                  status: const Value('closed'),
                  closedAt: Value(DateTime.now()),
                ),
              );

              for (int s = 0; s < studentIds.length; s++) {
                final stuId = studentIds[s];
                String status = 'present';
                
                // حالات الحافة
                if (s == 0) { // دائماً غائب
                  status = 'absent';
                } else if (s == 1) { // دائماً متأخر
                  status = 'late';
                } else if (s == 2) { // دائماً حاضر
                  status = 'present';
                } else {
                  final r = _random.nextDouble();
                  if (r < 0.85) status = 'present';
                  else if (r < 0.90) status = 'late';
                  else if (r < 0.95) status = 'absent';
                  else status = 'excused';
                }

                await attDb.into(attDb.attRecords).insert(
                  AttRecordsCompanion.insert(
                    studentId: stuId,
                    sessionId: sessionId,
                    status: status,
                  ),
                );
              }
            }
          }
        }
      }
    }
  }
}
