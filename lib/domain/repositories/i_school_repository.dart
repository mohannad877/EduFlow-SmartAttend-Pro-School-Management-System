import 'package:school_schedule_app/domain/entities/school.dart';

abstract class ISchoolRepository {
  Future<School?> getSchool();
  Future<void> saveSchool(School school);
}
