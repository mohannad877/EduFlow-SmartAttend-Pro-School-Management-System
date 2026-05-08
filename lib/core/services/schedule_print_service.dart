// ============================================================================
// 📦 schedule_print_service.dart  (REFACTORED — Context-Free)
// 🎯 Pure stateless print service. All localized strings received via
//    SchedulePdfStrings DTO — no BuildContext, no NavigatorKey references.
// ============================================================================

import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'package:school_schedule_app/domain/entities/session.dart';
import 'package:school_schedule_app/domain/entities/teacher.dart';
import 'package:school_schedule_app/domain/entities/classroom.dart';
import 'package:school_schedule_app/domain/entities/subject.dart';
import 'package:school_schedule_app/core/models/print_settings.dart';
import 'package:school_schedule_app/core/models/service_strings.dart';
import 'package:school_schedule_app/core/theme/app_spacing.dart';

/// Advanced Print Service for Schedule Templates.
/// Fully decoupled from Flutter UI — safe to call from BLoC or background.
class SchedulePrintService {
  /// Print teacher-specific schedule.
  ///
  /// [strings] supplies all localized labels without touching BuildContext.
  Future<void> printTeacherSchedule({
    required Teacher teacher,
    required List<Session> sessions,
    required Map<String, Subject> subjects,
    required Map<String, Classroom> classrooms,
    required SchedulePdfStrings strings,
    PrintSettings? settings,
  }) async {
    settings ??= const PrintSettings();

    await Printing.layoutPdf(
      onLayout: (format) => _generateTeacherPdf(
        teacher, sessions, subjects, classrooms, settings!, format, strings,
      ),
      name: '${strings.teacherSubtitle}_${teacher.fullName}',
    );
  }

  /// Print classroom-specific schedule.
  Future<void> printClassSchedule({
    required Classroom classroom,
    required List<Session> sessions,
    required Map<String, Teacher> teachers,
    required Map<String, Subject> subjects,
    required SchedulePdfStrings strings,
    PrintSettings? settings,
  }) async {
    settings ??= const PrintSettings();

    await Printing.layoutPdf(
      onLayout: (format) => _generateClassPdf(
        classroom, sessions, teachers, subjects, settings!, format, strings,
      ),
      name: '${strings.classroomSubtitle}_${classroom.name}',
    );
  }

  /// Print master schedule (all sessions).
  Future<void> printMasterSchedule({
    required List<Session> sessions,
    required Map<String, Teacher> teachers,
    required Map<String, Subject> subjects,
    required Map<String, Classroom> classrooms,
    required SchedulePdfStrings strings,
    PrintSettings? settings,
  }) async {
    settings ??= const PrintSettings();

    await Printing.layoutPdf(
      onLayout: (format) => _generateMasterPdf(
        sessions, teachers, subjects, classrooms, settings!, format, strings,
      ),
      name: strings.masterScheduleTitle,
    );
  }

  // ─── Private PDF generators ────────────────────────────────────────────────

  Future<Uint8List> _generateTeacherPdf(
    Teacher teacher,
    List<Session> sessions,
    Map<String, Subject> subjects,
    Map<String, Classroom> classrooms,
    PrintSettings settings,
    PdfPageFormat format,
    SchedulePdfStrings strings,
  ) async {
    final pdf = pw.Document();
    final teacherSessions = sessions.where((s) => s.teacherId == teacher.id).toList();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: format,
        margin: const pw.EdgeInsets.all(AppSpacing.xl),
        header: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text(strings.teacherScheduleTitle,
                style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
            if (settings.showTeacherName)
              pw.Text(teacher.fullName,
                  style: pw.TextStyle(fontSize: 16)),
            pw.Divider(),
          ],
        ),
        build: (context) => [
          pw.TableHelper.fromTextArray(
            headers: [strings.dayLabel, strings.periodLabel, strings.subjectLabel, strings.classroomLabel],
            data: teacherSessions
                .map((s) => [
                      strings.resolveDay(s.day.name),
                      s.sessionNumber.toString(),
                      subjects[s.subjectId]?.name ?? strings.unknownSubject,
                      classrooms[s.classId]?.name ?? '',
                    ])
                .toList(),
            border: pw.TableBorder.all(),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
    );

    return pdf.save();
  }

  Future<Uint8List> _generateClassPdf(
    Classroom classroom,
    List<Session> sessions,
    Map<String, Teacher> teachers,
    Map<String, Subject> subjects,
    PrintSettings settings,
    PdfPageFormat format,
    SchedulePdfStrings strings,
  ) async {
    final pdf = pw.Document();
    final classSessions = sessions.where((s) => s.classId == classroom.id).toList();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: format,
        margin: const pw.EdgeInsets.all(AppSpacing.xl),
        header: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text(strings.classroomScheduleTitle,
                style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
            pw.Text(classroom.name, style: pw.TextStyle(fontSize: 16)),
            pw.Divider(),
          ],
        ),
        build: (context) => [
          pw.TableHelper.fromTextArray(
            headers: [strings.dayLabel, strings.periodLabel, strings.subjectLabel, strings.teacherLabel],
            data: classSessions
                .map((s) => [
                      strings.resolveDay(s.day.name),
                      s.sessionNumber.toString(),
                      subjects[s.subjectId]?.name ?? strings.unknownSubject,
                      teachers[s.teacherId]?.fullName ?? strings.unknownTeacher,
                    ])
                .toList(),
            border: pw.TableBorder.all(),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
    );

    return pdf.save();
  }

  Future<Uint8List> _generateMasterPdf(
    List<Session> sessions,
    Map<String, Teacher> teachers,
    Map<String, Subject> subjects,
    Map<String, Classroom> classrooms,
    PrintSettings settings,
    PdfPageFormat format,
    SchedulePdfStrings strings,
  ) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: format,
        margin: const pw.EdgeInsets.all(AppSpacing.xl),
        header: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Text(strings.masterScheduleTitle,
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.Divider(),
          ],
        ),
        build: (context) => [
          pw.TableHelper.fromTextArray(
            headers: [strings.dayLabel, strings.periodLabel, strings.subjectLabel, strings.teacherLabel, strings.classroomLabel],
            data: sessions
                .map((s) => [
                      strings.resolveDay(s.day.name),
                      s.sessionNumber.toString(),
                      subjects[s.subjectId]?.name ?? strings.unknownSubject,
                      teachers[s.teacherId]?.fullName ?? strings.unknownTeacher,
                      classrooms[s.classId]?.name ?? '',
                    ])
                .toList(),
            border: pw.TableBorder.all(),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            cellAlignment: pw.Alignment.center,
          ),
        ],
      ),
    );

    return pdf.save();
  }
}
