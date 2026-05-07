import 'package:school_schedule_app/domain/entities/subject.dart';

abstract class ISubjectRepository {
  Future<List<Subject>> getSubjects();
  Future<Subject?> getSubjectById(String id);
  Future<void> saveSubject(Subject subject);
  Future<void> deleteSubject(String id);
  Future<List<Subject>> getSubjectsByIds(List<String> ids) async {
    final all = await getSubjects();
    return all.where((s) => ids.contains(s.id)).toList();
  }
}
