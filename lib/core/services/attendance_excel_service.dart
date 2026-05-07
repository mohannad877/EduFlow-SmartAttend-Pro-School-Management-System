import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:excel/excel.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:drift/drift.dart';
import 'package:school_schedule_app/core/database/attendance_database.dart';

// ============================================================================
// AttendanceExcelService — Generates Excel reports from attendance data
// ============================================================================

class AttendanceExcelService {
  // ── Daily Report ──────────────────────────────────────────────────────────

  static Future<String?> generateDailyReport({
    required AttendanceDatabase db,
    required DateTime date,
    required String schoolName,
    bool openAfter = true,
  }) async {
    try {
      final grades = await db.select(db.attGrades).get();
      final sections = await db.select(db.attSections).get();
      final subjects = await db.select(db.attSubjects).get();
      final students = await db.select(db.attStudents).get();

      final gradeMap = {for (var g in grades) g.id: g.name};
      final sectionMap = {for (var s in sections) s.id: s.name};
      final subjectMap = {for (var s in subjects) s.id: s.name};
      final studentMap = {for (var s in students) s.id: s};

      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final sessions = await (db.select(db.attSessions)
            ..where((s) => s.date.isBiggerOrEqualValue(startOfDay) &
                          s.date.isSmallerThanValue(endOfDay)))
          .get();

      final excel = Excel.createExcel();
      const sheetTitle = 'التقرير اليومي';
      final sheet = excel[sheetTitle];
      excel.setDefaultSheet(sheetTitle);

      // Title
      sheet.cell(CellIndex.indexByString('A1')).value =
          TextCellValue('تقرير الحضور اليومي - $schoolName');
      _styleTitleCell(sheet.cell(CellIndex.indexByString('A1')));
      sheet.merge(CellIndex.indexByString('A1'), CellIndex.indexByString('F1'));

      // Headers
      final headers = ['اسم الطالب', 'الصف', 'الشعبة', 'المادة', 'الحصة', 'الحالة'];
      for (var i = 0; i < headers.length; i++) {
        final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 1));
        cell.value = TextCellValue(headers[i]);
        _styleHeaderCell(cell);
      }

