import 'package:injectable/injectable.dart';
import 'package:school_schedule_app/domain/entities/school.dart';
import 'package:school_schedule_app/domain/repositories/i_school_repository.dart';
import 'package:school_schedule_app/data/datasources/local/app_database.dart';
import 'package:school_schedule_app/data/models/mappers.dart';

@LazySingleton(as: ISchoolRepository)
class SchoolRepositoryImpl implements ISchoolRepository {
  final AppDatabase _db;

  SchoolRepositoryImpl(this._db);

  @override
  Future<School?> getSchool() async {
    final result = await _db.select(_db.schoolsTable).getSingleOrNull();
    return result?.toDomain();
  }

  @override
  Future<void> saveSchool(School school) {
    return _db.into(_db.schoolsTable).insertOnConflictUpdate(school.toDto());
  }
}
