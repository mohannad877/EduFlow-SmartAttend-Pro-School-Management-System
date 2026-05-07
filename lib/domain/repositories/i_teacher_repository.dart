import 'package:school_schedule_app/domain/entities/teacher.dart';

abstract class ITeacherRepository {
  Future<List<Teacher>> getTeachers();
  Future<Teacher?> getTeacherById(String id);
  Future<void> saveTeacher(Teacher teacher);
  Future<void> deleteTeacher(String id);
  Future<List<Teacher>> getTeachersByIds(List<String> ids) async {
    final all = await getTeachers();
    return all.where((t) => ids.contains(t.id)).toList();
  }
}
