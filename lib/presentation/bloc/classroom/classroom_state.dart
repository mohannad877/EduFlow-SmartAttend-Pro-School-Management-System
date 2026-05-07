import 'package:equatable/equatable.dart';
import 'package:school_schedule_app/domain/entities/classroom.dart';

abstract class ClassroomState extends Equatable {
  const ClassroomState();

  @override
  List<Object?> get props => [];
}

class ClassroomInitial extends ClassroomState {}

class ClassroomLoading extends ClassroomState {}

class ClassroomLoaded extends ClassroomState {
  final List<Classroom> classrooms;

  const ClassroomLoaded(this.classrooms);

  @override
  List<Object?> get props => [classrooms];
}

class ClassroomOperationSuccess extends ClassroomState {
  final String message;

  const ClassroomOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ClassroomError extends ClassroomState {
  final String message;

  const ClassroomError(this.message);

  @override
  List<Object?> get props => [message];
}
