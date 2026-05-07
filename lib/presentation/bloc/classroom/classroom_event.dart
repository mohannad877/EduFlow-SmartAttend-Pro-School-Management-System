import 'package:equatable/equatable.dart';
import 'package:school_schedule_app/domain/entities/classroom.dart';

abstract class ClassroomEvent extends Equatable {
  const ClassroomEvent();

  @override
  List<Object?> get props => [];
}

class LoadClassrooms extends ClassroomEvent {}

class AddClassroom extends ClassroomEvent {
  final Classroom classroom;

  const AddClassroom(this.classroom);

  @override
  List<Object?> get props => [classroom];
}

class UpdateClassroom extends ClassroomEvent {
  final Classroom classroom;

  const UpdateClassroom(this.classroom);

  @override
  List<Object?> get props => [classroom];
}

class DeleteClassroom extends ClassroomEvent {
  final String classroomId;

  const DeleteClassroom(this.classroomId);

  @override
  List<Object?> get props => [classroomId];
}
