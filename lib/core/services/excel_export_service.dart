// ============================================================================
// 📦 excel_export_service.dart  (REFACTORED — Context-Free)
// 🎯 Pure stateless Excel export service. All localized strings received via
//    SchedulePdfStrings DTO — no BuildContext, no NavigatorKey references.
// ============================================================================

import 'dart:io';
import 'package:excel/excel.dart';
import 'package:injectable/injectable.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

import 'package:school_schedule_app/domain/entities/schedule.dart';
import 'package:school_schedule_app/domain/entities/school.dart';
import 'package:school_schedule_app/domain/entities/enums.dart';
import 'package:school_schedule_app/domain/entities/session.dart';
import 'package:school_schedule_app/core/models/service_strings.dart';

@lazySingleton
class ExcelExportService {
  /// Export the full schedule (classroom sheets + teacher sheets) to an .xlsx
  /// file and open it with the system file viewer.
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
    var excel = Excel.createExcel();
    excel.delete('Sheet1'); // remove default blank sheet

    final now = DateTime.now();
    final dateFormatter = DateFormat('yyyy-MM-dd');

    // ── Shared cell styles ─────────────────────────────────────────────────
    final headerStyle = CellStyle(
      backgroundColorHex: ExcelColor.fromHexString('#1976D2'),
      fontColorHex: ExcelColor.white,
      bold: true,
      fontSize: 12,
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
    );
    final dayStyle = CellStyle(
      backgroundColorHex: ExcelColor.fromHexString('#BBDEFB'),
      bold: true,
      fontSize: 11,
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
    );
    final sessionStyle = CellStyle(
      backgroundColorHex: ExcelColor.fromHexString('#E3F2FD'),
      fontSize: 10,
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
      textWrapping: TextWrapping.WrapText,
    );
    final emptyStyle = CellStyle(
      backgroundColorHex: ExcelColor.fromHexString('#F5F5F5'),
    );
    final titleStyle = CellStyle(
      backgroundColorHex: ExcelColor.fromHexString('#0D47A1'),
      fontColorHex: ExcelColor.white,
      bold: true,
      fontSize: 16,
      horizontalAlign: HorizontalAlign.Center,
    );
    final infoStyle = CellStyle(
      fontSize: 10,
      horizontalAlign: HorizontalAlign.Right,
    );

    // ── Classroom sheets ───────────────────────────────────────────────────
    for (final entry in classroomNames.entries) {
      final classId = entry.key;
      final className = entry.value;

      _buildSheet(
        excel: excel,
        sheetName: className,
        school: school,
        title: school.name,
        subtitle: '${strings.classroomScheduleTitle} - $className',
        schedule: schedule,
        strings: strings,
        dateStr: dateFormatter.format(now),
        subjectNames: subjectNames,
        teacherOrClassNames: teacherNames,
        sessionFilter: (s) => s.classId == classId,
        resolveSecondaryName: (session) =>
            teacherNames[session.teacherId] ?? strings.unknownTeacher,
        headerStyle: headerStyle,
        dayStyle: dayStyle,
        sessionStyle: sessionStyle,
        emptyStyle: emptyStyle,
        titleStyle: titleStyle,
        infoStyle: infoStyle,
      );
    }

    // ── Teacher sheets ─────────────────────────────────────────────────────
    for (final entry in teacherNames.entries) {
      final teacherId = entry.key;
      final teacherName = entry.value;

      _buildSheet(
        excel: excel,
        sheetName: teacherName,
        school: school,
        title: school.name,
        subtitle: '${strings.teacherScheduleTitle} - $teacherName',
        schedule: schedule,
        strings: strings,
        dateStr: dateFormatter.format(now),
        subjectNames: subjectNames,
        teacherOrClassNames: classroomNames,
        sessionFilter: (s) => s.teacherId == teacherId,
        resolveSecondaryName: (session) =>
            classroomNames[session.classId] ?? '',
        headerStyle: headerStyle,
        dayStyle: dayStyle,
        sessionStyle: sessionStyle,
        emptyStyle: emptyStyle,
        titleStyle: titleStyle,
        infoStyle: infoStyle,
      );
    }

