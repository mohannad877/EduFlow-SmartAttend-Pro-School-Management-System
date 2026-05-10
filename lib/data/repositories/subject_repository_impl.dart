import 'package:injectable/injectable.dart';
import 'package:school_schedule_app/domain/entities/subject.dart';
import 'package:school_schedule_app/domain/repositories/i_subject_repository.dart';
import 'package:school_schedule_app/data/datasources/local/app_database.dart';
import 'package:school_schedule_app/data/models/mappers.dart';

@LazySingleton(as: ISubjectRepository)
class SubjectRepositoryImpl implements ISubjectRepository {
  final AppDatabase _db;

  SubjectRepositoryImpl(this._db);

  @override
  Future<void> deleteSubject(String id) async {
    await _db.transaction(() async {
      // Cascade: حذف الحصص المرتبطة بهذه المادة
      await (_db.delete(_db.sessionsTable)
            ..where((t) => t.subjectId.equals(id)))
          .go();
          
      // Data Integrity: إزالة المادة من قوائم المعلمين
      final teachers = await _db.select(_db.teachersTable).get();
      for (final teacher in teachers) {
        if (teacher.subjectIds.contains(id)) {
          final updatedSubjectIds = List<String>.from(teacher.subjectIds)..remove(id);
          await _db.update(_db.teachersTable).replace(
            teacher.copyWith(subjectIds: updatedSubjectIds)
          );
        }
      }
      
      // ثم حذف المادة
      await (_db.delete(_db.subjectsTable)..where((t) => t.id.equals(id)))
          .go();
    });
  }

  @override
  Future<Subject?> getSubjectById(String id) async {
    final query = _db.select(_db.subjectsTable)..where((t) => t.id.equals(id));
    final result = await query.getSingleOrNull();
    return result?.toDomain();
  }

  @override
  Future<List<Subject>> getSubjects() async {
    final result = await _db.select(_db.subjectsTable).get();
    return result.map((e) => e.toDomain()).toList();
  }

  @override
  Future<List<Subject>> getSubjectsByIds(List<String> ids) async {
    final all = await getSubjects();
    return all.where((s) => ids.contains(s.id)).toList();
  }

  @override
  Future<void> saveSubject(Subject subject) {
    return _db.into(_db.subjectsTable).insertOnConflictUpdate(subject.toDto());
  }
}
