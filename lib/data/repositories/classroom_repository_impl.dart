import 'package:injectable/injectable.dart';
import 'package:school_schedule_app/domain/entities/classroom.dart';
import 'package:school_schedule_app/domain/entities/subject.dart';
import 'package:school_schedule_app/domain/repositories/i_classroom_repository.dart';
import 'package:school_schedule_app/data/datasources/local/app_database.dart';
import 'package:school_schedule_app/data/models/mappers.dart';

@LazySingleton(as: IClassroomRepository)
class ClassroomRepositoryImpl implements IClassroomRepository {
  final AppDatabase _db;

  ClassroomRepositoryImpl(this._db);

  @override
  Future<void> deleteClassroom(String id) {
    return (_db.delete(_db.classroomsTable)..where((t) => t.id.equals(id)))
        .go();
  }

  @override
  Future<Classroom?> getClassroomById(String id) async {
    final query = _db.select(_db.classroomsTable)
      ..where((t) => t.id.equals(id));
    final result = await query.getSingleOrNull();
    if (result == null) return null;

    final subjects = await _getSubjectsForClassroom(result.subjectIds);
    return result.toDomain(subjects: subjects);
  }

  @override
  Future<List<Classroom>> getClassrooms() async {
    final results = await _db.select(_db.classroomsTable).get();
    final List<Classroom> classrooms = [];
    
    for (final result in results) {
      final subjects = await _getSubjectsForClassroom(result.subjectIds);
      classrooms.add(result.toDomain(subjects: subjects));
    }
    
    return classrooms;
  }

  Future<List<Subject>> _getSubjectsForClassroom(List<String> ids) async {
    if (ids.isEmpty) return [];
    final query = _db.select(_db.subjectsTable)..where((t) => t.id.isIn(ids));
    final results = await query.get();
    return results.map((e) => e.toDomain()).toList();
  }

  @override
  Future<List<Classroom>> getClassroomsByIds(List<String> ids) async {
    final query = _db.select(_db.classroomsTable)..where((t) => t.id.isIn(ids));
    final results = await query.get();
    final List<Classroom> classrooms = [];
    
    for (final result in results) {
      final subjects = await _getSubjectsForClassroom(result.subjectIds);
      classrooms.add(result.toDomain(subjects: subjects));
    }
    
    return classrooms;
  }

  @override
  Future<void> saveClassroom(Classroom classroom) {
    return _db
        .into(_db.classroomsTable)
        .insertOnConflictUpdate(classroom.toDto());
  }
}
