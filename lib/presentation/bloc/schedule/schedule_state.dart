import 'package:school_schedule_app/core/utils/l10n_extension.dart';
import 'package:school_schedule_app/core/navigation/app_router.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';
import 'package:school_schedule_app/domain/entities/schedule.dart';
import 'package:school_schedule_app/domain/entities/session.dart';
import 'package:school_schedule_app/domain/entities/enums.dart';
import 'package:school_schedule_app/domain/entities/validation_result.dart';

abstract class ScheduleState extends Equatable {
  const ScheduleState();

  @override
  List<Object?> get props => [];
}

class ScheduleInitial extends ScheduleState {}

class ScheduleLoading extends ScheduleState {
  final double progress;
  final String message;

  const ScheduleLoading({this.progress = 0.0, this.message = ''});

  @override
  List<Object?> get props => [progress, message];
}

class ScheduleError extends ScheduleState {
  final String message;
  final bool recoverable;
  const ScheduleError(this.message, {this.recoverable = false});
  @override
  List<Object?> get props => [message, recoverable];
}

/// 📊 حالة متقدمة تحمل بيانات غنية للعرض
@immutable
class ScheduleLoaded extends ScheduleState {
  // 📦 البيانات الأساسية
  final Schedule schedule;
  final Map<String, String> teacherNames;
  final Map<String, String> subjectNames;
  final Map<String, String> classroomNames;
  // 🎯 التحديدات الحالية
  final String? selectedClassroomId;
  final String? selectedTeacherId;
  final String viewMode; // 'classroom' | 'teacher' | 'subject'

  // ⚙️ إعدادات العرض
  final int dailySessions;
  final int workDays;
  final bool showConflicts;
  final bool showWarnings;
  final bool highlightUnassigned;

  // 📊 النتائج والتحليلات
  final ValidationResult? validationResult;
  final Map<String, dynamic>? generationMetadata;
  final ScheduleStateAnalytics? analytics;

  // 🔄 حالة الواجهة
  final bool canUndo;
  final bool canRedo;
  final String? actionSuccess;
  final String? actionError;
  final Map<String, dynamic>? actionErrorDetails;
  final OperationProgress? currentProgress;

  // 🆔 التتبع
  final String stateId;
  final DateTime loadedAt;

  ScheduleLoaded({
    required this.schedule,
    required this.teacherNames,
    required this.subjectNames,
    required this.classroomNames,
    this.selectedClassroomId,
    this.selectedTeacherId,
    this.viewMode = 'classroom',
    this.dailySessions = 8,
    this.workDays = 5,
    this.showConflicts = true,
    this.showWarnings = true,
    this.highlightUnassigned = true,
    this.validationResult,
    this.generationMetadata,
    this.analytics,
    this.canUndo = false,
    this.canRedo = false,
    this.actionSuccess,
    this.actionError,
    this.actionErrorDetails,
    this.currentProgress,
    String? stateId,
    DateTime? loadedAt,
  })  : stateId = stateId ?? const Uuid().v4(),
        loadedAt = loadedAt ?? DateTime.now();

