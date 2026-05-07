import 'package:equatable/equatable.dart';
import 'package:school_schedule_app/domain/entities/school.dart';

abstract class SchoolState extends Equatable {
  const SchoolState();

  @override
  List<Object?> get props => [];
}

class SchoolInitial extends SchoolState {}

class SchoolLoading extends SchoolState {}

class SchoolLoaded extends SchoolState {
  final School school;

  const SchoolLoaded(this.school);

  @override
  List<Object?> get props => [school];
}

class SchoolError extends SchoolState {
  final String message;

  const SchoolError(this.message);

  @override
  List<Object?> get props => [message];
}
