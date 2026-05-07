import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_schedule_app/core/database/attendance_providers.dart';
import 'package:school_schedule_app/core/utils/app_helpers.dart';

// ============================================================================
// Student Repository — يعمل مع AttendanceDatabase
// ============================================================================

/// يُدار الـ studentRepositoryProvider من attendance_providers.dart
/// هذا الملف يوفر واجهة عالية المستوى للـ presentation layer

class StudentRepository {
  final AttendanceDatabase _db;

  StudentRepository(this._db);

  Future<List<AttStudent>> getAllStudents() async {
    return (_db.select(_db.attStudents)
          ..where((s) => s.isActive.equals(true))
          ..orderBy([(s) => OrderingTerm.asc(s.name)]))
        .get();
  }

  Future<List<AttStudent>> getStudentsByFilter({
    String? stage,
    String? grade,
    String? section,
    String? searchQuery,
  }) async {
    var query = _db.select(_db.attStudents)..where((s) => s.isActive.equals(true));
    if (stage != null && stage.isNotEmpty) query = query..where((s) => s.stage.equals(stage));
    if (grade != null && grade.isNotEmpty) query = query..where((s) => s.grade.equals(grade));
    if (section != null && section.isNotEmpty) query = query..where((s) => s.section.equals(section));
    if (searchQuery != null && searchQuery.isNotEmpty) {
      query = query..where((s) => s.name.like('%$searchQuery%') | s.barcode.like('%$searchQuery%'));
    }
    return (query..orderBy([(s) => OrderingTerm.asc(s.name)])).get();
  }

  Future<AttStudent?> getStudentById(int id) {
    return (_db.select(_db.attStudents)..where((s) => s.id.equals(id))).getSingleOrNull();
  }

  Future<AttStudent?> getStudentByBarcode(String barcode) {
    return (_db.select(_db.attStudents)..where((s) => s.barcode.equals(barcode))).getSingleOrNull();
  }

  Future<int> addStudent({
    required String name,
    required String stage,
    required String grade,
    required String section,
    String? barcode,
    String? notes,
  }) {
    final code = barcode ?? BarcodeUtils.generateBarcode();
    return _db.into(_db.attStudents).insert(AttStudentsCompanion.insert(
          name: name,
          stage: stage,
          grade: grade,
          section: section,
          barcode: code,
          notes: Value(notes),
        ));
  }

  Future<List<int>> addMultipleStudents(List<Map<String, String>> studentsData) async {
    final ids = <int>[];
    await _db.transaction(() async {
      for (final data in studentsData) {
        final id = await addStudent(
          name: data['name']!,
          stage: data['stage'] ?? '',
          grade: data['grade'] ?? '',
          section: data['section'] ?? '',
        );
        ids.add(id);
      }
    });
    return ids;
  }

  Future<bool> updateStudent(AttStudent student) {
    return _db.update(_db.attStudents).replace(student);
  }

  Future<bool> deleteStudent(int id) async {
    final deleted = await (_db.delete(_db.attStudents)..where((s) => s.id.equals(id))).go();
    return deleted > 0;
  }

  Future<int> deleteMultipleStudents(List<int> ids) {
    return (_db.delete(_db.attStudents)..where((s) => s.id.isIn(ids))).go();
  }

  Future<int> getStudentsCount({String? stage, String? grade, String? section}) async {
    final list = await getStudentsByFilter(stage: stage, grade: grade, section: section);
    return list.length;
  }

  Future<bool> isBarcodeExists(String barcode) async {
    final s = await getStudentByBarcode(barcode);
    return s != null;
  }

  Future<String> regenerateBarcode(int studentId) async {
    String code;
    do {
      code = BarcodeUtils.generateBarcode();
    } while (await isBarcodeExists(code));
    await (_db.update(_db.attStudents)..where((s) => s.id.equals(studentId)))
        .write(AttStudentsCompanion(barcode: Value(code)));
    return code;
  }
}

// ============================================================================
// Provider — اسم خاص بـ domain layer لتجنب التعارض مع attendance_providers.dart
// ============================================================================

final studentRepositoryProvider = Provider<StudentRepository>((ref) {
  return StudentRepository(ref.watch(attendanceDatabaseProvider));
});
