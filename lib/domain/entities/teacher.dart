import 'package:equatable/equatable.dart';
import 'enums.dart';

class Teacher extends Equatable {
  final String id;
  final String fullName;
  final String qualification;
  final String specialization;
  final String phone;
  final String email;
  final int maxWeeklyHours;
  final int maxDailyHours;
  final Map<WorkDay, List<int>> unavailablePeriods;
  final List<String> subjectIds;
  final List<String> classIds;
  final TeacherType type;
  final List<WorkDay> workDays; // أيام عمل المعلم (افتراضياً جميع الأيام)

  const Teacher({
    required this.id,
    required this.fullName,
    required this.qualification,
    required this.specialization,
    required this.phone,
    required this.email,
    required this.maxWeeklyHours,
    required this.maxDailyHours,
    required this.unavailablePeriods,
    required this.subjectIds,
    required this.classIds,
    required this.type,
    this.workDays = const [
      WorkDay.saturday,
      WorkDay.sunday,
      WorkDay.monday,
      WorkDay.tuesday,
      WorkDay.wednesday,
      WorkDay.thursday,
    ],
  });

  @override
  List<Object?> get props => [
        id,
        fullName,
        qualification,
        specialization,
        phone,
        email,
        maxWeeklyHours,
        maxDailyHours,
        unavailablePeriods,
        subjectIds,
        classIds,
        type,
        workDays,
      ];
}
