import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';
import 'package:school_schedule_app/domain/entities/enums.dart';
import 'package:school_schedule_app/domain/entities/school.dart';
import 'package:school_schedule_app/domain/repositories/i_school_repository.dart';
import 'school_event.dart';
import 'school_state.dart';

@injectable
class SchoolBloc extends Bloc<SchoolEvent, SchoolState> {
  final ISchoolRepository _repository;

  SchoolBloc(this._repository) : super(SchoolInitial()) {
    on<LoadSchool>(_onLoadSchool);
    on<UpdateSchool>(_onUpdateSchool);
  }

  Future<void> _onLoadSchool(
      LoadSchool event, Emitter<SchoolState> emit) async {
    emit(SchoolLoading());
    try {
      var school = await _repository.getSchool();
      if (school == null) {
        // Create default school if not exists
        school = School(
            id: const Uuid().v4(),
            name: 'My School',
            address: '',
            phone: '',
            email: '',
            dailySessions: 8,
            workDays: WorkDay.values.sublist(0, 5), // Sun-Thu
            firstSessionTime: const TimeOfDay(hour: 8, minute: 0),
            sessionDuration: 45,
            academicYear: DateTime.now().year.toString());
        await _repository.saveSchool(school);
      }
      emit(SchoolLoaded(school));
    } catch (e) {
      emit(SchoolError(e.toString()));
    }
  }

  Future<void> _onUpdateSchool(
      UpdateSchool event, Emitter<SchoolState> emit) async {
    emit(SchoolLoading());
    try {
      await _repository.saveSchool(event.school);
      emit(SchoolLoaded(event.school));
    } catch (e) {
      emit(SchoolError(e.toString()));
    }
  }
}
