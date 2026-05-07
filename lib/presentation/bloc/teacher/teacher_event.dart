import 'package:equatable/equatable.dart';
import 'package:school_schedule_app/domain/entities/teacher.dart';

abstract class TeacherEvent extends Equatable {
  const TeacherEvent();

  @override
  List<Object?> get props => [];
}

class LoadTeachers extends TeacherEvent {}

class LoadTeacherDetail extends TeacherEvent {
  final String id;
  const LoadTeacherDetail(this.id);
  @override
  List<Object?> get props => [id];
}

class AddTeacher extends TeacherEvent {
  final Teacher teacher;
  const AddTeacher(this.teacher);
  @override
  List<Object?> get props => [teacher];
}

class UpdateTeacher extends TeacherEvent {
  final Teacher teacher;
  const UpdateTeacher(this.teacher);
  @override
  List<Object?> get props => [teacher];
}

class DeleteTeacher extends TeacherEvent {
  final String id;
  const DeleteTeacher(this.id);
  @override
  List<Object?> get props => [id];
}
