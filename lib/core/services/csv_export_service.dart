import 'package:school_schedule_app/core/navigation/app_router.dart';
import 'package:school_schedule_app/core/utils/l10n_extension.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:school_schedule_app/core/database/attendance_database.dart';

// ============================================================================
// CsvExportService — Exports attendance data to CSV bytes
// ============================================================================

class CsvExportService {
  /// Generates a UTF-8 BOM CSV for attendance data and returns raw bytes.
  /// The BOM prefix ensures Arabic text renders correctly when opened in Excel.
  static Future<Uint8List> generateAttendanceCSV(List<AttStudent> students) async {
    final buf = StringBuffer();
    // Header
    buf.writeln(AppNavigator.navigatorKey.currentContext!.l10n.phone);
    for (var i = 0; i < students.length; i++) {
      final s = students[i];
      buf.writeln('${i + 1},"${s.name}","${s.stage}","${s.grade}","${s.section}","${s.barcode}","${s.isActive ? AppNavigator.navigatorKey.currentContext!.l10n.address : AppNavigator.navigatorKey.currentContext!.l10n.description}"');
    }
    // UTF-8 BOM + content
    final bom = [0xEF, 0xBB, 0xBF];
    final body = utf8.encode(buf.toString());
    return Uint8List.fromList([...bom, ...body]);
  }

  /// Generates a full attendance session CSV — date, session, student, status.
  static Future<Uint8List> generateSessionCSV({
    required AttendanceDatabase db,
    required DateTime date,
  }) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    // Fetch all sessions then filter in Dart (avoids Drift version-specific DateTime extension issues)
    final allSessions = await db.select(db.attSessions).get();
    final sessions = allSessions
        .where((s) => !s.date.isBefore(startOfDay) && s.date.isBefore(endOfDay))
        .toList();

    final grades = await db.select(db.attGrades).get();
    final sections = await db.select(db.attSections).get();
    final subjects = await db.select(db.attSubjects).get();
    final students = await db.select(db.attStudents).get();

    final gradeMap = {for (var g in grades) g.id: g.name};
    final sectionMap = {for (var s in sections) s.id: s.name};
    final subjectMap = {for (var s in subjects) s.id: s.name};
    final studentMap = {for (var s in students) s.id: s};

    final buf = StringBuffer();
    buf.writeln(AppNavigator.navigatorKey.currentContext!.l10n.notes);

    for (final session in sessions) {
      final records = await (db.select(db.attRecords)
            ..where((r) => r.sessionId.equals(session.id)))
          .get();
      for (final r in records) {
        final student = studentMap[r.studentId];
        if (student == null) continue;
        final statusLabel = switch (r.status) {
          'present' => AppNavigator.navigatorKey.currentContext!.l10n.present,
          'absent' => AppNavigator.navigatorKey.currentContext!.l10n.absent,
          'late' => AppNavigator.navigatorKey.currentContext!.l10n.late,
          'excused' => AppNavigator.navigatorKey.currentContext!.l10n.excused,
          _ => r.status,
        };
        buf.writeln(
          '"${_fmtDate(session.date)}",'
          '"${gradeMap[session.gradeId] ?? '—'}",'
          '"${sectionMap[session.sectionId] ?? '—'}",'
          '"${subjectMap[session.subjectId] ?? '—'}",'
          '${session.periodNumber},'
          '"${student.name}",'
          '"$statusLabel"',
        );
      }
    }

    final bom = [0xEF, 0xBB, 0xBF];
    final body = utf8.encode(buf.toString());
    return Uint8List.fromList([...bom, ...body]);
  }

  /// Saves CSV bytes to the reports directory and returns the file path.
  static Future<String?> saveCSV(Uint8List bytes, String filename) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File(p.join(dir.path, 'reports', filename));
      await file.parent.create(recursive: true);
      await file.writeAsBytes(bytes);
      return file.path;
    } catch (e) {
      debugPrint('CsvExportService.saveCSV error: $e');
      return null;
    }
  }

  static String _fmtDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
