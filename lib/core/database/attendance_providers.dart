import 'package:school_schedule_app/core/navigation/app_router.dart';
import 'package:school_schedule_app/core/utils/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import 'attendance_database.dart';

export 'attendance_database.dart';

// ============================================================================
// DATABASE PROVIDER
// ============================================================================

final attendanceDatabaseProvider = Provider<AttendanceDatabase>((ref) {
  final db = AttendanceDatabase();
  ref.onDispose(() => db.close());
  return db;
});

// ============================================================================
// AUTH STATE & NOTIFIER
// ============================================================================

class AuthState {
  final AttUser? user;
  final bool isLoading;
  final String? error;

  const AuthState({this.user, this.isLoading = false, this.error});

  AuthState copyWith({AttUser? user, bool? isLoading, String? error, bool clearError = false}) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }

  bool get isAuthenticated => user != null;
  bool get isAdmin => user?.role == 'admin';
  bool get isTeacher => user?.role == 'teacher';
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AttendanceDatabase _db;

  AuthNotifier(this._db) : super(const AuthState());

  Future<bool> login(String username, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final users = await (_db.select(_db.attUsers)
            ..where((u) => u.username.equals(username) & u.isActive.equals(true)))
          .get();

      if (users.isEmpty) {
        state = state.copyWith(isLoading: false, error: AppNavigator.navigatorKey.currentContext!.l10n.errorLoadingData);
        return false;
      }

      final user = users.first;
      final hashedInput = AttendanceDatabase.hashPasswordStatic(password);
      if (user.passwordHash != hashedInput) {
        state = state.copyWith(isLoading: false, error: AppNavigator.navigatorKey.currentContext!.l10n.invalidPassword);
        return false;
      }

      await (_db.update(_db.attUsers)..where((u) => u.id.equals(user.id)))
          .write(AttUsersCompanion(lastLogin: Value(DateTime.now())));

      state = state.copyWith(user: user, isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  void logout() => state = const AuthState();
}

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(attendanceDatabaseProvider));
});

// ============================================================================
// THEME MODE
// ============================================================================

final attendanceThemeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.light);

// ============================================================================
// STUDENT FILTER PARAMS
// ============================================================================

class StudentFilterParams {
  final String? stage;
  final String? grade;
  final String? section;
  final String? searchQuery;
  final String? sortBy;

  const StudentFilterParams({this.stage, this.grade, this.section, this.searchQuery, this.sortBy});

  StudentFilterParams copyWith({
    String? stage,
    String? grade,
    String? section,
    String? searchQuery,
    String? sortBy,
    bool clearStage = false,
    bool clearGrade = false,
    bool clearSection = false,
    bool clearSearch = false,
  }) {
    return StudentFilterParams(
      stage: clearStage ? null : (stage ?? this.stage),
      grade: clearGrade ? null : (grade ?? this.grade),
      section: clearSection ? null : (section ?? this.section),
      searchQuery: clearSearch ? null : (searchQuery ?? this.searchQuery),
      sortBy: sortBy ?? this.sortBy,
    );
  }

  bool get hasFilter =>
      stage != null || grade != null || section != null || (searchQuery?.isNotEmpty ?? false);
}

final currentStudentFilterProvider = StateProvider<StudentFilterParams?>((ref) => null);

// ============================================================================
// STUDENTS PROVIDERS
// ============================================================================

final filteredStudentsProvider =
    FutureProvider.family<List<AttStudent>, StudentFilterParams?>((ref, filter) async {
  final db = ref.watch(attendanceDatabaseProvider);
  var query = db.select(db.attStudents)..where((s) => s.isActive.equals(true));

  if (filter != null) {
    if (filter.stage != null) query = query..where((s) => s.stage.equals(filter.stage!));
    if (filter.grade != null) query = query..where((s) => s.grade.equals(filter.grade!));
    if (filter.section != null) query = query..where((s) => s.section.equals(filter.section!));
    if (filter.searchQuery?.isNotEmpty ?? false) {
      query = query..where((s) => s.name.like('%${filter.searchQuery!}%'));
    }
  }

  if (filter?.sortBy == 'date') {
    query = query..orderBy([(s) => OrderingTerm.desc(s.createdAt)]);
  } else if (filter?.sortBy == 'barcode') {
    query = query..orderBy([(s) => OrderingTerm.asc(s.barcode)]);
  } else {
    query = query..orderBy([(s) => OrderingTerm.asc(s.name)]);
  }

  return query.get();
});

