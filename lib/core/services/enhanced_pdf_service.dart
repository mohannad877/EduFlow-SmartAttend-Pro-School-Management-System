import 'package:school_schedule_app/core/navigation/app_router.dart';
import 'package:school_schedule_app/core/utils/l10n_extension.dart';
import 'package:school_schedule_app/core/theme/app_spacing.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:school_schedule_app/domain/entities/session.dart';
import 'package:school_schedule_app/domain/entities/teacher.dart';
import 'package:school_schedule_app/domain/entities/subject.dart';
import 'package:school_schedule_app/domain/entities/classroom.dart';
import 'package:school_schedule_app/domain/entities/school.dart';
import 'package:school_schedule_app/domain/entities/enums.dart';

/// Enhanced PDF Exporter with professional formatting
class EnhancedPdfService {
  /// Generate enhanced PDF with school logo and statistics
  Future<Uint8List> generateEnhancedPdf({
    required List<Session> sessions,
    required School school,
    required Map<String, Teacher> teachers,
    required Map<String, Subject> subjects,
    required Map<String, Classroom> classrooms,
    String? customHeader,
    // Localized labels passed from UI layer
    String? dayLabel,
    String? totalSessionsLabel,
    Map<int, String>? localizedDayNames,
  }) async {
    final pdf = pw.Document();

    // Load logo if available
    pw.ImageProvider? logo;
    try {
      final logoData = await rootBundle.load('assets/images/school_logo.png');
      logo = pw.MemoryImage(logoData.buffer.asUint8List());
    } catch (_) {
      logo = null;
    }

    final hijriDate = _getDateString(localizedDayNames);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(AppSpacing.xl),
        header: (context) =>
            _buildEnhancedHeader(school, customHeader, logo, hijriDate),
        footer: (context) => _buildEnhancedFooter(context),
        build: (context) => [
          _buildScheduleTable(
            sessions, teachers, subjects, classrooms,
            dayLabel: dayLabel ?? AppNavigator.navigatorKey.currentContext!.l10n.day,
            localizedDayNames: localizedDayNames,
          ),
          pw.SizedBox(height: 20),
          _buildStatisticsSummary(sessions, totalSessionsLabel: totalSessionsLabel ?? AppNavigator.navigatorKey.currentContext!.l10n.totalSessions),
          pw.SizedBox(height: 20),
          _buildConflictReport(sessions),
        ],
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildEnhancedHeader(School school, String? customHeader,
      pw.ImageProvider? logo, String dateInfo) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 20),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          if (logo != null)
            pw.Container(
              width: 60,
              height: 60,
              child: pw.Image(logo),
            ),
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text(
                  school.name,
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blue800,
                  ),
                ),
                pw.Text(
                  AppNavigator.navigatorKey.currentContext!.l10n.statistics,
                  style: const pw.TextStyle(
                    fontSize: 14,
                    color: PdfColors.grey700,
                  ),
                ),
                if (customHeader != null)
                  pw.Text(
                    customHeader,
                    style: const pw.TextStyle(fontSize: 12),
                  ),
                pw.Divider(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildEnhancedFooter(pw.Context context) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 20),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            AppNavigator.navigatorKey.currentContext!.l10n.reports,
            style: const pw.TextStyle(
              fontSize: 10,
              color: PdfColors.grey600,
            ),
          ),
          pw.Text(
            AppNavigator.navigatorKey.currentContext!.l10n.schedule,
            style: const pw.TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildScheduleTable(
    List<Session> sessions,
    Map<String, Teacher> teachers,
    Map<String, Subject> subjects,
    Map<String, Classroom> classrooms, {
    required String dayLabel,
    Map<int, String>? localizedDayNames,
  }) {
    // Default Arabic day names as fallback
    final defaultDayNames = {
      DateTime.saturday: AppNavigator.navigatorKey.currentContext!.l10n.saturday,
      DateTime.sunday: AppNavigator.navigatorKey.currentContext!.l10n.sunday,
      DateTime.monday: AppNavigator.navigatorKey.currentContext!.l10n.monday,
      DateTime.tuesday: AppNavigator.navigatorKey.currentContext!.l10n.tuesday,
      DateTime.wednesday: AppNavigator.navigatorKey.currentContext!.l10n.wednesday,
      DateTime.thursday: AppNavigator.navigatorKey.currentContext!.l10n.thursday,
      DateTime.friday: AppNavigator.navigatorKey.currentContext!.l10n.friday,
    };
    final dayNames = localizedDayNames ?? defaultDayNames;

    // Define table headers
    final headers = [dayLabel, AppNavigator.navigatorKey.currentContext!.l10n.settings, AppNavigator.navigatorKey.currentContext!.l10n.section, AppNavigator.navigatorKey.currentContext!.l10n.help, AppNavigator.navigatorKey.currentContext!.l10n.grade];

    // Convert session data
    final data = sessions.map((s) {
      final subject = subjects[s.subjectId];
      return [
        s.day.getArabicName(AppNavigator.navigatorKey.currentContext!),
        s.sessionNumber.toString(),
        subject?.name ?? AppNavigator.navigatorKey.currentContext!.l10n.about,
        teachers[s.teacherId]?.fullName ?? AppNavigator.navigatorKey.currentContext!.l10n.about,
        classrooms[s.classId]?.name ?? AppNavigator.navigatorKey.currentContext!.l10n.about,
      ];
    }).toList();

    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: data,
      border: pw.TableBorder.all(),
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      cellAlignment: pw.Alignment.center,
      oddRowDecoration: const pw.BoxDecoration(color: PdfColors.grey100),
    );
  }

  pw.Widget _buildConflictReport(List<Session> sessions) {
    final conflicts = <String>[];

    final teacherMap = <String, List<Session>>{};
    for (var s in sessions) {
      final key = '${s.day}_${s.sessionNumber}_${s.teacherId}';
      if (s.teacherId.isNotEmpty) {
        teacherMap.putIfAbsent(key, () => []).add(s);
      }
    }

    teacherMap.forEach((key, list) {
      if (list.length > 1) {
        conflicts.add(
            AppNavigator.navigatorKey.currentContext!.l10n.logout);
      }
    });

    if (conflicts.isEmpty) return pw.Container();

    return pw.Container(
      padding: const pw.EdgeInsets.all(AppSpacing.sm),
      color: PdfColors.red50,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(AppNavigator.navigatorKey.currentContext!.l10n.login,
              style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold, color: PdfColors.red800)),
          ...conflicts.map((c) => pw.Text('- $c',
              style:
                  const pw.TextStyle(color: PdfColors.red700, fontSize: 10))),
        ],
      ),
    );
  }

  pw.Widget _buildStatisticsSummary(List<Session> sessions, {required String totalSessionsLabel}) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(AppSpacing.lg),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            AppNavigator.navigatorKey.currentContext!.l10n.register,
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: [
              _buildStatCard(totalSessionsLabel, sessions.length.toString()),
              _buildStatCard(
                AppNavigator.navigatorKey.currentContext!.l10n.update,
                sessions.map((s) => s.teacherId).toSet().length.toString(),
              ),
              _buildStatCard(
                AppNavigator.navigatorKey.currentContext!.l10n.create,
                sessions.map((s) => s.classId).toSet().length.toString(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildStatCard(String label, String value) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(AppSpacing.sm),
      child: pw.Column(
        children: [
          pw.Text(
            label,
            style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue700,
            ),
          ),
        ],
      ),
    );
  }

  String _getDateString(Map<int, String>? localizedDayNames) {
    final now = DateTime.now();
    final monthNames = {
      1: AppNavigator.navigatorKey.currentContext!.l10n.january,
      2: AppNavigator.navigatorKey.currentContext!.l10n.february,
      3: AppNavigator.navigatorKey.currentContext!.l10n.march,
      4: AppNavigator.navigatorKey.currentContext!.l10n.april,
      5: AppNavigator.navigatorKey.currentContext!.l10n.may,
      6: AppNavigator.navigatorKey.currentContext!.l10n.june,
      7: AppNavigator.navigatorKey.currentContext!.l10n.july,
      8: AppNavigator.navigatorKey.currentContext!.l10n.august,
      9: AppNavigator.navigatorKey.currentContext!.l10n.september,
      10: AppNavigator.navigatorKey.currentContext!.l10n.october,
      11: AppNavigator.navigatorKey.currentContext!.l10n.november,
      12: AppNavigator.navigatorKey.currentContext!.l10n.december
    };

    final defaultDayNames = {
      DateTime.saturday: AppNavigator.navigatorKey.currentContext!.l10n.saturday,
      DateTime.sunday: AppNavigator.navigatorKey.currentContext!.l10n.sunday,
      DateTime.monday: AppNavigator.navigatorKey.currentContext!.l10n.monday,
      DateTime.tuesday: AppNavigator.navigatorKey.currentContext!.l10n.tuesday,
      DateTime.wednesday: AppNavigator.navigatorKey.currentContext!.l10n.wednesday,
      DateTime.thursday: AppNavigator.navigatorKey.currentContext!.l10n.thursday,
      DateTime.friday: AppNavigator.navigatorKey.currentContext!.l10n.friday,
    };

    final dayNames = localizedDayNames ?? defaultDayNames;
    final dayName = dayNames[now.weekday] ?? '';
    final monthName = monthNames[now.month] ?? '';

    return '$dayName ${now.day} $monthName ${now.year}';
  }
}
