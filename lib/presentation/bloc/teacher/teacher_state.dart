import 'package:equatable/equatable.dart';
import 'package:school_schedule_app/domain/entities/teacher.dart';

abstract class TeacherState extends Equatable {
  const TeacherState();

  @override
  List<Object?> get props => [];
}

class TeacherInitial extends TeacherState {}

class TeacherLoading extends TeacherState {}

class TeachersLoaded extends TeacherState {
  final List<Teacher> teachers;
  const TeachersLoaded(this.teachers);
  @override
  List<Object?> get props => [teachers];
}

class TeacherDetailLoaded extends TeacherState {
  final Teacher teacher;
  const TeacherDetailLoaded(this.teacher);
  @override
  List<Object?> get props => [teacher];
}

class TeacherOperationSuccess extends TeacherState {
  final String message;
  const TeacherOperationSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class TeacherError extends TeacherState {
  final String message;
  const TeacherError(this.message);
  @override
  List<Object?> get props => [message];
}