  /// 🔄 نسخ الحالة مع تعديلات (Immutable Update)
  ScheduleLoaded copyWith({
    Schedule? schedule,
    Map<String, String>? teacherNames,
    Map<String, String>? subjectNames,
    Map<String, String>? classroomNames,
    String? selectedClassroomId,
    String? selectedTeacherId,
    String? viewMode,
    int? dailySessions,
    int? workDays,
    bool? showConflicts,
    bool? showWarnings,
    bool? highlightUnassigned,
    ValidationResult? validationResult,
    Map<String, dynamic>? generationMetadata,
    ScheduleStateAnalytics? analytics,
    bool? canUndo,
    bool? canRedo,
    String? actionSuccess,
    String? actionError,
    Map<String, dynamic>? actionErrorDetails,
    OperationProgress? currentProgress,
  }) =>
      ScheduleLoaded(
        schedule: schedule ?? this.schedule,
        teacherNames: teacherNames ?? this.teacherNames,
        subjectNames: subjectNames ?? this.subjectNames,
        classroomNames: classroomNames ?? this.classroomNames,
        selectedClassroomId: selectedClassroomId ?? this.selectedClassroomId,
        selectedTeacherId: selectedTeacherId ?? this.selectedTeacherId,
        viewMode: viewMode ?? this.viewMode,
        dailySessions: dailySessions ?? this.dailySessions,
        workDays: workDays ?? this.workDays,
        showConflicts: showConflicts ?? this.showConflicts,
        showWarnings: showWarnings ?? this.showWarnings,
        highlightUnassigned: highlightUnassigned ?? this.highlightUnassigned,
        validationResult: validationResult ?? this.validationResult,
        generationMetadata: generationMetadata ?? this.generationMetadata,
        analytics: analytics ?? this.analytics,
        canUndo: canUndo ?? this.canUndo,
        canRedo: canRedo ?? this.canRedo,
        actionSuccess: actionSuccess, // always replace (null clears it)
        actionError: actionError, // always replace (null clears it)
        actionErrorDetails: actionErrorDetails,
        currentProgress: currentProgress, // null clears it
        stateId: const Uuid().v4(), // 新 state = new ID
        loadedAt: DateTime.now(),
      );

  /// 📋 الحصول على حصص محددة حسب التصفية
  List<Session> getFilteredSessions({
    String? classroomId,
    String? teacherId,
    String? subjectId,
    WorkDay? day,
    int? sessionNumber,
  }) {
    return schedule.sessions.where((session) {
      if (classroomId != null && session.classId != classroomId) return false;
      if (teacherId != null && session.teacherId != teacherId) return false;
      if (subjectId != null && session.subjectId != subjectId) return false;
      if (day != null && session.day != day) return false;
      if (sessionNumber != null && session.sessionNumber != sessionNumber) return false;
      return true;
    }).toList();
  }

  /// ⚠️ الحصول على تعارضات الجدول
  List<ConflictInfo> getConflicts() {
    final conflicts = <ConflictInfo>[];
    final sessionsByTime = <String, List<Session>>{};

    for (final session in schedule.sessions) {
      final key = '${session.day.index}_${session.sessionNumber}';
      sessionsByTime.putIfAbsent(key, () => []);
      sessionsByTime[key]!.add(session);
    }

    for (final entry in sessionsByTime.entries) {
      final sessions = entry.value;
      final teacherIds = <String>{};
      final classroomIds = <String>{};

      for (final session in sessions) {
        if (teacherIds.contains(session.teacherId)) {
          conflicts.add(ConflictInfo(
            type: ConflictType.teacherDoubleBooking,
            message: AppNavigator.navigatorKey.currentContext!.l10n.teacherDoubleScheduled,
            sessionId: session.id,
            day: session.day,
            sessionNumber: session.sessionNumber,
          ));
        }
        if (classroomIds.contains(session.classId)) {
          conflicts.add(ConflictInfo(
            type: ConflictType.classroomDoubleBooking,
            message: AppNavigator.navigatorKey.currentContext!.l10n.roomDoubleScheduled,
            sessionId: session.id,
            day: session.day,
            sessionNumber: session.sessionNumber,
          ));
        }
        teacherIds.add(session.teacherId);
        classroomIds.add(session.classId);
      }
    }

    return conflicts;
  }

  @override
  List<Object?> get props => [
        stateId,
        schedule.id,
        selectedClassroomId,
        selectedTeacherId,
        viewMode,
        validationResult?.errors.length,
        actionSuccess,
        actionError,
      ];
}

/// ⚠️ حالة تمثل جدول تم توليده بنجاح جزئي (يحتوي على فجوات)
@immutable
class ScheduleGenerationPartialSuccess extends ScheduleLoaded {
  final List<dynamic> unassignedSlots;

