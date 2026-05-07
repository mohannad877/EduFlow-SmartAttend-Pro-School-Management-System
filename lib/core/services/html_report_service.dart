import 'package:school_schedule_app/core/navigation/app_router.dart';
import 'package:school_schedule_app/core/utils/l10n_extension.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:open_file/open_file.dart';
import 'package:school_schedule_app/core/database/attendance_database.dart';

// ============================================================================
// HtmlReportService — Generates self-contained HTML attendance reports
// ============================================================================

class HtmlReportService {
  /// Generates a standalone Arabic HTML report for the student list.
  static Future<String> generateAttendanceHTML(List<AttStudent> students) async {
    final rows = students.asMap().entries.map((e) {
      final i = e.key + 1;
      final s = e.value;
      final statusBadge = s.isActive
          ? '<span class="badge active">نشط</span>'
          : '<span class="badge inactive">غير نشط</span>';
      return '''
        <tr>
          <td>$i</td>
          <td>${s.name}</td>
          <td>${s.stage}</td>
          <td>${s.grade}</td>
          <td>${s.section}</td>
          <td>${s.barcode}</td>
          <td>$statusBadge</td>
        </tr>''';
    }).join('\n');

    final now = DateTime.now();
    final dateStr = '${now.day}/${now.month}/${now.year}';

    return '''<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>تقرير الطلاب</title>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body { font-family: 'Cairo', Arial, sans-serif; background: #f5f7fa; color: #333; direction: rtl; }
    .header { background: linear-gradient(135deg, #1565C0, #1E88E5); color: white; padding: 24px 32px; }
    .header h1 { font-size: 24px; margin-bottom: 4px; }
    .header p { opacity: 0.8; font-size: 14px; }
    .container { padding: 24px; }
    .stats { display: flex; gap: 16px; margin-bottom: 24px; flex-wrap: wrap; }
    .stat-card { background: white; border-radius: 12px; padding: 16px 24px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); flex: 1; min-width: 120px; }
    .stat-card .value { font-size: 28px; font-weight: bold; color: #1565C0; }
    .stat-card .label { font-size: 13px; color: #888; margin-top: 4px; }
    table { width: 100%; border-collapse: collapse; background: white; border-radius: 12px; overflow: hidden; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
    th { background: #1565C0; color: white; padding: 12px 16px; font-size: 14px; text-align: right; }
    td { padding: 10px 16px; font-size: 13px; border-bottom: 1px solid #f0f0f0; }
    tr:last-child td { border-bottom: none; }
    tr:nth-child(even) { background: #f8faff; }
    .badge { padding: 4px 12px; border-radius: 20px; font-size: 12px; font-weight: bold; }
    .badge.active { background: #e8f5e9; color: #2e7d32; }
    .badge.inactive { background: #ffebee; color: #c62828; }
    .footer { text-align: center; padding: 24px; color: #aaa; font-size: 12px; }
    @media print { body { background: white; } .container { padding: 0; } }
  </style>
</head>
<body>
  <div class="header">
    <h1>📋 تقرير قائمة الطلاب</h1>
    <p>تاريخ التقرير: $dateStr — إجمالي الطلاب: ${students.length}</p>
  </div>
  <div class="container">
    <div class="stats">
      <div class="stat-card">
        <div class="value">${students.length}</div>
        <div class="label">إجمالي الطلاب</div>
      </div>
      <div class="stat-card">
        <div class="value">${students.where((s) => s.isActive).length}</div>
        <div class="label">طلاب نشطون</div>
      </div>
      <div class="stat-card">
        <div class="value">${students.where((s) => !s.isActive).length}</div>
        <div class="label">طلاب غير نشطين</div>
      </div>
    </div>
    <table>
      <thead>
        <tr>
          <th>#</th>
          <th>الاسم</th>
          <th>المرحلة</th>
          <th>الصف</th>
          <th>الشعبة</th>
          <th>الباركود</th>
          <th>الحالة</th>
        </tr>
      </thead>
      <tbody>
        $rows
      </tbody>
    </table>
  </div>
  <div class="footer">تم إنشاء هذا التقرير بواسطة نظام إدارة المدارس — $dateStr</div>
</body>
</html>''';
  }

