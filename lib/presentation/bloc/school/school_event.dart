import 'package:equatable/equatable.dart';
import 'package:school_schedule_app/domain/entities/school.dart';

abstract class SchoolEvent extends Equatable {
  const SchoolEvent();

  @override
  List<Object> get props => [];
}

class LoadSchool extends SchoolEvent {}

class UpdateSchool extends SchoolEvent {
  final School school;

  const UpdateSchool(this.school);

  @override
  List<Object> get props => [school];
}
