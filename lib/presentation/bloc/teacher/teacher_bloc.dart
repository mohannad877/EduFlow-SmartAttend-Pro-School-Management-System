import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:school_schedule_app/domain/repositories/i_teacher_repository.dart';
import 'teacher_event.dart';
import 'teacher_state.dart';

@injectable
class TeacherBloc extends Bloc<TeacherEvent, TeacherState> {
  final ITeacherRepository _repository;

  TeacherBloc(this._repository) : super(TeacherInitial()) {
    on<LoadTeachers>(_onLoadTeachers);
    on<LoadTeacherDetail>(_onLoadTeacherDetail);
    on<AddTeacher>(_onAddTeacher);
    on<UpdateTeacher>(_onUpdateTeacher);
    on<DeleteTeacher>(_onDeleteTeacher);
  }

  Future<void> _onLoadTeachers(
      LoadTeachers event, Emitter<TeacherState> emit) async {
    emit(TeacherLoading());
    try {
      final teachers = await _repository.getTeachers();
      emit(TeachersLoaded(teachers));
    } catch (e) {
      emit(TeacherError(e.toString()));
    }
  }

  Future<void> _onLoadTeacherDetail(
      LoadTeacherDetail event, Emitter<TeacherState> emit) async {
    emit(TeacherLoading());
    try {
      final teacher = await _repository.getTeacherById(event.id);
      if (teacher != null) {
        emit(TeacherDetailLoaded(teacher));
      } else {
        emit(const TeacherError("Teacher not found"));
      }
    } catch (e) {
      emit(TeacherError(e.toString()));
    }
  }

  Future<void> _onAddTeacher(
      AddTeacher event, Emitter<TeacherState> emit) async {
    emit(TeacherLoading());
    try {
      await _repository.saveTeacher(event.teacher);
      emit(const TeacherOperationSuccess("Teacher added successfully"));
      add(LoadTeachers());
    } catch (e) {
      emit(TeacherError(e.toString()));
    }
  }

  Future<void> _onUpdateTeacher(
      UpdateTeacher event, Emitter<TeacherState> emit) async {
    emit(TeacherLoading());
    try {
      await _repository.saveTeacher(event.teacher);
      emit(const TeacherOperationSuccess("Teacher updated successfully"));
      add(LoadTeachers());
    } catch (e) {
      emit(TeacherError(e.toString()));
    }
  }

  Future<void> _onDeleteTeacher(
      DeleteTeacher event, Emitter<TeacherState> emit) async {
    emit(TeacherLoading());
    try {
      await _repository.deleteTeacher(event.id);
      emit(const TeacherOperationSuccess("Teacher deleted successfully"));
      add(LoadTeachers());
    } catch (e) {
      emit(TeacherError(e.toString()));
    }
  }
}