final studentsCountProvider = FutureProvider<int>((ref) async {
  final filter = ref.watch(currentStudentFilterProvider);
  final students = await ref.watch(filteredStudentsProvider(filter).future);
  return students.length;
});

// ============================================================================
// STAGES / GRADES / SECTIONS / SUBJECTS
// ============================================================================

final stagesProvider = FutureProvider<List<AttStage>>((ref) async {
  final db = ref.watch(attendanceDatabaseProvider);
  return (db.select(db.attStages)..orderBy([(s) => OrderingTerm.asc(s.sortOrder)])).get();
});

final gradesProvider = FutureProvider.family<List<AttGrade>, int>((ref, stageId) async {
  final db = ref.watch(attendanceDatabaseProvider);
  return (db.select(db.attGrades)
        ..where((g) => g.stageId.equals(stageId))
        ..orderBy([(g) => OrderingTerm.asc(g.sortOrder)]))
      .get();
});

final sectionsProvider = FutureProvider.family<List<AttSection>, int>((ref, gradeId) async {
  final db = ref.watch(attendanceDatabaseProvider);
  return (db.select(db.attSections)
        ..where((s) => s.gradeId.equals(gradeId))
        ..orderBy([(s) => OrderingTerm.asc(s.sortOrder)]))
      .get();
});

final attSubjectsProvider = FutureProvider.family<List<AttSubject>, int>((ref, gradeId) async {
  final db = ref.watch(attendanceDatabaseProvider);
  return (db.select(db.attSubjects)
        ..where((s) => s.gradeId.equals(gradeId) & s.isActive.equals(true)))
      .get();
});

// ============================================================================
// SETTINGS
// ============================================================================

final attSettingsProvider = FutureProvider<Map<String, String>>((ref) async {
  final db = ref.watch(attendanceDatabaseProvider);
  final settings = await db.select(db.attSettings).get();
  return Map.fromEntries(settings.map((s) => MapEntry(s.key, s.value)));
});

final attSchoolNameProvider = FutureProvider<String>((ref) async {
  final settings = await ref.watch(attSettingsProvider.future);
  return settings['school_name'] ?? AppNavigator.navigatorKey.currentContext!.l10n.schoolName;
});

// ============================================================================
// ATTENDANCE WITH STUDENT
// ============================================================================

class AttendanceWithStudent {
  final AttRecord attendance;
  final AttStudent student;
  const AttendanceWithStudent({required this.attendance, required this.student});
}

final sessionAttendanceProvider =
    FutureProvider.family<List<AttendanceWithStudent>, int>((ref, sessionId) async {
  final db = ref.watch(attendanceDatabaseProvider);
  final records = await (db.select(db.attRecords)
        ..where((a) => a.sessionId.equals(sessionId)))
      .get();

  final result = <AttendanceWithStudent>[];
  for (final rec in records) {
    final student = await (db.select(db.attStudents)..where((s) => s.id.equals(rec.studentId)))
        .getSingleOrNull();
    if (student != null) result.add(AttendanceWithStudent(attendance: rec, student: student));
  }
  return result;
});

// ============================================================================
// STUDENT DATA REPOSITORY
// ============================================================================

class StudentDataRepository {
  final AttendanceDatabase _db;
  StudentDataRepository(this._db);

  Future<int> addStudent({
    required String name,
    required String stage,
    required String grade,
    required String section,
    required String barcode,
    String? notes,
  }) {
    return _db.into(_db.attStudents).insert(AttStudentsCompanion.insert(
          name: name,
          stage: stage,
          grade: grade,
          section: section,
          barcode: barcode,
          notes: Value(notes),
        ));
  }

  Future<bool> updateStudent(AttStudent student) {
    return _db.update(_db.attStudents).replace(student);
  }

  Future<int> deleteStudent(int id) {
    return (_db.delete(_db.attStudents)..where((s) => s.id.equals(id))).go();
  }

  Future<int> deleteMultipleStudents(List<int> ids) {
    return (_db.delete(_db.attStudents)..where((s) => s.id.isIn(ids))).go();
  }

  Future<AttStudent?> findByBarcode(String barcode) {
    return (_db.select(_db.attStudents)..where((s) => s.barcode.equals(barcode)))
        .getSingleOrNull();
  }
}

final attStudentRepositoryProvider = Provider<StudentDataRepository>((ref) {
  return StudentDataRepository(ref.watch(attendanceDatabaseProvider));
});
