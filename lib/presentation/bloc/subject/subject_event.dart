import 'package:equatable/equatable.dart';
import 'package:school_schedule_app/domain/entities/subject.dart';

abstract class SubjectEvent extends Equatable {
  const SubjectEvent();

  @override
  List<Object?> get props => [];
}

class LoadSubjects extends SubjectEvent {}

class AddSubject extends SubjectEvent {
  final Subject subject;

  const AddSubject(this.subject);

  @override
  List<Object?> get props => [subject];
}

class UpdateSubject extends SubjectEvent {
  final Subject subject;

  const UpdateSubject(this.subject);

  @override
  List<Object?> get props => [subject];
}

class DeleteSubject extends SubjectEvent {
  final String subjectId;

  const DeleteSubject(this.subjectId);

  @override
  List<Object?> get props => [subjectId];
}
