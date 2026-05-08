import 'package:school_schedule_app/core/navigation/app_router.dart';
import 'package:school_schedule_app/core/utils/l10n_extension.dart';
import 'package:drift/drift.dart';
import 'package:school_schedule_app/core/database/attendance_database.dart';

class ComparativeReportService {
  final AttendanceDatabase db;

  ComparativeReportService(this.db);

  /// قارن بين مجموعتين (مثلاً شعبتين أو صفين) من حيث نسبة الحضور
  Future<Map<String, double>> compareGroups({
    required List<int> studentIdsGroupA,
    required List<int> studentIdsGroupB,
    required String labelA,
    required String labelB,
  }) async {
    final rateA = await _calculateAttendanceRate(studentIdsGroupA);
    final rateB = await _calculateAttendanceRate(studentIdsGroupB);

    return {
      labelA: rateA,
      labelB: rateB,
    };
  }

  /// قارن بين شعبتين في نفس الصف
  Future<Map<String, double>> compareSections({
    required String grade,
    required String sectionA,
    required String sectionB,
  }) async {
    final studentsA = await (db.select(db.attStudents)
          ..where((s) => s.grade.equals(grade) & s.section.equals(sectionA)))
        .get();
        
    final studentsB = await (db.select(db.attStudents)
          ..where((s) => s.grade.equals(grade) & s.section.equals(sectionB)))
        .get();

    return compareGroups(
      studentIdsGroupA: studentsA.map((s) => s.id).toList(),
      studentIdsGroupB: studentsB.map((s) => s.id).toList(),
      labelA: AppNavigator.navigatorKey.currentContext!.l10n.name,
      labelB: AppNavigator.navigatorKey.currentContext!.l10n.email,
    );
  }

  /// جلب تقرير تفصيلي لكل الشعب في صف معين
  Future<Map<String, double>> getClassBreakdown(String grade) async {
    final students = await (db.select(db.attStudents)
          ..where((s) => s.grade.equals(grade)))
        .get();

    final sections = <String, List<int>>{};
    for (var s in students) {
      sections.putIfAbsent(s.section, () => []).add(s.id);
    }

    final results = <String, double>{};
    for (var entry in sections.entries) {
      results[entry.key] = await _calculateAttendanceRate(entry.value);
    }

    return results;
  }

  Future<double> _calculateAttendanceRate(List<int> studentIds) async {
    if (studentIds.isEmpty) return 0.0;

    final records = await (db.select(db.attRecords)
          ..where((r) => r.studentId.isIn(studentIds)))
        .get();

    if (records.isEmpty) return 0.0;

    final presentCount = records.where((r) => r.status == 'present').length;
    return (presentCount / records.length) * 100;
  }
}
