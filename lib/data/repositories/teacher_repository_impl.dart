import 'package:injectable/injectable.dart';
import 'package:school_schedule_app/domain/entities/teacher.dart';
import 'package:school_schedule_app/domain/repositories/i_teacher_repository.dart';
import 'package:school_schedule_app/data/datasources/local/app_database.dart';
import 'package:school_schedule_app/data/models/mappers.dart';

@LazySingleton(as: ITeacherRepository)
class TeacherRepositoryImpl implements ITeacherRepository {
  final AppDatabase _db;

  TeacherRepositoryImpl(this._db);

  @override
  Future<void> deleteTeacher(String id) {
    return (_db.delete(_db.teachersTable)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<Teacher?> getTeacherById(String id) async {
    final query = _db.select(_db.teachersTable)..where((t) => t.id.equals(id));
    final result = await query.getSingleOrNull();
    return result?.toDomain();
  }

  @override
  Future<List<Teacher>> getTeachers() async {
    final result = await _db.select(_db.teachersTable).get();
    return result.map((e) => e.toDomain()).toList();
  }

  @override
  Future<List<Teacher>> getTeachersByIds(List<String> ids) async {
    final all = await getTeachers();
    return all.where((t) => ids.contains(t.id)).toList();
  }

  @override
  Future<void> saveTeacher(Teacher teacher) {
    return _db.into(_db.teachersTable).insertOnConflictUpdate(teacher.toDto());
  }
}
