import 'package:injectable/injectable.dart';
import 'package:school_schedule_app/core/utils/undo_stack.dart';
import 'package:school_schedule_app/presentation/bloc/schedule/schedule_event.dart';

import 'package:school_schedule_app/presentation/bloc/schedule/schedule_bloc.dart';

@module
abstract class CoreModule {
  @lazySingleton
  BlocConfig get blocConfig => const BlocConfig();

  @lazySingleton
  UndoStack<ScheduleEvent> get undoStack => UndoStack<ScheduleEvent>(limit: 50);
}
