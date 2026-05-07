// ============================================================================
// 📦 service_strings.dart
// 🎯 Localization DTOs for Pure Services — completely decoupled from BuildContext.
//
// Usage: instantiate in the UI/BLoC layer from AppLocalizations, then pass
// to any Service. Services never import or reference Flutter UI classes.
// ============================================================================

import 'package:flutter/foundation.dart';

// ─────────────────────────────────────────────────────────────────────────────
// 📄 PDF / Print Strings
// Used by: PdfExportService, SchedulePrintService
// ─────────────────────────────────────────────────────────────────────────────

@immutable
class SchedulePdfStrings {
  /// Column headers
  final String dayLabel;
  final String periodLabel;
  final String subjectLabel;
  final String teacherLabel;
  final String classroomLabel;

  /// Day names map (key: enum name e.g. 'monday', value: localized name)
  final Map<String, String> dayNames;

  /// Report meta labels
  final String classroomScheduleTitle;   // e.g. "جدول الفصل"
  final String teacherScheduleTitle;     // e.g. "جدول المعلم"
  final String masterScheduleTitle;      // e.g. "الجدول الرئيسي"
  final String classroomSubtitle;        // e.g. "الفصل: {name}"
  final String teacherSubtitle;          // e.g. "المعلم: {name}"
  final String generatedOnLabel;         // e.g. "تم الإنشاء في"
  final String schoolYearLabel;          // e.g. "العام الدراسي"
  final String pageLabel;                // e.g. "صفحة"
  final String ofLabel;                  // e.g. "من"
  final String unknownSubject;           // fallback when subject id not found
  final String unknownTeacher;           // fallback when teacher id not found

  const SchedulePdfStrings({
    required this.dayLabel,
    required this.periodLabel,
    required this.subjectLabel,
    required this.teacherLabel,
    required this.classroomLabel,
    required this.dayNames,
    required this.classroomScheduleTitle,
    required this.teacherScheduleTitle,
    required this.masterScheduleTitle,
    required this.classroomSubtitle,
    required this.teacherSubtitle,
    required this.generatedOnLabel,
    required this.schoolYearLabel,
    required this.pageLabel,
    required this.ofLabel,
    required this.unknownSubject,
    required this.unknownTeacher,
  });

  /// Convenience method: resolve a localized day name with fallback.
  String resolveDay(String dayEnumName) =>
      dayNames[dayEnumName] ?? dayEnumName;
}

// ─────────────────────────────────────────────────────────────────────────────
// 🔄 SyncService Strings
// Used by: SyncService
// ─────────────────────────────────────────────────────────────────────────────

@immutable
class SyncServiceStrings {
  final String bulkImportDescription;       // e.g. "استيراد دفعي"
  final String scheduleGenerationDesc;      // e.g. "توليد جدول"
  final String backupSuccessDesc;           // e.g. "نسخ احتياطي ناجح"
  final String backupFailedDesc;            // e.g. "فشل النسخ الاحتياطي"
  final String studentDeletedDesc;          // e.g. "حذف طالب"
  final String studentUpdatedPrefix;        // e.g. "تعديل بيانات"

  const SyncServiceStrings({
    required this.bulkImportDescription,
    required this.scheduleGenerationDesc,
    required this.backupSuccessDesc,
    required this.backupFailedDesc,
    required this.studentDeletedDesc,
    required this.studentUpdatedPrefix,
  });
}
