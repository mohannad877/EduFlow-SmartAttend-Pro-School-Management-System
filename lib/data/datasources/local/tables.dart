import 'package:drift/drift.dart';
import 'package:school_schedule_app/domain/entities/enums.dart';
import 'converters.dart';

@DataClassName("SchoolDto")
class SchoolsTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get address => text()();
  TextColumn get phone => text()();
  TextColumn get email => text()();
  IntColumn get dailySessions => integer()();
  TextColumn get workDays => text().map(const WorkDayListConverter())();
  // Store TimeOfDay as minutes from midnight
  IntColumn get firstSessionTime => integer()();
  IntColumn get sessionDuration => integer()();
  TextColumn get academicYear => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName("TeacherDto")
class TeachersTable extends Table {
  TextColumn get id => text()();
  TextColumn get fullName => text()();
  TextColumn get qualification => text().nullable()();
  TextColumn get specialization => text()();
  TextColumn get phone => text()();
  TextColumn get email => text().nullable()();
  IntColumn get maxWeeklyHours => integer()();
  IntColumn get maxDailyHours => integer()();
  // Using JSON converter for Map
  TextColumn get unavailablePeriods =>
      text().map(const IntListMapConverter())();
  TextColumn get subjectIds => text().map(const StringListConverter())();
  TextColumn get classIds => text().map(const StringListConverter())();
  IntColumn get type => intEnum<TeacherType>()();
  TextColumn get workDays => text()
      .map(const WorkDayListConverter())
      .withDefault(const Constant('[]'))(); // أيام العمل

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName("SubjectDto")
class SubjectsTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get code => text().nullable()();
  IntColumn get priority => intEnum<SubjectPriority>()();
  IntColumn get weeklyHours => integer().withDefault(const Constant(0))();
  TextColumn get classPeriods => text()
      .map(const StringIntMapConverter())
      .withDefault(const Constant('{}'))();
  IntColumn get color => integer()(); // Store color value
  BoolColumn get requiresLab => boolean().withDefault(const Constant(false))();
  BoolColumn get requiresProjector =>
      boolean().withDefault(const Constant(false))();
  TextColumn get qualifiedTeacherIds =>
      text().map(const StringListConverter())();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName("ClassroomDto")
class ClassroomsTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get section => text()();
  IntColumn get studentCount => integer()();
  TextColumn get roomNumber => text()();
  IntColumn get level => intEnum<ClassLevel>()();
  TextColumn get supervisorId => text().nullable()();
  TextColumn get subjectIds =>
      text().map(const StringListConverter()).withDefault(const Constant('[]'))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName("SessionDto")
class SessionsTable extends Table {
  TextColumn get id => text()();
  IntColumn get day => intEnum<WorkDay>()();
  IntColumn get sessionNumber => integer()();
  TextColumn get classId => text().references(ClassroomsTable, #id)();
  TextColumn get teacherId => text().references(TeachersTable, #id)();
  TextColumn get subjectId => text().references(SubjectsTable, #id)();
  TextColumn get roomId =>
      text()(); // Can be classroom roomNumber or specific Lab ID
  IntColumn get status => intEnum<SessionStatus>()();
  DateTimeColumn get actualDate => dateTime().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get scheduleId => text().references(SchedulesTable, #id)();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName("ScheduleDto")
class SchedulesTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  DateTimeColumn get creationDate => dateTime()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  TextColumn get schoolId => text().references(SchoolsTable, #id)();
  TextColumn get creatorId => text()();
  IntColumn get status => intEnum<ScheduleStatus>()();
  // Metadata as JSON string if needed, or separate columns
  TextColumn get metadata => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
