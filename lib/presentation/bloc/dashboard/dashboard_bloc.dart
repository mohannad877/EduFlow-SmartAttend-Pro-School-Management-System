import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:school_schedule_app/domain/repositories/i_teacher_repository.dart';
import 'package:school_schedule_app/domain/repositories/i_classroom_repository.dart';
import 'package:school_schedule_app/domain/repositories/i_subject_repository.dart';
import 'package:school_schedule_app/domain/repositories/i_school_repository.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

@injectable
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final ITeacherRepository _teacherRepository;
  final IClassroomRepository _classroomRepository;
  final ISubjectRepository _subjectRepository;
  final ISchoolRepository _schoolRepository;

  DashboardBloc(
    this._teacherRepository,
    this._classroomRepository,
    this._subjectRepository,
    this._schoolRepository,
  ) : super(DashboardInitial()) {
    on<LoadDashboardStats>(_onLoadDashboardStats);
  }

  Future<void> _onLoadDashboardStats(
    LoadDashboardStats event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());
    try {
      final teachers = await _teacherRepository.getTeachers();
      final classrooms = await _classroomRepository.getClassrooms();
      final subjects = await _subjectRepository.getSubjects();
      final school = await _schoolRepository.getSchool();

      var studentCount = 0;
      var attendanceRate = 0.0;

      if (event.attendanceDb != null) {
        try {
          final db = event.attendanceDb; // Dynamic AttendanceDatabase
          final students = await db.select(db.attStudents).get();
          studentCount = students.length;

          // calculate today's attendance rate
          final now = DateTime.now();
          final startOfDay = DateTime(now.year, now.month, now.day);
          final endOfDay = startOfDay.add(const Duration(days: 1));
          
          final sessions = await (db.select(db.attSessions)..where((s) => s.date.isBetweenValues(startOfDay, endOfDay))).get();
          
          var totalRecords = 0;
          var presentCount = 0;

          for (final s in sessions) {
             final records = await (db.select(db.attRecords)..where((r) => r.sessionId.equals(s.id))).get();
             for (final r in records) {
               totalRecords++;
               if (r.status == 'present') presentCount++;
             }
          }

          if (totalRecords > 0) {
            attendanceRate = presentCount / totalRecords;
          }
        } catch (_) {}
      }

      emit(DashboardLoaded(
        teacherCount: teachers.length,
        classroomCount: classrooms.length,
        subjectCount: subjects.length,
        totalStudents: studentCount,
        todayAttendanceRate: attendanceRate,
        schoolName: school?.name,
        academicYear: school?.academicYear,
      ));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }
}
