import 'package:equatable/equatable.dart';
import 'package:school_schedule_app/domain/entities/enums.dart';
import 'package:school_schedule_app/domain/entities/session.dart';
import 'package:school_schedule_app/domain/entities/schedule.dart';

abstract class ScheduleEvent extends Equatable {
  const ScheduleEvent();

  @override
  List<Object?> get props => [];
}

class LoadSchedule extends ScheduleEvent {
  final String? classroomId;
  final String? actionSuccess;

  const LoadSchedule({this.classroomId, this.actionSuccess});

  @override
  List<Object?> get props => [classroomId, actionSuccess];
}

class GenerateSchedule extends ScheduleEvent {
  final GenerationMode mode;
  final List<String>? targetClassroomIds;
  final int maxRetries;
  final int? maxTeacherDailySessions;
  final String? scheduleName;

  const GenerateSchedule({
    this.mode = GenerationMode.balanced,
    this.targetClassroomIds,
    this.maxRetries = 3,
    this.maxTeacherDailySessions,
    this.scheduleName,
  });

  @override
  List<Object?> get props => [mode, targetClassroomIds, maxRetries, maxTeacherDailySessions, scheduleName];
}

class ClearSchedule extends ScheduleEvent {
  final Schedule? backup;
  final String? scheduleId;

  const ClearSchedule({this.backup, this.scheduleId});

  @override
  List<Object?> get props => [scheduleId];
}

class UpdateSession extends ScheduleEvent {
  final Session session;
  final String scheduleId;

  const UpdateSession(this.session, this.scheduleId);

  @override
  List<Object?> get props => [session, scheduleId];
}

class DeleteSession extends ScheduleEvent {
  final String sessionId;
  final String scheduleId;

  const DeleteSession(this.sessionId, this.scheduleId);

  @override
  List<Object?> get props => [sessionId, scheduleId];
}

class SelectClassroom extends ScheduleEvent {
  final String classroomId;
  const SelectClassroom(this.classroomId);
  @override
  List<Object?> get props => [classroomId];
}

class SelectTeacher extends ScheduleEvent {
  final String teacherId;
  const SelectTeacher(this.teacherId);
  @override
  List<Object?> get props => [teacherId];
}

class ToggleViewMode extends ScheduleEvent {
  final String viewMode; // 'classroom' or 'teacher'
  const ToggleViewMode(this.viewMode);
  @override
  List<Object?> get props => [viewMode];
}

class ExportSchedulePdf extends ScheduleEvent {
  final bool includeValidation;
  const ExportSchedulePdf({this.includeValidation = false});
  @override
  List<Object?> get props => [includeValidation];
}

class ExportScheduleExcel extends ScheduleEvent {
  final bool includeValidation;
  const ExportScheduleExcel({this.includeValidation = false});
  @override
  List<Object?> get props => [includeValidation];
}

class UndoAction extends ScheduleEvent {}

class RedoAction extends ScheduleEvent {}

class ValidateSchedule extends ScheduleEvent {}

class RefreshReferences extends ScheduleEvent {}

class ToggleSetting extends ScheduleEvent {
  final String setting;
  final bool value;
  const ToggleSetting(this.setting, {required this.value});
  @override
  List<Object?> get props => [setting, value];
}

// 🎯 Drag & Drop Events
class MoveSessionEvent extends ScheduleEvent {
  final Session session;
  final WorkDay newDay;
  final int newPeriod;

  const MoveSessionEvent({
    required this.session,
    required this.newDay,
    required this.newPeriod,
  });

  @override
  List<Object?> get props => [session, newDay, newPeriod];
}

class SwapSessionsEvent extends ScheduleEvent {
  final Session session1;
  final Session session2;

  const SwapSessionsEvent({
    required this.session1,
    required this.session2,
  });

  @override
  List<Object?> get props => [session1, session2];
}
