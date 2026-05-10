// ============================================================================
// 📦 pdf_export_service.dart  (REFACTORED — Context-Free)
// 🎯 Pure stateless PDF export service. Receives all localized strings via
//    SchedulePdfStrings DTO — no BuildContext, no NavigatorKey references.
// ============================================================================

import 'package:injectable/injectable.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

import 'package:school_schedule_app/domain/entities/schedule.dart';
import 'package:school_schedule_app/domain/entities/school.dart';
import 'package:school_schedule_app/domain/entities/enums.dart';
import 'package:school_schedule_app/domain/entities/session.dart';
import 'package:school_schedule_app/core/models/service_strings.dart';
import 'package:school_schedule_app/core/theme/app_spacing.dart';

@lazySingleton
class PdfExportService {
  /// Export classroom + teacher schedule pages to PDF and open the print dialog.
  ///
  /// [strings] must be built from AppLocalizations in the BLoC or UI layer.
  Future<void> exportSchedule({
    required Schedule schedule,
    required School school,
    required Map<String, String> teacherNames,
    required Map<String, String> subjectNames,
    required Map<String, String> classroomNames,
    required SchedulePdfStrings strings,
    bool includeValidation = false,
    dynamic validationResult,
  }) async {
    final pdf = pw.Document();

    // ── Load Arabic fonts ──────────────────────────────────────────────────
    final arabicFont = await PdfGoogleFonts.cairoRegular();
    final arabicFontBold = await PdfGoogleFonts.cairoBold();

    final dateFormatter = DateFormat('yyyy-MM-dd');
    final now = DateTime.now();

    // ── Classroom pages ────────────────────────────────────────────────────
    for (final entry in classroomNames.entries) {
      final classId = entry.key;
      final className = entry.value;

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4.landscape,
          margin: const pw.EdgeInsets.all(AppSpacing.lg),
          theme: pw.ThemeData.withFont(
            base: arabicFont,
            bold: arabicFontBold,
          ),
          build: (pw.Context ctx) => _buildClassroomPage(
            schedule: schedule,
            school: school,
            classId: classId,
            className: className,
            subjectNames: subjectNames,
            teacherNames: teacherNames,
            classroomNames: classroomNames,
            strings: strings,
            dateStr: dateFormatter.format(now),
            arabicFont: arabicFont,
            arabicFontBold: arabicFontBold,
          ),
        ),
      );
    }

    // ── Teacher pages ──────────────────────────────────────────────────────
    for (final entry in teacherNames.entries) {
      final teacherId = entry.key;
      final teacherName = entry.value;

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4.landscape,
          margin: const pw.EdgeInsets.all(AppSpacing.lg),
          theme: pw.ThemeData.withFont(
            base: arabicFont,
            bold: arabicFontBold,
          ),
          build: (pw.Context ctx) => _buildTeacherPage(
            schedule: schedule,
            school: school,
            teacherId: teacherId,
            teacherName: teacherName,
            subjectNames: subjectNames,
            classroomNames: classroomNames,
            strings: strings,
            dateStr: dateFormatter.format(now),
            arabicFont: arabicFont,
            arabicFontBold: arabicFontBold,
          ),
        ),
      );
    }

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: '${school.name}_Schedule_${dateFormatter.format(now)}.pdf',
    );
  }

  // ─── Page builders ─────────────────────────────────────────────────────────

  pw.Widget _buildClassroomPage({
    required Schedule schedule,
    required School school,
    required String classId,
    required String className,
    required Map<String, String> subjectNames,
    required Map<String, String> teacherNames,
    required Map<String, String> classroomNames,
    required SchedulePdfStrings strings,
    required String dateStr,
    required pw.Font arabicFont,
    required pw.Font arabicFontBold,
  }) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildPageHeader(
          title: school.name,
          subtitle: '${strings.classroomSubtitle}: $className',
          color: PdfColors.blue700,
          arabicFont: arabicFont,
          arabicFontBold: arabicFontBold,
        ),
        pw.SizedBox(height: 10),
        _buildMetaRow(
          strings: strings,
          dateStr: dateStr,
          schoolYear: school.academicYear,
          arabicFont: arabicFont,
        ),
        pw.SizedBox(height: 10),
        pw.Expanded(
          child: _buildScheduleTable(
            schedule: schedule,
            school: school,
            strings: strings,
            arabicFont: arabicFont,
            arabicFontBold: arabicFontBold,
            sessionFilter: (s) => s.classId == classId,
            resolveCell: (session) => _buildSessionCell(
              subject: subjectNames[session.subjectId] ?? strings.unknownSubject,
              teacher: teacherNames[session.teacherId] ?? strings.unknownTeacher,
              classroom: '',
              arabicFont: arabicFont,
              arabicFontBold: arabicFontBold,
            ),
          ),
        ),
        pw.SizedBox(height: 8),
        _buildFooter(strings: strings, dateStr: dateStr, arabicFont: arabicFont),
      ],
    );
  }

  pw.Widget _buildTeacherPage({
    required Schedule schedule,
    required School school,
    required String teacherId,
    required String teacherName,
    required Map<String, String> subjectNames,
    required Map<String, String> classroomNames,
    required SchedulePdfStrings strings,
    required String dateStr,
    required pw.Font arabicFont,
    required pw.Font arabicFontBold,
  }) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildPageHeader(
          title: school.name,
          subtitle: '${strings.teacherSubtitle}: $teacherName',
          color: PdfColors.green700,
          arabicFont: arabicFont,
          arabicFontBold: arabicFontBold,
        ),
        pw.SizedBox(height: 10),
        _buildMetaRow(
          strings: strings,
          dateStr: dateStr,
          schoolYear: school.academicYear,
          arabicFont: arabicFont,
        ),
        pw.SizedBox(height: 10),
        pw.Expanded(
          child: _buildScheduleTable(
            schedule: schedule,
            school: school,
            strings: strings,
            arabicFont: arabicFont,
            arabicFontBold: arabicFontBold,
            sessionFilter: (s) => s.teacherId == teacherId,
            resolveCell: (session) => _buildSessionCell(
              subject: subjectNames[session.subjectId] ?? strings.unknownSubject,
              teacher: classroomNames[session.classId] ?? '',
              classroom: '',
              arabicFont: arabicFont,
              arabicFontBold: arabicFontBold,
            ),
          ),
        ),
        pw.SizedBox(height: 8),
        _buildFooter(strings: strings, dateStr: dateStr, arabicFont: arabicFont),
      ],
    );
  }

  // ─── Reusable PDF widgets ──────────────────────────────────────────────────

  pw.Widget _buildPageHeader({
    required String title,
    required String subtitle,
    required PdfColor color,
    required pw.Font arabicFont,
    required pw.Font arabicFontBold,
  }) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(AppSpacing.md),
      decoration: pw.BoxDecoration(
        color: color,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold, color: PdfColors.white, font: arabicFontBold),
            textDirection: pw.TextDirection.rtl,
          ),
          pw.SizedBox(height: 6),
          pw.Text(
            subtitle,
            style: pw.TextStyle(fontSize: 14, color: PdfColors.white, font: arabicFont),
            textDirection: pw.TextDirection.rtl,
          ),
        ],
      ),
    );
  }

  pw.Widget _buildMetaRow({
    required SchedulePdfStrings strings,
    required String dateStr,
    required String schoolYear,
    required pw.Font arabicFont,
  }) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          '${strings.generatedOnLabel}: $dateStr',
          style: pw.TextStyle(fontSize: 10, font: arabicFont),
          textDirection: pw.TextDirection.rtl,
        ),
        pw.Text(
          '${strings.schoolYearLabel}: $schoolYear',
          style: pw.TextStyle(fontSize: 10, font: arabicFont),
          textDirection: pw.TextDirection.rtl,
        ),
      ],
    );
  }

  pw.Widget _buildScheduleTable({
    required Schedule schedule,
    required School school,
    required SchedulePdfStrings strings,
    required pw.Font arabicFont,
    required pw.Font arabicFontBold,
    required bool Function(dynamic session) sessionFilter,
    required pw.Widget Function(dynamic session) resolveCell,
  }) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey400, width: 1),
      columnWidths: {0: const pw.FixedColumnWidth(80)},
      children: [
        // Header row
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey300),
          children: [
            _buildHeaderCell(strings.dayLabel, arabicFontBold),
            ...List.generate(school.dailySessions, (i) =>
              _buildHeaderCell('${strings.periodLabel} ${i + 1}', arabicFontBold)),
          ],
        ),
        // Data rows per work day
        ...school.workDays.map((day) {
          return pw.TableRow(
            children: [
              _buildDayCell(strings.resolveDay(day.name), arabicFontBold),
              ...List.generate(school.dailySessions, (sessionIndex) {
                final session = schedule.sessions.firstWhere(
                  (s) => s.day == day && s.sessionNumber == sessionIndex + 1 && sessionFilter(s),
                  orElse: () => Session(
                    id: '', day: day, sessionNumber: sessionIndex + 1,
                    classId: '', teacherId: '', subjectId: '', roomId: '',
                    status: SessionStatus.pending,
                  ),
                );
                if (session.id.isEmpty) return _buildEmptyCell();
                return resolveCell(session);
              }),
            ],
          );
        }),
      ],
    );
  }

  pw.Widget _buildFooter({
    required SchedulePdfStrings strings,
    required String dateStr,
    required pw.Font arabicFont,
  }) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(AppSpacing.sm),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
        borderRadius: pw.BorderRadius.circular(4),
        color: PdfColors.grey100,
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            dateStr,
            style: pw.TextStyle(fontSize: 9, font: arabicFont),
            textDirection: pw.TextDirection.rtl,
          ),
          pw.Text(
            strings.generatedOnLabel,
            style: pw.TextStyle(fontSize: 9, font: arabicFont),
            textDirection: pw.TextDirection.rtl,
          ),
        ],
      ),
    );
  }

  pw.Widget _buildHeaderCell(String text, pw.Font font) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(AppSpacing.sm),
      alignment: pw.Alignment.center,
      child: pw.Text(
        text,
        style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, font: font),
        textDirection: pw.TextDirection.rtl,
        textAlign: pw.TextAlign.center,
        maxLines: 1,
        overflow: pw.TextOverflow.clip,
      ),
    );
  }

  pw.Widget _buildDayCell(String text, pw.Font font) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(AppSpacing.sm),
      alignment: pw.Alignment.center,
      decoration: const pw.BoxDecoration(color: PdfColors.blue50),
      child: pw.Text(
        text,
        style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, font: font),
        textDirection: pw.TextDirection.rtl,
        textAlign: pw.TextAlign.center,
        maxLines: 1,
        overflow: pw.TextOverflow.clip,
      ),
    );
  }

  pw.Widget _buildEmptyCell() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(AppSpacing.sm),
      alignment: pw.Alignment.center,
      color: PdfColors.grey50,
      child: pw.Text(''),
    );
  }

  pw.Widget _buildSessionCell({
    required String subject,
    required String teacher,
    required String classroom,
    required pw.Font arabicFont,
    required pw.Font arabicFontBold,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      alignment: pw.Alignment.center,
      decoration: pw.BoxDecoration(
        color: PdfColors.blue50,
        border: pw.Border.all(color: PdfColors.blue200, width: 0.5),
      ),
      child: pw.Column(
        mainAxisAlignment: pw.MainAxisAlignment.center,
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Text(subject,
            style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, font: arabicFontBold, color: PdfColors.blue900),
            textDirection: pw.TextDirection.rtl, textAlign: pw.TextAlign.center, maxLines: 2, overflow: pw.TextOverflow.clip),
          pw.SizedBox(height: 2),
          pw.Text(teacher,
            style: pw.TextStyle(fontSize: 7, font: arabicFont, color: PdfColors.grey800),
            textDirection: pw.TextDirection.rtl, textAlign: pw.TextAlign.center, maxLines: 1, overflow: pw.TextOverflow.clip),
          if (classroom.isNotEmpty) ...[
            pw.SizedBox(height: 1),
            pw.Text(classroom,
              style: pw.TextStyle(fontSize: 6, font: arabicFont, color: PdfColors.grey600),
              textDirection: pw.TextDirection.rtl, textAlign: pw.TextAlign.center, maxLines: 1),
          ],
        ],
      ),
    );
  }
}
