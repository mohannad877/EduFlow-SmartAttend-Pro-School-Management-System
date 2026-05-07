import 'package:school_schedule_app/core/navigation/app_router.dart';
import 'package:school_schedule_app/core/utils/l10n_extension.dart';
import 'package:school_schedule_app/core/theme/app_spacing.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:drift/drift.dart';
import 'package:school_schedule_app/core/database/attendance_database.dart';

// ============================================================================
// AttendancePdfService — Generates PDF reports from attendance data
// ============================================================================

class AttendancePdfService {
  // ── Daily Report ──────────────────────────────────────────────────────────

  static Future<String?> generateDailyReport({
    required AttendanceDatabase db,
    required DateTime date,
    required String schoolName,
    bool openAfter = true,
  }) async {
    try {
      final arabicFont = await PdfGoogleFonts.cairoRegular();
      final arabicFontBold = await PdfGoogleFonts.cairoBold();

      // Load data
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final sessions = await (db.select(db.attSessions)
            ..where((s) => s.date.isBiggerOrEqualValue(startOfDay) &
                          s.date.isSmallerThanValue(endOfDay)))
          .get();

      final grades = await db.select(db.attGrades).get();
      final sections = await db.select(db.attSections).get();
      final subjects = await db.select(db.attSubjects).get();
      final students = await db.select(db.attStudents).get();

      final gradeMap = {for (var g in grades) g.id: g.name};
      final sectionMap = {for (var s in sections) s.id: s.name};
      final subjectMap = {for (var s in subjects) s.id: s.name};

      // Build attendance data
      final rows = <_AttendanceRow>[];
      for (final session in sessions) {
        final records = await (db.select(db.attRecords)
              ..where((r) => r.sessionId.equals(session.id)))
            .get();

        for (final record in records) {
          final student =
              students.firstWhere((s) => s.id == record.studentId, orElse: () => throw StateError('Student not found'));
          rows.add(_AttendanceRow(
            studentName: student.name,
            grade: gradeMap[session.gradeId] ?? '—',
            section: sectionMap[session.sectionId] ?? '—',
            subject: subjectMap[session.subjectId] ?? '—',
            period: session.periodNumber,
            status: record.status,
          ));
        }
      }

      final pdf = pw.Document();
      final dateStr = DateFormat('yyyy-MM-dd').format(date);
      final dateArabic = _formatArabicDate(date);

      pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(AppSpacing.lg),
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
        header: (ctx) => _buildPdfHeader(
          schoolName: schoolName,
          title: AppNavigator.navigatorKey.currentContext!.l10n.dailyAttendanceReport,
          subtitle: dateArabic,
          boldFont: arabicFontBold,
          regularFont: arabicFont,
        ),
        build: (ctx) {
          // Summary row
          final present = rows.where((r) => r.status == 'present').length;
          final absent = rows.where((r) => r.status == 'absent').length;
          final late = rows.where((r) => r.status == 'late').length;
          final excused = rows.where((r) => r.status == 'excused').length;

          return [
            // Stats row
            pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 16),
              decoration: pw.BoxDecoration(
                color: PdfColors.blue50,
                borderRadius: pw.BorderRadius.circular(8),
                border: pw.Border.all(color: PdfColors.blue200),
              ),
              child: pw.Padding(
                padding: const pw.EdgeInsets.all(AppSpacing.md),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                  children: [
                    _statCell(AppNavigator.navigatorKey.currentContext!.l10n.present, '$present', PdfColors.green700, arabicFontBold),
                    _statCell(AppNavigator.navigatorKey.currentContext!.l10n.absent, '$absent', PdfColors.red700, arabicFontBold),
                    _statCell(AppNavigator.navigatorKey.currentContext!.l10n.late, '$late', PdfColors.orange700, arabicFontBold),
                    _statCell(AppNavigator.navigatorKey.currentContext!.l10n.excused, '$excused', PdfColors.blue700, arabicFontBold),
                    _statCell(AppNavigator.navigatorKey.currentContext!.l10n.total, '${rows.length}', PdfColors.grey700, arabicFontBold),
                  ],
                ),
              ),
            ),

            if (rows.isEmpty)
              pw.Center(
                child: pw.Text(AppNavigator.navigatorKey.currentContext!.l10n.status,
                    style: pw.TextStyle(font: arabicFont, fontSize: 14, color: PdfColors.grey500),
                    textDirection: pw.TextDirection.rtl),
              )
            else
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.8),
                columnWidths: {
                  0: const pw.FlexColumnWidth(3),
                  1: const pw.FlexColumnWidth(2),
                  2: const pw.FlexColumnWidth(2),
                  3: const pw.FlexColumnWidth(2),
                  4: const pw.FlexColumnWidth(1),
                  5: const pw.FlexColumnWidth(1.5),
                },
                children: [
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColors.blue700),
                    children: [AppNavigator.navigatorKey.currentContext!.l10n.studentName, AppNavigator.navigatorKey.currentContext!.l10n.grade, AppNavigator.navigatorKey.currentContext!.l10n.section, AppNavigator.navigatorKey.currentContext!.l10n.section, AppNavigator.navigatorKey.currentContext!.l10n.session, AppNavigator.navigatorKey.currentContext!.l10n.session]
                        .map((h) => _headerCell(h, arabicFontBold))
                        .toList(),
                  ),
                  ...rows.asMap().entries.map((e) {
                    final row = e.value;
                    final isOdd = e.key.isOdd;
                    return pw.TableRow(
                      decoration:
                          pw.BoxDecoration(color: isOdd ? PdfColors.grey50 : PdfColors.white),
                      children: [
                        _dataCell(row.studentName, arabicFont),
                        _dataCell(row.grade, arabicFont),
                        _dataCell(row.section, arabicFont),
                        _dataCell(row.subject, arabicFont),
                        _dataCell('${row.period}', arabicFont, centered: true),
                        _statusCell(row.status, arabicFontBold),
                      ],
                    );
                  }),
                ],
              ),
          ];
        },
      ));

      final outputPath = await _savePdf(pdf, 'daily_report_$dateStr');
      if (openAfter && outputPath != null) await OpenFile.open(outputPath);
      return outputPath;
    } catch (e, stack) {
      debugPrint('PDF daily report error: $e\n$stack');
      return null;
    }
  }

  // ── Monthly Report ─────────────────────────────────────────────────────────

  static Future<String?> generateMonthlyReport({
    required AttendanceDatabase db,
    required int year,
    required int month,
    required String schoolName,
    bool openAfter = true,
  }) async {
    try {
      final arabicFont = await PdfGoogleFonts.cairoRegular();
      final arabicFontBold = await PdfGoogleFonts.cairoBold();

      final start = DateTime(year, month, 1);
      final end = DateTime(year, month + 1, 1);

      final sessions = await (db.select(db.attSessions)
            ..where((s) => s.date.isBiggerOrEqualValue(start) &
                          s.date.isSmallerThanValue(end)))
          .get();

      final students = await db.select(db.attStudents).get();

      // Aggregate attendance per student
      final studentStats = <int, _StudentStats>{};
      for (final session in sessions) {
        final records = await (db.select(db.attRecords)
              ..where((r) => r.sessionId.equals(session.id)))
            .get();
        for (final record in records) {
          final stats = studentStats.putIfAbsent(record.studentId, () => _StudentStats());
          stats.add(record.status);
        }
      }

      final rows = students
          .where((s) => studentStats.containsKey(s.id))
          .map((s) => MapEntry(s, studentStats[s.id]!))
          .toList()
        ..sort((a, b) => a.key.name.compareTo(b.key.name));

      final months = [AppNavigator.navigatorKey.currentContext!.l10n.january, AppNavigator.navigatorKey.currentContext!.l10n.february, AppNavigator.navigatorKey.currentContext!.l10n.march, AppNavigator.navigatorKey.currentContext!.l10n.april, AppNavigator.navigatorKey.currentContext!.l10n.may, AppNavigator.navigatorKey.currentContext!.l10n.june, AppNavigator.navigatorKey.currentContext!.l10n.july, AppNavigator.navigatorKey.currentContext!.l10n.august, AppNavigator.navigatorKey.currentContext!.l10n.september, AppNavigator.navigatorKey.currentContext!.l10n.october, AppNavigator.navigatorKey.currentContext!.l10n.november, AppNavigator.navigatorKey.currentContext!.l10n.december];

      final pdf = pw.Document();
      pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(AppSpacing.lg),
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
        header: (ctx) => _buildPdfHeader(
          schoolName: schoolName,
          title: AppNavigator.navigatorKey.currentContext!.l10n.monthlyAttendanceReport,
          subtitle: '${months[month - 1]} $year',
          boldFont: arabicFontBold,
          regularFont: arabicFont,
        ),
        build: (ctx) => [
          if (rows.isEmpty)
            pw.Center(
              child: pw.Text(AppNavigator.navigatorKey.currentContext!.l10n.noDataFound,
                  style: pw.TextStyle(font: arabicFont, color: PdfColors.grey500),
                  textDirection: pw.TextDirection.rtl),
            )
          else
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.8),
              columnWidths: {
                0: const pw.FlexColumnWidth(3),
                1: const pw.FlexColumnWidth(2),
                2: const pw.FlexColumnWidth(1.5),
                3: const pw.FlexColumnWidth(1.5),
                4: const pw.FlexColumnWidth(1.5),
                5: const pw.FlexColumnWidth(1.5),
                6: const pw.FlexColumnWidth(2),
              },
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.blue700),
                  children: [AppNavigator.navigatorKey.currentContext!.l10n.attendanceLabel, AppNavigator.navigatorKey.currentContext!.l10n.present, AppNavigator.navigatorKey.currentContext!.l10n.present, AppNavigator.navigatorKey.currentContext!.l10n.absent, AppNavigator.navigatorKey.currentContext!.l10n.late, AppNavigator.navigatorKey.currentContext!.l10n.excused, AppNavigator.navigatorKey.currentContext!.l10n.attendanceRate]
                      .map((h) => _headerCell(h, arabicFontBold))
                      .toList(),
                ),
                ...rows.asMap().entries.map((e) {
                  final student = e.value.key;
                  final stats = e.value.value;
                  final rate = stats.attendanceRate;
                  final rateColor = rate >= 0.75 ? PdfColors.green700 : rate >= 0.5 ? PdfColors.orange700 : PdfColors.red700;
                  return pw.TableRow(
                    decoration: pw.BoxDecoration(color: e.key.isOdd ? PdfColors.grey50 : PdfColors.white),
                    children: [
                      _dataCell(student.name, arabicFont),
                      _dataCell('${student.grade} / ${student.section}', arabicFont),
                      _dataCell('${stats.present}', arabicFont, centered: true),
                      _dataCell('${stats.absent}', arabicFont, centered: true),
                      _dataCell('${stats.late}', arabicFont, centered: true),
                      _dataCell('${stats.excused}', arabicFont, centered: true),
                      _colorDataCell('${(rate * 100).toStringAsFixed(1)}%', arabicFontBold, rateColor),
                    ],
                  );
                }),
              ],
            ),
        ],
      ));

      final outputPath = await _savePdf(pdf, 'monthly_report_${year}_$month');
      if (openAfter && outputPath != null) await OpenFile.open(outputPath);
      return outputPath;
    } catch (e, stack) {
      debugPrint('PDF monthly report error: $e\n$stack');
      return null;
    }
  }

  // ── Shared Helpers ─────────────────────────────────────────────────────────

  static pw.Widget _buildPdfHeader({
    required String schoolName,
    required String title,
    required String subtitle,
    required pw.Font boldFont,
    required pw.Font regularFont,
  }) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 16),
      decoration: pw.BoxDecoration(
        gradient: const pw.LinearGradient(colors: [PdfColors.blue800, PdfColors.blue500]),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      padding: const pw.EdgeInsets.all(AppSpacing.md),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          pw.Text(schoolName, textDirection: pw.TextDirection.rtl,
              style: pw.TextStyle(font: boldFont, fontSize: 18, color: PdfColors.white)),
          pw.SizedBox(height: 4),
          pw.Text(title, textDirection: pw.TextDirection.rtl,
              style: pw.TextStyle(font: boldFont, fontSize: 14, color: const PdfColor(1, 1, 1, 0.85))),
          pw.SizedBox(height: 2),
          pw.Text(subtitle, textDirection: pw.TextDirection.rtl,
              style: pw.TextStyle(font: regularFont, fontSize: 11, color: const PdfColor(1, 1, 1, 0.7))),
        ],
      ),
    );
  }

  static pw.Widget _headerCell(String text, pw.Font font) => pw.Container(
    padding: const pw.EdgeInsets.all(AppSpacing.sm),
    alignment: pw.Alignment.center,
    child: pw.Text(text,
        textDirection: pw.TextDirection.rtl,
        style: pw.TextStyle(font: font, fontSize: 9, color: PdfColors.white),
        textAlign: pw.TextAlign.center),
  );

  static pw.Widget _dataCell(String text, pw.Font font, {bool centered = false}) => pw.Container(
    padding: const pw.EdgeInsets.all(AppSpacing.sm),
    alignment: centered ? pw.Alignment.center : pw.AlignmentDirectional.centerEnd,
    child: pw.Text(text, textDirection: pw.TextDirection.rtl,
        style: pw.TextStyle(font: font, fontSize: 8), textAlign: centered ? pw.TextAlign.center : pw.TextAlign.right),
  );

  static pw.Widget _colorDataCell(String text, pw.Font font, PdfColor color) => pw.Container(
    padding: const pw.EdgeInsets.all(AppSpacing.sm),
    alignment: pw.Alignment.center,
    child: pw.Text(text, style: pw.TextStyle(font: font, fontSize: 9, color: color), textAlign: pw.TextAlign.center),
  );

  static pw.Widget _statusCell(String status, pw.Font font) {
    final (text, color) = switch (status) {
      'present' => (AppNavigator.navigatorKey.currentContext!.l10n.present, PdfColors.green700),
      'absent' => (AppNavigator.navigatorKey.currentContext!.l10n.absent, PdfColors.red700),
      'late' => (AppNavigator.navigatorKey.currentContext!.l10n.late, PdfColors.orange700),
      'excused' => (AppNavigator.navigatorKey.currentContext!.l10n.excused, PdfColors.blue700),
      _ => (status, PdfColors.grey),
    };
    return pw.Container(
      padding: const pw.EdgeInsets.all(AppSpacing.sm),
      alignment: pw.Alignment.center,
      child: pw.Text(text, style: pw.TextStyle(font: font, fontSize: 8, color: color),
          textDirection: pw.TextDirection.rtl),
    );
  }

  static pw.Widget _statCell(String label, String value, PdfColor color, pw.Font font) =>
      pw.Column(children: [
        pw.Text(value, style: pw.TextStyle(font: font, fontSize: 16, color: color)),
        pw.SizedBox(height: 2),
        pw.Text(label, style: pw.TextStyle(font: font, fontSize: 9, color: PdfColors.grey600),
            textDirection: pw.TextDirection.rtl),
      ]);

  static Future<String?> _savePdf(pw.Document pdf, String name) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File(p.join(dir.path, 'reports', '$name.pdf'));
      await file.parent.create(recursive: true);
      await file.writeAsBytes(await pdf.save());
      return file.path;
    } catch (e) {
      debugPrint('Error saving PDF: $e');
      return null;
    }
  }

  static String _formatArabicDate(DateTime dt) {
    final months = [AppNavigator.navigatorKey.currentContext!.l10n.january, AppNavigator.navigatorKey.currentContext!.l10n.february, AppNavigator.navigatorKey.currentContext!.l10n.march, AppNavigator.navigatorKey.currentContext!.l10n.april, AppNavigator.navigatorKey.currentContext!.l10n.may, AppNavigator.navigatorKey.currentContext!.l10n.june, AppNavigator.navigatorKey.currentContext!.l10n.july, AppNavigator.navigatorKey.currentContext!.l10n.august, AppNavigator.navigatorKey.currentContext!.l10n.september, AppNavigator.navigatorKey.currentContext!.l10n.october, AppNavigator.navigatorKey.currentContext!.l10n.november, AppNavigator.navigatorKey.currentContext!.l10n.december];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }

  /// Print PDF using system print dialog
  static Future<void> printReport(pw.Document pdf, String name) async {
    await Printing.layoutPdf(
      onLayout: (_) async => pdf.save(),
      name: name,
    );
  }

  /// Advanced report that accepts a dynamic filter map (from ReportFilterDialog).
  /// Falls back to a full daily report when no date range is provided.
  static Future<String?> generateAdvancedReport(
    Map<String, dynamic> data,
    dynamic filter, {
    bool openAfter = true,
  }) async {
    try {
      // Extract filter properties safely
      final dynamic dateRange = filter?.dateRange;
      var start = DateTime.now().subtract(const Duration(days: 30));
      var end = DateTime.now();

      if (dateRange != null) {
        start = dateRange.start as DateTime;
        end = dateRange.end as DateTime;
      }

      final arabicFont = await PdfGoogleFonts.cairoRegular();
      final arabicFontBold = await PdfGoogleFonts.cairoBold();

      final students = data['students'] as List? ?? [];
      final attendance = data['attendance'] as List? ?? [];

      final pdf = pw.Document();
      pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(AppSpacing.lg),
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
        header: (ctx) => _buildPdfHeader(
          schoolName: AppNavigator.navigatorKey.currentContext!.l10n.schoolName,
          title: AppNavigator.navigatorKey.currentContext!.l10n.attendanceReport,
          subtitle: '${_formatArabicDate(start)} – ${_formatArabicDate(end)}',
          boldFont: arabicFontBold,
          regularFont: arabicFont,
        ),
        build: (ctx) => [
          if (students.isEmpty && attendance.isEmpty)
            pw.Center(
              child: pw.Text(
                AppNavigator.navigatorKey.currentContext!.l10n.reportDate,
                style: pw.TextStyle(font: arabicFont, fontSize: 14, color: PdfColors.grey500),
                textDirection: pw.TextDirection.rtl,
             ),
            )
          else
            pw.Text(
              AppNavigator.navigatorKey.currentContext!.l10n.save,
              style: pw.TextStyle(font: arabicFont),
              textDirection: pw.TextDirection.rtl,
           ),
        ],
      ));

      final stamp = '${start.year}${start.month.toString().padLeft(2, '0')}${start.day.toString().padLeft(2, '0')}';
      final outputPath = await _savePdf(pdf, 'advanced_report_$stamp');
      if (openAfter && outputPath != null) await OpenFile.open(outputPath);
      return outputPath;
    } catch (e, stack) {
      debugPrint('PDF advanced report error: $e\n$stack');
      return null;
    }
  }

  // ── Student Report ─────────────────────────────────────────────────────────

  static Future<void> printStudentsList({
    required List<AttStudent> students,
    required String schoolName,
  }) async {
    try {
      final arabicFont = await PdfGoogleFonts.cairoRegular();
      final arabicFontBold = await PdfGoogleFonts.cairoBold();

      final pdf = pw.Document();

      pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(AppSpacing.lg),
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
        header: (ctx) => _buildPdfHeader(
          schoolName: schoolName,
          title: AppNavigator.navigatorKey.currentContext!.l10n.total,
          subtitle: AppNavigator.navigatorKey.currentContext!.l10n.cancel,
          boldFont: arabicFontBold,
          regularFont: arabicFont,
        ),
        build: (ctx) => [
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.8),
            columnWidths: {
              0: const pw.FlexColumnWidth(3),
              1: const pw.FlexColumnWidth(1.5),
              2: const pw.FlexColumnWidth(1.5),
              3: const pw.FlexColumnWidth(1.5),
              4: const pw.FlexColumnWidth(2.5),
            },
            children: [
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.blue700),
                children: [AppNavigator.navigatorKey.currentContext!.l10n.attendanceLabel, AppNavigator.navigatorKey.currentContext!.l10n.date, AppNavigator.navigatorKey.currentContext!.l10n.grade, AppNavigator.navigatorKey.currentContext!.l10n.section, AppNavigator.navigatorKey.currentContext!.l10n.time]
                    .map((h) => _headerCell(h, arabicFontBold))
                    .toList(),
              ),
              ...students.asMap().entries.map((e) {
                final student = e.value;
                return pw.TableRow(
                  decoration: pw.BoxDecoration(color: e.key.isOdd ? PdfColors.grey50 : PdfColors.white),
                  children: [
                    _dataCell(student.name, arabicFont),
                    _dataCell(student.stage, arabicFont),
                    _dataCell(student.grade, arabicFont),
                    _dataCell(student.section, arabicFont),
                    _dataCell(student.barcode, arabicFont),
                  ],
                );
              }),
            ],
          ),
        ],
      ));

      await printReport(pdf, 'students_list');
    } catch (e, stack) {
      debugPrint('PDF print list error: $e\n$stack');
    }
  }

  // ── Student Report ─────────────────────────────────────────────────────────

  static Future<String?> generateStudentReport({
    required AttendanceDatabase db,
    required AttStudent student,
    required List<AttRecord> records,
    required String schoolName,
    bool openAfter = true,
  }) async {
    try {
      final arabicFont = await PdfGoogleFonts.cairoRegular();
      final arabicFontBold = await PdfGoogleFonts.cairoBold();

      final pdf = pw.Document();

      // Calculate stats
      final present = records.where((r) => r.status == 'present').length;
      final absent = records.where((r) => r.status == 'absent').length;
      final late = records.where((r) => r.status == 'late').length;
      final rate = records.isEmpty ? 0.0 : (present / records.length) * 100;

      pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(AppSpacing.lg),
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
        header: (ctx) => _buildPdfHeader(
          schoolName: schoolName,
          title: AppNavigator.navigatorKey.currentContext!.l10n.ok,
          subtitle: student.name,
          boldFont: arabicFontBold,
          regularFont: arabicFont,
        ),
        build: (ctx) => [
          // Basic Info
          pw.Container(
            padding: const pw.EdgeInsets.all(AppSpacing.md),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.blue200),
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                _infoItem(AppNavigator.navigatorKey.currentContext!.l10n.section, student.section, arabicFontBold, arabicFont),
                _infoItem(AppNavigator.navigatorKey.currentContext!.l10n.grade, student.grade, arabicFontBold, arabicFont),
                _infoItem(AppNavigator.navigatorKey.currentContext!.l10n.time, student.barcode, arabicFontBold, arabicFont),
              ],
            ),
          ),
          pw.SizedBox(height: 20),

          // Stats
          pw.Row(
            children: [
              _statBox(AppNavigator.navigatorKey.currentContext!.l10n.attendanceRate, '${rate.toStringAsFixed(1)}%', PdfColors.blue700, arabicFontBold),
              pw.SizedBox(width: 10),
              _statBox(AppNavigator.navigatorKey.currentContext!.l10n.yes, '$present', PdfColors.green700, arabicFontBold),
              pw.SizedBox(width: 10),
              _statBox(AppNavigator.navigatorKey.currentContext!.l10n.no, '$absent', PdfColors.red700, arabicFontBold),
              pw.SizedBox(width: 10),
              _statBox(AppNavigator.navigatorKey.currentContext!.l10n.delete, '$late', PdfColors.orange700, arabicFontBold),
            ],
          ),
          pw.SizedBox(height: 20),

          // History table
          pw.Text(AppNavigator.navigatorKey.currentContext!.l10n.edit,
              textDirection: pw.TextDirection.rtl,
              style: pw.TextStyle(font: arabicFontBold, fontSize: 14)),
          pw.SizedBox(height: 10),
          if (records.isEmpty)
            pw.Center(child: pw.Text(AppNavigator.navigatorKey.currentContext!.l10n.add,
                style: pw.TextStyle(font: arabicFont, color: PdfColors.grey500),
                textDirection: pw.TextDirection.rtl))
          else
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.8),
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.blue700),
                  children: [AppNavigator.navigatorKey.currentContext!.l10n.search, AppNavigator.navigatorKey.currentContext!.l10n.filter, AppNavigator.navigatorKey.currentContext!.l10n.sort, AppNavigator.navigatorKey.currentContext!.l10n.select]
                      .map((h) => _headerCell(h, arabicFontBold))
                      .toList(),
                ),
                ...records.take(50).map((r) => pw.TableRow(
                      children: [
                        _dataCell(DateFormat('yyyy-MM-dd').format(r.recordedAt), arabicFont, centered: true),
                        _dataCell(DateFormat('HH:mm').format(r.recordedAt), arabicFont, centered: true),
                        _statusCell(r.status, arabicFontBold),
                        _dataCell(r.notes ?? '—', arabicFont),
                      ],
                    )),
              ],
            ),
        ],
      ));

      final outputPath = await _savePdf(pdf, 'student_report_${student.id}');
      if (openAfter && outputPath != null) await OpenFile.open(outputPath);
      return outputPath;
    } catch (e, stack) {
      debugPrint('PDF student report error: $e\n$stack');
      return null;
    }
  }

  static pw.Widget _infoItem(String label, String value, pw.Font bold, pw.Font regular) => pw.Column(
        children: [
          pw.Text(label, style: pw.TextStyle(font: regular, fontSize: 9, color: PdfColors.grey600), textDirection: pw.TextDirection.rtl),
          pw.Text(value, style: pw.TextStyle(font: bold, fontSize: 11), textDirection: pw.TextDirection.rtl),
        ],
      );

  static pw.Widget _statBox(String label, String value, PdfColor color, pw.Font font) => pw.Expanded(
        child: pw.Container(
          padding: const pw.EdgeInsets.all(AppSpacing.sm),
          decoration: pw.BoxDecoration(color: PdfColor(color.red, color.green, color.blue, 0.1), borderRadius: pw.BorderRadius.circular(6)),
          child: pw.Column(
            children: [
              pw.Text(value, style: pw.TextStyle(font: font, fontSize: 14, color: color)),
              pw.Text(label, style: pw.TextStyle(font: font, fontSize: 8, color: color), textDirection: pw.TextDirection.rtl),
            ],
          ),
        ),
      );
}

// ── Internal data models ──────────────────────────────────────────────────────

class _AttendanceRow {
  final String studentName;
  final String grade;
  final String section;
  final String subject;
  final int period;
  final String status;

  const _AttendanceRow({
    required this.studentName,
    required this.grade,
    required this.section,
    required this.subject,
    required this.period,
    required this.status,
  });
}

class _StudentStats {
  int present = 0, absent = 0, late = 0, excused = 0;

  void add(String status) {
    switch (status) {
      case 'present': present++; break;
      case 'absent': absent++; break;
      case 'late': late++; break;
      case 'excused': excused++; break;
    }
  }

  int get total => present + absent + late + excused;
  double get attendanceRate => total == 0 ? 0 : present / total;
}
