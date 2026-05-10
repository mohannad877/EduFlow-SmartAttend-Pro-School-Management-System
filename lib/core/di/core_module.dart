import 'dart:math';
import 'package:injectable/injectable.dart';
import 'package:school_schedule_app/core/utils/undo_stack.dart';
import 'package:school_schedule_app/presentation/bloc/schedule/schedule_event.dart';
import 'package:school_schedule_app/presentation/bloc/schedule/schedule_bloc.dart';
import 'package:school_schedule_app/domain/usecases/algorithm/schedule_validator.dart';
import 'package:school_schedule_app/domain/usecases/schedule/generate_schedule_usecase.dart';

@module
abstract class CoreModule {
  @lazySingleton
  BlocConfig get blocConfig => const BlocConfig();

  @lazySingleton
  UndoStack<ScheduleEvent> get undoStack => UndoStack<ScheduleEvent>(limit: 50);

  @lazySingleton
  Random get random => Random();

  @lazySingleton
  ValidationConfig get validationConfig => const ValidationConfig();

  @lazySingleton
  UseCaseConfig get useCaseConfig => UseCaseConfig.defaultConfig;
}