    // ── Save and open ──────────────────────────────────────────────────────
    final directory = await getApplicationDocumentsDirectory();
    final fileName = '${school.name}_Schedule_${dateFormatter.format(now)}.xlsx';
    final path = '${directory.path}/$fileName';
    final bytes = excel.save();
    if (bytes != null) {
      await File(path).writeAsBytes(bytes);
      await OpenFile.open(path);
    }
  }

  // ─── Private sheet builder ─────────────────────────────────────────────────

  void _buildSheet({
    required Excel excel,
    required String sheetName,
    required School school,
    required String title,
    required String subtitle,
    required Schedule schedule,
    required SchedulePdfStrings strings,
    required String dateStr,
    required Map<String, String> subjectNames,
    required Map<String, String> teacherOrClassNames,
    required bool Function(Session) sessionFilter,
    required String Function(Session) resolveSecondaryName,
    required CellStyle headerStyle,
    required CellStyle dayStyle,
    required CellStyle sessionStyle,
    required CellStyle emptyStyle,
    required CellStyle titleStyle,
    required CellStyle infoStyle,
  }) {
    final safeName = sheetName
        .replaceAll(RegExp(r'[\\/?\*\[\]]'), '_')
        .substring(0, sheetName.length > 27 ? 27 : sheetName.length);

    final sheet = excel[safeName];
    var row = 0;

    // Title row
    final tc = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row));
    tc.value = TextCellValue(title);
    tc.cellStyle = titleStyle;
    sheet.merge(
      CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row),
      CellIndex.indexByColumnRow(columnIndex: school.dailySessions, rowIndex: row),
    );
    row++;

    // Subtitle row
    final sc = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row));
    sc.value = TextCellValue(subtitle);
    sc.cellStyle = headerStyle;
    sheet.merge(
      CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row),
      CellIndex.indexByColumnRow(columnIndex: school.dailySessions, rowIndex: row),
    );
    row += 2; // skip one empty row

    // Meta: school year + issue date
    final ayc = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row));
    ayc.value = TextCellValue('${strings.schoolYearLabel}: ${school.academicYear}');
    ayc.cellStyle = infoStyle;
    final dc = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row));
    dc.value = TextCellValue('${strings.generatedOnLabel}: $dateStr');
    dc.cellStyle = infoStyle;
    row += 2;

    // Header row (Day + Period columns)
    final dhc = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row));
    dhc.value = TextCellValue(strings.dayLabel);
    dhc.cellStyle = headerStyle;

    for (var i = 0; i < school.dailySessions; i++) {
      final pc = sheet.cell(CellIndex.indexByColumnRow(columnIndex: i + 1, rowIndex: row));
      pc.value = TextCellValue('${strings.periodLabel} ${i + 1}');
      pc.cellStyle = headerStyle;
    }
    row++;

    // Data rows per work day
    for (final day in school.workDays) {
      final dayc = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row));
      dayc.value = TextCellValue(strings.resolveDay(day.name));
      dayc.cellStyle = dayStyle;

      for (var i = 0; i < school.dailySessions; i++) {
        final session = schedule.sessions.firstWhere(
          (s) => s.day == day && s.sessionNumber == i + 1 && sessionFilter(s),
          orElse: () => Session(
            id: '', day: day, sessionNumber: i + 1,
            classId: '', teacherId: '', subjectId: '', roomId: '',
            status: SessionStatus.pending,
          ),
        );
        final cell = sheet.cell(
          CellIndex.indexByColumnRow(columnIndex: i + 1, rowIndex: row),
        );
        if (session.id.isNotEmpty) {
          final subject = subjectNames[session.subjectId] ?? strings.unknownSubject;
          final secondary = resolveSecondaryName(session);
          cell.value = TextCellValue('$subject\n$secondary');
          cell.cellStyle = sessionStyle;
        } else {
          cell.value = TextCellValue('');
          cell.cellStyle = emptyStyle;
        }
      }
      row++;
    }

    // Footer
    row++;
    final fc = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row));
    fc.value = TextCellValue(strings.generatedOnLabel);
    fc.cellStyle = infoStyle;
    sheet.merge(
      CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row),
      CellIndex.indexByColumnRow(columnIndex: school.dailySessions, rowIndex: row),
    );

    sheet.setColumnWidth(1, 15);
    for (var i = 2; i <= 9; i++) {
      sheet.setColumnWidth(i, 20);
    }
  }
}
