import 'package:school_schedule_app/domain/entities/classroom.dart';

abstract class IClassroomRepository {
  Future<List<Classroom>> getClassrooms();
  Future<Classroom?> getClassroomById(String id);
  Future<void> saveClassroom(Classroom classroom);
  Future<void> deleteClassroom(String id);
  Future<List<Classroom>> getClassroomsByIds(List<String> ids) async {
    final all = await getClassrooms();
    return all.where((c) => ids.contains(c.id)).toList();
  }
}