  /// Generates a daily attendance HTML report.
  static Future<String> generateDailyAttendanceHTML({
    required AttendanceDatabase db,
    required DateTime date,
    String? schoolName,
  }) async {
    final resolvedSchoolName = schoolName ?? AppNavigator.navigatorKey.currentContext?.l10n.from ?? 'My School';
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

    final allRows = StringBuffer();
    int totalPresent = 0, totalAbsent = 0, totalLate = 0, totalExcused = 0;

    for (final session in sessions) {
      final records = await (db.select(db.attRecords)
            ..where((r) => r.sessionId.equals(session.id)))
          .get();
      for (final r in records) {
        final student = studentMap[r.studentId];
        if (student == null) continue;

        final (label, cssClass) = switch (r.status) {
          'present' => (AppNavigator.navigatorKey.currentContext?.l10n.present ?? 'Present', 'present'),
          'absent' => (AppNavigator.navigatorKey.currentContext?.l10n.absent ?? 'Absent', 'absent'),
          'late' => (AppNavigator.navigatorKey.currentContext?.l10n.late ?? 'Late', 'late'),
          'excused' => (AppNavigator.navigatorKey.currentContext?.l10n.excused ?? 'Excused', 'excused'),
          _ => (r.status, 'unknown'),
        };
        if (r.status == 'present') totalPresent++;
        if (r.status == 'absent') totalAbsent++;
        if (r.status == 'late') totalLate++;
        if (r.status == 'excused') totalExcused++;

        allRows.write('''<tr>
          <td>${student.name}</td>
          <td>${gradeMap[session.gradeId] ?? '—'}</td>
          <td>${sectionMap[session.sectionId] ?? '—'}</td>
          <td>${subjectMap[session.subjectId] ?? '—'}</td>
          <td>${session.periodNumber}</td>
          <td><span class="status $cssClass">$label</span></td>
        </tr>''');
      }
    }

    final dateStr = '${date.day}/${date.month}/${date.year}';

    return '''<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
  <meta charset="UTF-8">
  <title>تقرير الحضور اليومي</title>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body { font-family: Arial, sans-serif; background: #f5f7fa; direction: rtl; }
    .header { background: linear-gradient(135deg, #1565C0, #42A5F5); color: white; padding: 24px; }
    .header h1 { font-size: 22px; }
    .header p { opacity: 0.85; font-size: 13px; margin-top: 4px; }
    .container { padding: 20px; }
    .stats { display: flex; gap: 12px; margin-bottom: 20px; }
    .stat { background: white; border-radius: 10px; padding: 14px 20px; box-shadow: 0 2px 6px rgba(0,0,0,0.08); flex: 1; text-align: center; }
    .stat .num { font-size: 26px; font-weight: bold; }
    .stat .lbl { font-size: 12px; color: #888; }
    .present .num { color: #2e7d32; }
    .absent .num { color: #c62828; }
    .late .num { color: #e65100; }
    .excused .num { color: #1565C0; }
    table { width: 100%; border-collapse: collapse; background: white; border-radius: 10px; overflow: hidden; box-shadow: 0 2px 6px rgba(0,0,0,0.08); }
    th { background: #1565C0; color: white; padding: 10px 14px; font-size: 13px; text-align: right; }
    td { padding: 9px 14px; font-size: 12px; border-bottom: 1px solid #f0f0f0; }
    .status { padding: 3px 10px; border-radius: 12px; font-size: 11px; font-weight: bold; }
    .status.present { background: #e8f5e9; color: #2e7d32; }
    .status.absent { background: #ffebee; color: #c62828; }
    .status.late { background: #fff3e0; color: #e65100; }
    .status.excused { background: #e3f2fd; color: #1565C0; }
  </style>
</head>
<body>
  <div class="header">
    <h1>تقرير الحضور اليومي — $resolvedSchoolName</h1>
    <p>تاريخ: $dateStr</p>
  </div>
  <div class="container">
    <div class="stats">
      <div class="stat present"><div class="num">$totalPresent</div><div class="lbl">حاضر</div></div>
      <div class="stat absent"><div class="num">$totalAbsent</div><div class="lbl">غائب</div></div>
      <div class="stat late"><div class="num">$totalLate</div><div class="lbl">متأخر</div></div>
      <div class="stat excused"><div class="num">$totalExcused</div><div class="lbl">بعذر</div></div>
    </div>
    <table>
      <thead><tr><th>الطالب</th><th>الصف</th><th>الشعبة</th><th>المادة</th><th>الحصة</th><th>الحضور</th></tr></thead>
      <tbody>${allRows.toString()}</tbody>
    </table>
  </div>
</body>
</html>''';
  }

  /// Save HTML content to the reports directory and optionally open it.
  static Future<String?> saveAndOpen(String htmlContent, String filename, {bool open = true}) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File(p.join(dir.path, 'reports', '$filename.html'));
      await file.parent.create(recursive: true);
      await file.writeAsString(htmlContent, encoding: utf8);
      if (open) await OpenFile.open(file.path);
      return file.path;
    } catch (e) {
      debugPrint('HtmlReportService.saveAndOpen error: $e');
      return null;
    }
  }

  /// Returns raw UTF-8 bytes (for sharing via share_plus).
  static Uint8List toBytes(String html) => Uint8List.fromList(utf8.encode(html));
}
