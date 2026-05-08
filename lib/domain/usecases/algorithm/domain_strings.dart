import 'package:meta/meta.dart';

class DomainStrings {
  static ValidationStrings validation = const ValidationStrings();
  static GeneratorStrings generator = const GeneratorStrings();
}

@immutable
class ValidationStrings {
  final String day;
  final String hour;
  final String minute;
  final String second;
  final String morning;
  final String afternoon;
  final String evening;
  final String night;
  final String today;
  final String tomorrow;
  final String yesterday;
  final String thisWeek;
  final String thisMonth;
  final String thisYear;
  final String lastWeek;
  final String lastMonth;
  final String lastYear;
  final String nextWeek;
  final String nextMonth;
  final String nextYear;
  final String daily;
  final String weekly;
  final String monthly;
  final String yearly;
  final String generateSchedule;
  final String validateSchedule;
  final String clearSchedule;
  final String exportPdf;
  final String exportExcel;
  final String printSchedule;
  final String addTeacher;
  final String editTeacher;
  final String deleteTeacher;
  final String teacherDetails;
  final String fullName;
  final String specialization;
  final String maxWeeklyHours;
  final String maxDailyHours;
  final String noTeachersFound;
  final String addClassroom;
  final String editClassroom;
  final String deleteClassroom;
  final String classroomName;

  const ValidationStrings({
    this.day = '',
    this.hour = '',
    this.minute = '',
    this.second = '',
    this.morning = '',
    this.afternoon = '',
    this.evening = '',
    this.night = '',
    this.today = '',
    this.tomorrow = '',
    this.yesterday = '',
    this.thisWeek = '',
    this.thisMonth = '',
    this.thisYear = '',
    this.lastWeek = '',
    this.lastMonth = '',
    this.lastYear = '',
    this.nextWeek = '',
    this.nextMonth = '',
    this.nextYear = '',
    this.daily = '',
    this.weekly = '',
    this.monthly = '',
    this.yearly = '',
    this.generateSchedule = '',
    this.validateSchedule = '',
    this.clearSchedule = '',
    this.exportPdf = '',
    this.exportExcel = '',
    this.printSchedule = '',
    this.addTeacher = '',
    this.editTeacher = '',
    this.deleteTeacher = '',
    this.teacherDetails = '',
    this.fullName = '',
    this.specialization = '',
    this.maxWeeklyHours = '',
    this.maxDailyHours = '',
    this.noTeachersFound = '',
    this.addClassroom = '',
    this.editClassroom = '',
    this.deleteClassroom = '',
    this.classroomName = '',
  });
}

@immutable
class GeneratorStrings {
  final String initializing;
  final String loadingData;
  final String preprocessing;
  final String generating;
  final String optimizing;
  final String validating;
  final String finishing;
  final String completed;
  final String classrooms;
  final String subjects;
  final String grades;
  final String saving;
  final String failed;
  final String cancelled;
  final String timeout;
  final String noData;
  final String error;

  const GeneratorStrings({
    this.initializing = '',
    this.loadingData = '',
    this.preprocessing = '',
    this.generating = '',
    this.optimizing = '',
    this.validating = '',
    this.finishing = '',
    this.completed = '',
    this.classrooms = '',
    this.subjects = '',
    this.grades = '',
    this.saving = '',
    this.failed = '',
    this.cancelled = '',
    this.timeout = '',
    this.noData = '',
    this.error = '',
  });
}