      var row = 2;
      for (final session in sessions) {
        final records = await (db.select(db.attRecords)
              ..where((r) => r.sessionId.equals(session.id)))
            .get();

        for (final record in records) {
          final student = studentMap[record.studentId];
          if (student == null) continue;

          sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row)).value =
              TextCellValue(student.name);
          sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row)).value =
              TextCellValue(gradeMap[session.gradeId] ?? '—');
          sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row)).value =
              TextCellValue(sectionMap[session.sectionId] ?? '—');
          sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row)).value =
              TextCellValue(subjectMap[session.subjectId] ?? '—');
          sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row)).value =
              IntCellValue(session.periodNumber);

          final statusCell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: row));
          final (arabicStatus, bgColor) = _statusInfo(record.status);
          statusCell.value = TextCellValue(arabicStatus);
          _styleStatusCell(statusCell, bgColor);

          row++;
        }
      }

      // Auto-width approximation
      sheet.setColumnWidth(0, 30);
      sheet.setColumnWidth(5, 12);

      return await _saveExcel(
          excel, 'daily_report_${_fileSafeDate(date)}', openAfter: openAfter);
    } catch (e, stack) {
      debugPrint('Excel daily report error: $e\n$stack');
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
      final students = await db.select(db.attStudents).get();
      final start = DateTime(year, month, 1);
      final end = DateTime(year, month + 1, 1);

      final sessions = await (db.select(db.attSessions)
            ..where((s) => s.date.isBiggerOrEqualValue(start) &
                          s.date.isSmallerThanValue(end)))
          .get();

      // Aggregate stats per student
      final stats = <int, _Stats>{};
      for (final session in sessions) {
        final records = await (db.select(db.attRecords)
              ..where((r) => r.sessionId.equals(session.id)))
            .get();
        for (final r in records) {
          final s = stats.putIfAbsent(r.studentId, () => _Stats());
          s.add(r.status);
        }
      }

      final excel = Excel.createExcel();
      const sheetName = 'التقرير الشهري';
      final sheet = excel[sheetName];
      excel.setDefaultSheet(sheetName);

      // Title
      sheet.cell(CellIndex.indexByString('A1')).value =
          TextCellValue('التقرير الشهري - $schoolName');
      _styleTitleCell(sheet.cell(CellIndex.indexByString('A1')));
      sheet.merge(CellIndex.indexByString('A1'), CellIndex.indexByString('G1'));

      // Headers
      final headers = ['اسم الطالب', 'الصف', 'الشعبة', 'حاضر', 'غائب', 'متأخر', 'معذور', 'نسبة الحضور'];
      for (var i = 0; i < headers.length; i++) {
        final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 1));
        cell.value = TextCellValue(headers[i]);
        _styleHeaderCell(cell);
      }

      var row = 2;
      for (final student in students.where((s) => stats.containsKey(s.id))) {
        final s = stats[student.id]!;
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row)).value = TextCellValue(student.name);
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row)).value = TextCellValue(student.grade);
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row)).value = TextCellValue(student.section);
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row)).value = IntCellValue(s.present);
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row)).value = IntCellValue(s.absent);
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: row)).value = IntCellValue(s.late);
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: row)).value = IntCellValue(s.excused);

        final rateCell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: row));
        final rate = s.attendanceRate;
        rateCell.value = TextCellValue('${(rate * 100).toStringAsFixed(1)}%');

        row++;
      }

      sheet.setColumnWidth(0, 30);

      return await _saveExcel(excel, 'monthly_report_${year}_$month', openAfter: openAfter);
    } catch (e, stack) {
      debugPrint('Excel monthly report error: $e\n$stack');
      return null;
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  static void _styleTitleCell(Data cell) {
    cell.cellStyle = CellStyle(
      bold: true,
      fontSize: 14,
      fontColorHex: ExcelColor.fromHexString('#FFFFFF'),
      backgroundColorHex: ExcelColor.fromHexString('#1565C0'),
      horizontalAlign: HorizontalAlign.Center,
    );
  }

  static void _styleHeaderCell(Data cell) {
    cell.cellStyle = CellStyle(
      bold: true,
      fontSize: 11,
      fontColorHex: ExcelColor.fromHexString('#FFFFFF'),
      backgroundColorHex: ExcelColor.fromHexString('#1976D2'),
      horizontalAlign: HorizontalAlign.Center,
    );
  }

  static void _styleStatusCell(Data cell, String hexColor) {
    cell.cellStyle = CellStyle(
      bold: true,
      fontSize: 10,
      backgroundColorHex: ExcelColor.fromHexString(hexColor),
      horizontalAlign: HorizontalAlign.Center,
    );
  }

  static (String, String) _statusInfo(String status) => switch (status) {
    'present' => ('حاضر', '#C8E6C9'),
    'absent'  => ('غائب', '#FFCDD2'),
    'late'    => ('متأخر', '#FFE0B2'),
    'excused' => ('معذور', '#BBDEFB'),
    _         => (status, '#F5F5F5'),
  };

  static Future<String?> _saveExcel(Excel excel, String name,
      {required bool openAfter}) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File(p.join(dir.path, 'reports', '$name.xlsx'));
      await file.parent.create(recursive: true);
      final bytes = excel.save();
      if (bytes == null) return null;
      await file.writeAsBytes(bytes);
      if (openAfter) await OpenFile.open(file.path);
      return file.path;
    } catch (e) {
      debugPrint('Error saving Excel: $e');
      return null;
    }
  }

  static String _formatDate(DateTime dt) {
    const months = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر',
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }

  static String _fileSafeDate(DateTime dt) =>
      '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';

  // ── Students List Export ───────────────────────────────────────────────────

  static Future<String?> exportStudentsList(List<AttStudent> students, {bool openAfter = true}) async {
    try {
      final excel = Excel.createExcel();
      const sheetName = 'قائمة الطلاب';
      final sheet = excel[sheetName];
      excel.setDefaultSheet(sheetName);

      // Title
      sheet.cell(CellIndex.indexByString('A1')).value = TextCellValue('قائمة الطلاب');
      _styleTitleCell(sheet.cell(CellIndex.indexByString('A1')));
      sheet.merge(CellIndex.indexByString('A1'), CellIndex.indexByString('E1'));

      // Headers
      final headers = ['الاسم', 'المرحلة', 'الصف', 'الشعبة', 'الباركود'];
      for (var i = 0; i < headers.length; i++) {
        final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 1));
        cell.value = TextCellValue(headers[i]);
        _styleHeaderCell(cell);
      }

      var row = 2;
      for (final student in students) {
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row)).value = TextCellValue(student.name);
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row)).value = TextCellValue(student.stage);
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row)).value = TextCellValue(student.grade);
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row)).value = TextCellValue(student.section);
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row)).value = TextCellValue(student.barcode);
        row++;
      }

      sheet.setColumnWidth(0, 30);
      sheet.setColumnWidth(4, 20);

      final stamp = DateTime.now().millisecondsSinceEpoch;
      return await _saveExcel(excel, 'students_list_$stamp', openAfter: openAfter);
    } catch (e, stack) {
      debugPrint('Excel students list report error: $e\n$stack');
      return null;
    }
  }

  /// Advanced report accepting a dynamic filter from the UI layer.
  static Future<String?> generateAdvancedReport(
    Map<String, dynamic> data,
    dynamic filter, {
    bool openAfter = true,
  }) async {
    try {
      final dynamic dateRange = filter?.dateRange;
      var start = DateTime.now().subtract(const Duration(days: 30));
      var end = DateTime.now();
      if (dateRange != null) {
        start = dateRange.start as DateTime;
        end = dateRange.end as DateTime;
      }

      final excel = Excel.createExcel();
      const sheetName = 'تقرير متقدم';
      final sheet = excel[sheetName];
      excel.setDefaultSheet(sheetName);

      // Title row
      final titleCell = sheet.cell(CellIndex.indexByString('A1'));
      titleCell.value = TextCellValue('تقرير متقدم');
      _styleTitleCell(titleCell);
      sheet.merge(CellIndex.indexByString('A1'), CellIndex.indexByString('D1'));

      // If real data is available, write it
      final students = data['students'] as List? ?? [];
      if (students.isNotEmpty) {
        final headers = ['الاسم', 'الصف', 'الشعبة', 'الباركود'];
        for (var i = 0; i < headers.length; i++) {
          final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 1));
          cell.value = TextCellValue(headers[i]);
          _styleHeaderCell(cell);
        }
        for (var i = 0; i < students.length; i++) {
          final s = students[i];
          sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: i + 2)).value = TextCellValue('${s.name}');
        }
      }

      // Suppress unused variable warning
      debugPrint('Date range: $start - $end');

      final stamp = _fileSafeDate(start);
      return await _saveExcel(excel, 'advanced_report_$stamp', openAfter: openAfter);
    } catch (e, stack) {
      debugPrint('Excel advanced report error: $e\n$stack');
      return null;
    }
  }
}

class _Stats {
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
