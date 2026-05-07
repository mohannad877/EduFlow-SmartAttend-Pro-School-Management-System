import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:school_schedule_app/domain/repositories/i_classroom_repository.dart';
import 'classroom_event.dart';
import 'classroom_state.dart';

@injectable
class ClassroomBloc extends Bloc<ClassroomEvent, ClassroomState> {
  final IClassroomRepository _repository;

  ClassroomBloc(this._repository) : super(ClassroomInitial()) {
    on<LoadClassrooms>(_onLoadClassrooms);
    on<AddClassroom>(_onAddClassroom);
    on<UpdateClassroom>(_onUpdateClassroom);
    on<DeleteClassroom>(_onDeleteClassroom);
  }

  Future<void> _onLoadClassrooms(
      LoadClassrooms event, Emitter<ClassroomState> emit) async {
    emit(ClassroomLoading());
    try {
      final classrooms = await _repository.getClassrooms();
      emit(ClassroomLoaded(classrooms));
    } catch (e) {
      emit(ClassroomError(e.toString()));
    }
  }

  Future<void> _onAddClassroom(
      AddClassroom event, Emitter<ClassroomState> emit) async {
    try {
      await _repository.saveClassroom(event.classroom);
      emit(const ClassroomOperationSuccess('Classroom added successfully'));
      add(LoadClassrooms());
    } catch (e) {
      emit(ClassroomError(e.toString()));
    }
  }

  Future<void> _onUpdateClassroom(
      UpdateClassroom event, Emitter<ClassroomState> emit) async {
    try {
      await _repository.saveClassroom(event.classroom);
      emit(const ClassroomOperationSuccess('Classroom updated successfully'));
      add(LoadClassrooms());
    } catch (e) {
      emit(ClassroomError(e.toString()));
    }
  }

  Future<void> _onDeleteClassroom(
      DeleteClassroom event, Emitter<ClassroomState> emit) async {
    try {
      await _repository.deleteClassroom(event.classroomId);
      emit(const ClassroomOperationSuccess('Classroom deleted successfully'));
      add(LoadClassrooms());
    } catch (e) {
      emit(ClassroomError(e.toString()));
    }
  }
}