  ScheduleGenerationPartialSuccess({
    required super.schedule,
    required super.teacherNames,
    required super.subjectNames,
    required super.classroomNames,
    required this.unassignedSlots,
    super.selectedClassroomId,
    super.selectedTeacherId,
    super.viewMode,
    super.dailySessions,
    super.workDays,
    super.showConflicts,
    super.showWarnings,
    super.highlightUnassigned,
    super.validationResult,
    super.generationMetadata,
    super.analytics,
    super.canUndo,
    super.canRedo,
    super.actionSuccess,
    super.actionError,
    super.actionErrorDetails,
    super.currentProgress,
    super.stateId,
    super.loadedAt,
  });

  @override
  List<Object?> get props => [...super.props, unassignedSlots.length];
}

/// 🔄 تتبع تقدم عملية طويلة
@immutable
class OperationProgress {
  final String operation;
  final double progress; // 0.0 - 1.0
  final String message;
  final DateTime startedAt;
  final Map<String, dynamic>? metadata;

  const OperationProgress({
    required this.operation,
    required this.progress,
    required this.message,
    DateTime? startedAt,
    this.metadata,
  }) : startedAt = startedAt ?? const _DateTimeNow();

  @override
  String toString() => '[$operation] ${(progress * 100).toStringAsFixed(1)}% - $message';
}

// Workaround for const DateTime.now()
class _DateTimeNow implements DateTime {
  const _DateTimeNow();
  @override
  noSuchMethod(Invocation invocation) => DateTime.now();
}

/// ⚠️ معلومات تعارض في الجدول
@immutable
class ConflictInfo {
  final ConflictType type;
  final String message;
  final String sessionId;
  final WorkDay day;
  final int sessionNumber;
  final List<String>? affectedEntities;

  const ConflictInfo({
    required this.type,
    required this.message,
    required this.sessionId,
    required this.day,
    required this.sessionNumber,
    this.affectedEntities,
  });

  @override
  String toString() => '[$type] $day/$sessionNumber: $message';
}

enum ConflictType {
  teacherDoubleBooking,
  classroomDoubleBooking,
  teacherUnavailable,
  classroomUnsupported,
  prerequisiteMissing,
}

/// 📊 تحليلات الجدول للعرض
@immutable
class ScheduleStateAnalytics {
  final double completionRate;
  final double qualityScore;
  final int totalConflicts;
  final int totalWarnings;
  final Map<String, double> teacherUtilization;
  final Map<String, double> classroomUtilization;
  final List<OptimizationTip> tips;

  const ScheduleStateAnalytics({
    required this.completionRate,
    required this.qualityScore,
    required this.totalConflicts,
    required this.totalWarnings,
    required this.teacherUtilization,
    required this.classroomUtilization,
    required this.tips,
  });

  ScheduleStateAnalytics copyWith({
    double? completionRate,
    double? qualityScore,
    int? totalConflicts,
    int? totalWarnings,
    Map<String, double>? teacherUtilization,
    Map<String, double>? classroomUtilization,
    List<OptimizationTip>? tips,
  }) {
    return ScheduleStateAnalytics(
      completionRate: completionRate ?? this.completionRate,
      qualityScore: qualityScore ?? this.qualityScore,
      totalConflicts: totalConflicts ?? this.totalConflicts,
      totalWarnings: totalWarnings ?? this.totalWarnings,
      teacherUtilization: teacherUtilization ?? this.teacherUtilization,
      classroomUtilization: classroomUtilization ?? this.classroomUtilization,
      tips: tips ?? this.tips,
    );
  }
}

@immutable
class OptimizationTip {
  final String title;
  final String description;
  final TipPriority priority;
  final String? action;

  const OptimizationTip({
    required this.title,
    required this.description,
    this.priority = TipPriority.medium,
    this.action,
  });
}

enum TipPriority { low, medium, high, urgent }
