import 'package:equatable/equatable.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final int teacherCount;
  final int classroomCount;
  final int subjectCount;
  final int todaySessions;
  final int totalStudents;
  final double todayAttendanceRate;
  final String? schoolName;
  final String? academicYear;

  const DashboardLoaded({
    required this.teacherCount,
    required this.classroomCount,
    required this.subjectCount,
    this.todaySessions = 0,
    this.totalStudents = 0,
    this.todayAttendanceRate = 0.0,
    this.schoolName,
    this.academicYear,
  });

  @override
  List<Object?> get props => [
        teacherCount,
        classroomCount,
        subjectCount,
        todaySessions,
        totalStudents,
        todayAttendanceRate,
        schoolName,
        academicYear,
      ];
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);

  @override
  List<Object> get props => [message];
}
