import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:school_schedule_app/domain/repositories/i_subject_repository.dart';
import 'subject_event.dart';
import 'subject_state.dart';

@injectable
class SubjectBloc extends Bloc<SubjectEvent, SubjectState> {
  final ISubjectRepository _repository;

  SubjectBloc(this._repository) : super(SubjectInitial()) {
    on<LoadSubjects>(_onLoadSubjects);
    on<AddSubject>(_onAddSubject);
    on<UpdateSubject>(_onUpdateSubject);
    on<DeleteSubject>(_onDeleteSubject);
  }

  Future<void> _onLoadSubjects(
      LoadSubjects event, Emitter<SubjectState> emit) async {
    emit(SubjectLoading());
    try {
      final subjects = await _repository.getSubjects();
      emit(SubjectLoaded(subjects));
    } catch (e) {
      emit(SubjectError(e.toString()));
    }
  }

  Future<void> _onAddSubject(
      AddSubject event, Emitter<SubjectState> emit) async {
    try {
      await _repository.saveSubject(event.subject);
      emit(const SubjectOperationSuccess('Subject added successfully'));
      add(LoadSubjects());
    } catch (e) {
      emit(SubjectError(e.toString()));
    }
  }

  Future<void> _onUpdateSubject(
      UpdateSubject event, Emitter<SubjectState> emit) async {
    try {
      await _repository.saveSubject(event.subject);
      emit(const SubjectOperationSuccess('Subject updated successfully'));
      add(LoadSubjects());
    } catch (e) {
      emit(SubjectError(e.toString()));
    }
  }

  Future<void> _onDeleteSubject(
      DeleteSubject event, Emitter<SubjectState> emit) async {
    try {
      await _repository.deleteSubject(event.subjectId);
      emit(const SubjectOperationSuccess('Subject deleted successfully'));
      add(LoadSubjects());
    } catch (e) {
      emit(SubjectError(e.toString()));
    }
  }
}
