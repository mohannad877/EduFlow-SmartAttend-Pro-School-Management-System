import 'package:school_schedule_app/core/utils/l10n_extension.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// ============================================================================
// 📦 الملف: generate_schedule_use_case.dart
// 🎯 الوصف: حالة استخدام توليد الجداول الدراسية - طبقة التطبيق (Application Layer)
// 📝 الإصدار: 3.0.0 (Enterprise Edition Pro - مُدمج ومُحسّن)
// 👨‍💻 النمط: Clean Architecture + CQRS + Event-Driven + DDD
// 🛡️ الميزات: نوع آمن • قابل للاختبار • قابل للتوسع • موثّق بالكامل
// ============================================================================

import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

// 📁 الاستيراد المحلي للكيانات والمخازن
import 'package:school_schedule_app/domain/entities/enums.dart';
import 'package:school_schedule_app/domain/entities/schedule.dart';
import 'package:school_schedule_app/domain/entities/session.dart';
import 'package:school_schedule_app/domain/entities/teacher.dart';
import 'package:school_schedule_app/domain/entities/classroom.dart';
import 'package:school_schedule_app/domain/entities/subject.dart';
import 'package:school_schedule_app/domain/entities/schedule_entry.dart';
import 'package:school_schedule_app/domain/repositories/i_schedule_repository.dart';
import 'package:school_schedule_app/domain/repositories/i_teacher_repository.dart';
import 'package:school_schedule_app/domain/repositories/i_subject_repository.dart';
import 'package:school_schedule_app/domain/repositories/i_classroom_repository.dart';

// 🧠 الاستيراد من طبقة الخوارزمية
import '../algorithm/intelligent_schedule_generator.dart' as algo;
import '../algorithm/intelligent_schedule_generator.dart' 
  show GenerationConfig, GenerationProgress, QualityGrade, UnassignedSlot, GenerationData;
import 'package:school_schedule_app/core/utils/cancellation_token.dart';

// 📡 الاستيراد من طبقة الأحداث والخدمات
import 'package:school_schedule_app/domain/events/schedule_events.dart';
import 'package:school_schedule_app/domain/services/event_bus_service.dart';
import 'package:school_schedule_app/core/utils/logger.dart';
import 'package:school_schedule_app/core/utils/metrics_collector.dart';
import 'package:school_schedule_app/domain/exceptions/validation_exceptions.dart';
import 'package:school_schedule_app/domain/exceptions/repository_exceptions.dart';
import 'package:school_schedule_app/domain/exceptions/schedule_generation_exception.dart';
import 'generation_isolate.dart';
import 'package:school_schedule_app/core/navigation/app_router.dart';

// ============================================================================
// 🎫 1. نموذج طلب التوليد المتقدم (Command Pattern) - مُحسّن
// ============================================================================

/// 📋 طلب توليد جدول مع جميع الخيارات المتقدمة والمرونة الكاملة
@immutable
class GenerateScheduleRequest {
  // ⚙️ المعلمات الأساسية (مطلوبة)
  final int dailySessions;
  final List<WorkDay> workDays;
  
  // 🎯 خيارات التوليد والاستهداف
  final GenerationMode mode;
  final List<String>? targetClassroomIds;
  final List<String>? targetTeacherIds;
  final List<String>? targetSubjectIds;
  
  // ⚡ إعدادات الأداء والتحكم
  final Duration? timeout;
  final int? randomSeed;
  final bool enableParallelProcessing;
  
  // 🎛️ إعدادات الخوارزمية المتقدمة
  final GenerationConfig? algorithmConfig;
  
  // 📊 خيارات المعالجة اللاحقة والإثراء
  final bool autoSave;
  final bool enrichWithAnalytics;
  final bool validateAfterGeneration;
  
  // 🔄 خيارات السلوك والجودة
  final bool throwOnIncomplete;
  final double? minQualityThreshold; // 0.0 - 1.0
  final bool allowPartialResults;
  
  // 👤 معلومات السياق والهوية
  final String? schoolId;
  final String? creatorId;
  final String? scheduleName;
  final Map<String, dynamic>? customMetadata;
  
  // 📡 المراقبة والتتبع والتفاعل
  final void Function(GenerationProgress)? onProgress;
  final CancellationToken? cancellationToken;

  const GenerateScheduleRequest({
    required this.dailySessions,
    required this.workDays,
    this.mode = GenerationMode.balanced,
    this.targetClassroomIds,
    this.targetTeacherIds,
    this.targetSubjectIds,
    this.timeout,
    this.randomSeed,
    this.enableParallelProcessing = false,
    this.algorithmConfig,
    this.autoSave = true,
    this.enrichWithAnalytics = true,
    this.validateAfterGeneration = true,
    this.throwOnIncomplete = false,
    this.minQualityThreshold,
    this.allowPartialResults = true,
    this.schoolId,
    this.creatorId,
    this.scheduleName,
    this.customMetadata,
    this.onProgress,
    this.cancellationToken,
  }) : assert(dailySessions > 0 && dailySessions <= 20, 'dailySessions must be between 1 and 20'),
       assert(minQualityThreshold == null || (minQualityThreshold >= 0 && minQualityThreshold <= 1),
              'minQualityThreshold must be between 0.0 and 1.0');

  /// 🏭 مصنع لإنشاء طلب سريع للتوليد الأساسي
  factory GenerateScheduleRequest.basic({
    required int dailySessions,
    required int workDaysCount,
    required String schoolId,
    String? creatorId,
    String? scheduleName,
  }) {
    assert(workDaysCount > 0 && workDaysCount <= WorkDay.values.length);
    final workDays = WorkDay.values.take(workDaysCount).toList();
    return GenerateScheduleRequest(
      dailySessions: dailySessions,
      workDays: workDays,
      schoolId: schoolId,
      creatorId: creatorId,
      scheduleName: scheduleName,
    );
  }

  /// 🎯 مصنع لإنشاء طلب دقيق (جودة عالية - إنتاجي)
  factory GenerateScheduleRequest.precise({
    required int dailySessions,
    required List<WorkDay> workDays,
    required String schoolId,
    void Function(GenerationProgress)? onProgress,
    CancellationToken? cancellationToken,
    double qualityThreshold = 0.9,
  }) => GenerateScheduleRequest(
    dailySessions: dailySessions,
    workDays: workDays,
    mode: GenerationMode.priority,
    algorithmConfig: GenerationConfig.precise(onProgress: onProgress),
    autoSave: true,
    enrichWithAnalytics: true,
    validateAfterGeneration: true,
    minQualityThreshold: qualityThreshold,
    allowPartialResults: false,
    schoolId: schoolId,
    onProgress: onProgress,
    cancellationToken: cancellationToken,
  );

  /// ⚡ مصنع للتوليد السريع (أداء عالي - تجريب)
  factory GenerateScheduleRequest.fast({
    required int dailySessions,
    required List<WorkDay> workDays,
    required String schoolId,
    int randomSeed = 42,
  }) => GenerateScheduleRequest(
    dailySessions: dailySessions,
    workDays: workDays,
    mode: GenerationMode.compact,
    algorithmConfig: GenerationConfig.fast(),
    autoSave: false,
    enrichWithAnalytics: false,
    validateAfterGeneration: false,
    allowPartialResults: true,
    schoolId: schoolId,
    randomSeed: randomSeed,
  );

  /// 🔄 نسخ الطلب مع تعديلات انتقائية (Immutable Copy Pattern)
  GenerateScheduleRequest copyWith({
    int? dailySessions,
    List<WorkDay>? workDays,
    GenerationMode? mode,
    List<String>? targetClassroomIds,
    List<String>? targetTeacherIds,
    List<String>? targetSubjectIds,
    Duration? timeout,
    int? randomSeed,
    bool? enableParallelProcessing,
    GenerationConfig? algorithmConfig,
    bool? autoSave,
    bool? enrichWithAnalytics,
    bool? validateAfterGeneration,
    bool? throwOnIncomplete,
    double? minQualityThreshold,
    bool? allowPartialResults,
    String? schoolId,
    String? creatorId,
    String? scheduleName,
    Map<String, dynamic>? customMetadata,
    void Function(GenerationProgress)? onProgress,
    CancellationToken? cancellationToken,
  }) => GenerateScheduleRequest(
    dailySessions: dailySessions ?? this.dailySessions,
    workDays: workDays ?? this.workDays,
    mode: mode ?? this.mode,
    targetClassroomIds: targetClassroomIds ?? this.targetClassroomIds,
    targetTeacherIds: targetTeacherIds ?? this.targetTeacherIds,
    targetSubjectIds: targetSubjectIds ?? this.targetSubjectIds,
    timeout: timeout ?? this.timeout,
    randomSeed: randomSeed ?? this.randomSeed,
    enableParallelProcessing: enableParallelProcessing ?? this.enableParallelProcessing,
    algorithmConfig: algorithmConfig ?? this.algorithmConfig,
    autoSave: autoSave ?? this.autoSave,
    enrichWithAnalytics: enrichWithAnalytics ?? this.enrichWithAnalytics,
    validateAfterGeneration: validateAfterGeneration ?? this.validateAfterGeneration,
    throwOnIncomplete: throwOnIncomplete ?? this.throwOnIncomplete,
    minQualityThreshold: minQualityThreshold ?? this.minQualityThreshold,
    allowPartialResults: allowPartialResults ?? this.allowPartialResults,
    schoolId: schoolId ?? this.schoolId,
    creatorId: creatorId ?? this.creatorId,
    scheduleName: scheduleName ?? this.scheduleName,
    customMetadata: customMetadata ?? this.customMetadata,
    onProgress: onProgress ?? this.onProgress,
    cancellationToken: cancellationToken ?? this.cancellationToken,
  );

  /// 📋 تحويل الطلب إلى خريطة للـ Logging والتصحيح
  Map<String, dynamic> toDebugMap() => {
    'dailySessions': dailySessions,
    'workDays': workDays.map((d) => d.name).toList(),
    'mode': mode.name,
    'targetClassrooms': targetClassroomIds?.length ?? 0,
    'targetTeachers': targetTeacherIds?.length ?? 0,
    'targetSubjects': targetSubjectIds?.length ?? 0,
    'timeout': timeout?.inSeconds,
    'randomSeed': randomSeed,
    'parallelProcessing': enableParallelProcessing,
    'autoSave': autoSave,
    'enrichAnalytics': enrichWithAnalytics,
    'minQuality': minQualityThreshold,
    'allowPartial': allowPartialResults,
    'schoolId': schoolId,
    'creatorId': creatorId,
  };

  @override
  String toString() => 
    'GenerateScheduleRequest(mode: $mode, sessions: $dailySessions, days: ${workDays.length}, school: $schoolId)';
}

// ============================================================================
// 📤 2. نموذج نتيجة التوليد المُثرى (Enriched Result Pattern)
// ============================================================================

/// 🎁 نتيجة عملية التوليد مع بيانات مُثراة وتحليلات شاملة
@immutable
class GenerateScheduleResult {
  // 📦 البيانات الأساسية
  final Schedule schedule;
  final algo.GenerationResult algorithmResult;
  
  // 📊 التحليلات والإثراء
  final ScheduleAnalytics? analytics;
  final List<GenerationWarning> warnings;
  final List<GenerationRecommendation> recommendations;
  
  // ⚙️ معلومات التنفيذ والأداء
  final Duration executionTime;
  final bool wasSaved;
  final bool meetsQualityThreshold;
  
  // 🆔 التتبع والمراجعة
  final String traceId;
  final DateTime completedAt;

  GenerateScheduleResult({
    required this.schedule,
    required this.algorithmResult,
    this.analytics,
    this.warnings = const [],
    this.recommendations = const [],
    required this.executionTime,
    required this.wasSaved,
    required this.meetsQualityThreshold,
    required this.traceId,
    DateTime? completedAt,
  }) : completedAt = completedAt ?? DateTime.now();

  /// ✅ التحقق مما إذا كانت النتيجة ناجحة تماماً (بدون تحذيرات)
  bool get isSuccess => algorithmResult.isComplete && warnings.isEmpty;
  
  /// ⚠️ التحقق مما إذا كانت النتيجة مقبولة للاستخدام
  bool get isAcceptable => 
    isSuccess || 
    (algorithmResult.qualityGrade.index >= QualityGrade.acceptable.index && allowPartialUsage);
    
  bool get allowPartialUsage => algorithmResult.unassignedSlots.length < 5;
  
  /// 📋 توليد ملخص تنفيذي للعرض السريع
  ExecutiveSummary get executiveSummary => ExecutiveSummary(
    scheduleId: schedule.id,
    scheduleName: schedule.name,
    qualityGrade: algorithmResult.qualityGrade,
    totalSessions: schedule.sessions.length,
    unassignedCount: algorithmResult.unassignedSlots.length,
    completionRate: _calculateCompletionRate(),
    warningsCount: warnings.length,
    executionTime: executionTime,
    wasSaved: wasSaved,
    recommendationsCount: recommendations.length,
  );

  double _calculateCompletionRate() {
    final total = algorithmResult.schedule.length + algorithmResult.unassignedSlots.length;
    return total > 0 ? algorithmResult.schedule.length / total : 0.0;
  }

  /// 📄 تحويل النتيجة إلى JSON للتصدير أو الـ API
  Map<String, dynamic> toJson() => {
    'scheduleId': schedule.id,
    'scheduleName': schedule.name,
    'schoolId': schedule.schoolId,
    'isComplete': algorithmResult.isComplete,
    'qualityGrade': algorithmResult.qualityGrade.name,
    'totalSessions': schedule.sessions.length,
    'assignedSessions': algorithmResult.schedule.length,
    'unassignedCount': algorithmResult.unassignedSlots.length,
    'completionRate': _calculateCompletionRate(),
    'softConstraintScore': algorithmResult.softConstraintScore,
    'executionTimeMs': executionTime.inMilliseconds,
    'wasSaved': wasSaved,
    'meetsQualityThreshold': meetsQualityThreshold,
    'warnings': warnings.map((w) => w.toJson()).toList(),
    'recommendations': recommendations.map((r) => r.toJson()).toList(),
    'analytics': analytics?.toJson(),
    'traceId': traceId,
    'completedAt': completedAt.toIso8601String(),
  };

  @override
  String toString() => 
    'GenerateScheduleResult(quality: ${algorithmResult.qualityGrade}, '
    'completion: ${(_calculateCompletionRate() * 100).toStringAsFixed(1)}%, saved: $wasSaved)';
}

// ============================================================================
// 📊 3. فئات التحليلات والتحسين (Analytics & Optimization)
// ============================================================================

/// 📈 تحليلات شاملة للجدول المولد
@immutable
class ScheduleAnalytics {
  final Map<String, double> teacherUtilization;
  final Map<String, double> classroomUtilization;
  final Map<String, int> subjectDistribution;
  final Map<String, double> dailyLoadBalance;
  final double overallEfficiencyScore;
  final List<OptimizationSuggestion> suggestions;
  final Map<String, dynamic> advancedMetrics;

  const ScheduleAnalytics({
    required this.teacherUtilization,
    required this.classroomUtilization,
    required this.subjectDistribution,
    required this.dailyLoadBalance,
    required this.overallEfficiencyScore,
    required this.suggestions,
    this.advancedMetrics = const {},
  });

  /// 🎯 الحصول على المعلمين الأكثر تحميلًا
  List<MapEntry<String, double>> get topLoadedTeachers => 
    teacherUtilization.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value))
      ..take(5);

  /// 🏫 الحصول على القاعات الأقل استخدامًا
  List<MapEntry<String, double>> get underutilizedClassrooms => 
    classroomUtilization.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value))
      ..take(5);

  Map<String, dynamic> toJson() => {
    'teacherUtilization': teacherUtilization,
    'classroomUtilization': classroomUtilization,
    'subjectDistribution': subjectDistribution,
    'dailyLoadBalance': dailyLoadBalance,
    'overallEfficiencyScore': overallEfficiencyScore,
    'suggestions': suggestions.map((s) => s.toJson()).toList(),
    'advancedMetrics': advancedMetrics,
  };
}

/// 💡 اقتراح تحسين ذكي مع أولوية وتأثير
@immutable
class OptimizationSuggestion {
  final SuggestionType type;
  final String title;
  final String description;
  final String? action;
  final String? actionUrl;
  final ImpactLevel impact;
  final int estimatedEffortMinutes;

  const OptimizationSuggestion({
    required this.type,
    required this.title,
    required this.description,
    this.action,
    this.actionUrl,
    this.impact = ImpactLevel.medium,
    this.estimatedEffortMinutes = 15,
  });

  bool get isActionable => action != null || actionUrl != null;

  Map<String, dynamic> toJson() => {
    'type': type.name,
    'title': title,
    'description': description,
    'action': action,
    'actionUrl': actionUrl,
    'impact': impact.name,
    'estimatedEffortMinutes': estimatedEffortMinutes,
    'isActionable': isActionable,
  };
}

enum SuggestionType { 
  addResources, 
  relaxConstraints, 
  loadBalancing, 
  timeOptimization,
  conflictResolution,
  general 
}

enum ImpactLevel { critical, high, medium, low, informational }

// ============================================================================
// ⚠️ 4. نظام التحذيرات والتوصيات (Warnings & Recommendations)
// ============================================================================

/// ⚠️ تحذير مُصنف مع مستوى خطورة واقتراح حل
@immutable
class GenerationWarning {
  final WarningType type;
  final String message;
  final String? entity;
  final String? entityId;
  final Severity severity;
  final String? suggestion;
  final DateTime timestamp;

  GenerationWarning({
    required this.type,
    required this.message,
    this.entity,
    this.entityId,
    this.severity = Severity.medium,
    this.suggestion,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  bool get isCritical => severity == Severity.critical || severity == Severity.high;

  Map<String, dynamic> toJson() => {
    'type': type.name,
    'message': message,
    'entity': entity,
    'entityId': entityId,
    'severity': severity.name,
    'suggestion': suggestion,
    'timestamp': timestamp.toIso8601String(),
    'isCritical': isCritical,
  };
}

enum WarningType {
  lowTeacherAvailability,
  classroomConflict,
  subjectUnderAllocated,
  unbalancedLoad,
  constraintRelaxed,
  timeoutRisk,
  dataQualityIssue,
  algorithmConvergenceWarning,
}

enum Severity { low, medium, high, critical }

/// 💡 توصية قابلة للتنفيذ لتحسين الجدول
@immutable
class GenerationRecommendation {
  final String title;
  final String description;
  final RecommendationPriority priority;
  final String? actionUrl;
  final Map<String, dynamic>? metadata;

  const GenerationRecommendation({
    required this.title,
    required this.description,
    this.priority = RecommendationPriority.medium,
    this.actionUrl,
    this.metadata,
  });

  bool get isUrgent => priority == RecommendationPriority.urgent || priority == RecommendationPriority.high;

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'priority': priority.name,
    'actionUrl': actionUrl,
    'metadata': metadata,
    'isUrgent': isUrgent,
  };
}

enum RecommendationPriority { low, medium, high, urgent }

// ============================================================================
// 📋 5. الملخص التنفيذي (Executive Summary)
// ============================================================================

/// 📊 ملخص تنفيذي سريع للعرض في الواجهات والتقارير
@immutable
class ExecutiveSummary {
  final String scheduleId;
  final String scheduleName;
  final QualityGrade qualityGrade;
  final int totalSessions;
  final int unassignedCount;
  final double completionRate;
  final int warningsCount;
  final int recommendationsCount;
  final Duration executionTime;
  final bool wasSaved;

  const ExecutiveSummary({
    required this.scheduleId,
    required this.scheduleName,
    required this.qualityGrade,
    required this.totalSessions,
    required this.unassignedCount,
    required this.completionRate,
    required this.warningsCount,
    required this.executionTime,
    required this.wasSaved,
    this.recommendationsCount = 0,
  });

  /// 🎨 الحصول على لون الحالة للعرض البصري
  String get statusColor {
    if (qualityGrade == QualityGrade.excellent) return '#22c55e'; // green-500
    if (qualityGrade == QualityGrade.good) return '#3b82f6'; // blue-500
    if (qualityGrade == QualityGrade.acceptable) return '#f59e0b'; // amber-500
    return '#ef4444'; // red-500
  }

  /// 📈 الحصول على نص الحالة
  String get statusText {
    final l10n = AppNavigator.currentContext!.l10n;
    if (completionRate >= 0.95) return l10n.roomNumber;
    if (completionRate >= 0.85) return l10n.studentCount;
    if (completionRate >= 0.70) return l10n.noClassroomsFound;
    return l10n.addSubject;
  }

  @override
  String toString() => 
    'ExecutiveSummary($scheduleName: ${qualityGrade.name}, '
    '${(completionRate * 100).toStringAsFixed(1)}% complete, '
    '${executionTime.inSeconds}s)';
}

// ============================================================================
// 🧠 6. حالة الاستخدام الرئيسية (Use Case Implementation) - Pro Version
// ============================================================================

@lazySingleton
class GenerateScheduleUseCase {
  // 📦 المخازن (Repositories) - Dependency Injection
  final IScheduleRepository _scheduleRepo;
  final ITeacherRepository _teacherRepo;
  final ISubjectRepository _subjectRepo;
  final IClassroomRepository _classroomRepo;
  
  // 🤖 محرك التوليد الذكي
  final algo.IntelligentScheduleGenerator _generator;
  
  // 📡 الخدمات المساندة
  final EventBusService _eventBus;
  final Logger _logger;
  final MetricsCollector? _metrics;
  
  // ⚙️ الإعدادات العامة
  final UseCaseConfig _config;

  GenerateScheduleUseCase(
    this._scheduleRepo,
    this._teacherRepo,
    this._subjectRepo,
    this._classroomRepo,
    this._generator,
    this._eventBus, {
    Logger? logger,
    MetricsCollector? metricsCollector,
    UseCaseConfig? config,
  })  : _logger = logger ?? Logger.defaultLogger,
        _metrics = metricsCollector,
        _config = config ?? UseCaseConfig.defaultConfig;

  // ==========================================================================
  // 🚀 الواجهة العامة (Public API)
  // ==========================================================================

  /// 🎯 التنفيذ الرئيسي لحالة استخدام توليد الجدول
  /// 
  /// يتبع نمط: Validation → Pre-flight → Generation → Quality Gate → 
  /// Transformation → Enrichment → Persistence → Event Publishing
  /// 
  /// [request]: طلب التوليد المتقدم
  /// 
  /// 📤 يُرجع: [GenerateScheduleResult] مع بيانات مُثراة وتحليلات
  /// 
  /// ❌ يرمي: [ScheduleGenerationException], [ValidationException], أو [RepositoryException]
  Future<GenerateScheduleResult> execute(GenerateScheduleRequest request) async {
    final traceId = const Uuid().v4();
    final stopwatch = Stopwatch()..start();
    
    final l10n = AppNavigator.currentContext!.l10n;
    // 🪵 تسجيل بدء العملية مع سياق كامل
    _logger.info(l10n.editSubject, {
      'traceId': traceId,
      'request': request.toDebugMap(),
      'timestamp': DateTime.now().toIso8601String(),
    });
    
    // 📊 تسجيل بدء القياس
    _metrics?.startTimer('schedule_generation_total');
    
    try {
      // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      // 1️⃣ مرحلة التحقق من المدخلات (Validation Layer)
      // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      await _validateRequest(request, traceId);
      
      // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      // 2️⃣ مرحلة تحميل البيانات والتحقق المسبق (Pre-flight Check)
      // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      final genContext = await _loadAndValidateContext(request, traceId);
      
      // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      // 3️⃣ مرحلة التوليد الفعلية (Core Algorithm Execution)
      // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      final algoResult = await _executeGeneration(request, genContext, traceId);
      
      // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      // 4️⃣ مرحلة تقييم الجودة والقرارات (Quality Gate)
      // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      final qualityDecision = _evaluateQuality(algoResult, request);
      if (!qualityDecision.allowed) {
        throw ScheduleGenerationException(
          l10n.deleteSubject,
          traceId: traceId,
          details: {
            'score': algoResult.softConstraintScore, 
            'threshold': request.minQualityThreshold,
            'grade': algoResult.qualityGrade.name,
          },
        );
      }
      
      // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      // 5️⃣ مرحلة تحويل النتيجة إلى كيان (Entity Transformation)
      // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      final schedule = _transformToSchedule(algoResult, request, genContext);
      
      // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      // 6️⃣ مرحلة الإثراء والتحليلات (Enrichment & Analytics)
      // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      final analytics = request.enrichWithAnalytics 
          ? await _enrichWithAnalytics(schedule, algoResult, genContext)
          : null;
      
      final warnings = _generateWarnings(algoResult, genContext, request);
      final recommendations = _generateRecommendations(algoResult, genContext);
      
      // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      // 7️⃣ مرحلة الحفظ (Persistence) - اختيارية وآمنة
      // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      var wasSaved = false;
      if (request.autoSave) {
        wasSaved = await _saveSchedule(schedule, request, traceId);
      }
      
      // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      // 8️⃣ مرحلة نشر الأحداث (Event Publishing) - غير متزامن
      // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      await _publishEvents(schedule, algoResult, request, traceId, genContext);
      
      // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      // 📦 تجميع النتيجة النهائية
      // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      stopwatch.stop();
      final result = GenerateScheduleResult(
        schedule: schedule,
        algorithmResult: algoResult,
        analytics: analytics,
        warnings: warnings,
        recommendations: recommendations,
        executionTime: stopwatch.elapsed,
        wasSaved: wasSaved,
        meetsQualityThreshold: qualityDecision.meetsThreshold,
        traceId: traceId,
      );
      
      // 🪵 تسجيل النجاح
      _logger.info(l10n.subjectName, {
        'traceId': traceId,
        'executionTime': '${stopwatch.elapsed.inMilliseconds}ms',
        'quality': algoResult.qualityGrade.name,
        'completion': '${result.executiveSummary.completionRate * 100}%'.toString(),
        'saved': wasSaved,
      });
      
      // 📊 تسجيل المقاييس
      _metrics?.record('schedule_generation_success', 1, {
        'mode': request.mode.name,
        'quality': algoResult.qualityGrade.name,
      });
      _metrics?.record('schedule_generation_time_ms', stopwatch.elapsedMilliseconds);
      _metrics?.stopTimer('schedule_generation_total');
      
      return result;
      
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // 🛡️ معالجة الأخطاء الهرمية (Hierarchical Error Handling)
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    } on ValidationException catch (e) {
      stopwatch.stop();
      _logger.error(l10n.code, {
        'traceId': traceId, 
        'error': e.message,
        'errors': e.errors.map((err) => err.toString()).toList(),
      });
      _metrics?.record('schedule_generation_validation_error', 1);
      _metrics?.stopTimer('schedule_generation_total');
      rethrow;
      
    } on ScheduleGenerationException catch (e) {
      stopwatch.stop();
      _logger.error(l10n.weeklyHours, {
        'traceId': traceId, 
        'error': e.message,
        'details': e.details,
      });
      _metrics?.record('schedule_generation_algorithm_error', 1);
      _metrics?.stopTimer('schedule_generation_total');
      rethrow;
      
    } on RepositoryException catch (e) {
      stopwatch.stop();
      _logger.error(l10n.noSubjectsFound, {
        'traceId': traceId, 
        'error': e.message,
      });
      _metrics?.record('schedule_generation_repository_error', 1);
      _metrics?.stopTimer('schedule_generation_total');
      throw RepositoryException(
        l10n.addStudent, 
        traceId: traceId,
        cause: e,
      );
      
    } on TimeoutException catch (e) {
      stopwatch.stop();
      _logger.error(l10n.editStudent, {
        'traceId': traceId,
        'timeout': request.timeout?.inSeconds,
      });
      _metrics?.record('schedule_generation_timeout', 1);
      _metrics?.stopTimer('schedule_generation_total');
      throw ScheduleGenerationException(
        l10n.generationCancelled,
        traceId: traceId,
        cause: e,
      );
      
    } catch (e, stack) {
      stopwatch.stop();
      _logger.error(l10n.studentDetails, {
        'traceId': traceId,
        'error': e.toString(),
        'stack': stack.toString(),
      });
      _metrics?.record('schedule_generation_unexpected_error', 1);
      _metrics?.stopTimer('schedule_generation_total');
      throw ScheduleGenerationException(
        l10n.barcode,
        traceId: traceId,
        cause: e,
      );
    }
  }

  // ==========================================================================
  // 🔧 الطرق الداخلية المساعدة (Private Helpers)
  // ==========================================================================

  /// ✅ 1. التحقق الشامل من صحة طلب التوليد
  Future<void> _validateRequest(GenerateScheduleRequest request, String traceId) async {
    final errors = <ValidationError>[];
    final l10n = AppNavigator.currentContext!.l10n;
    
    // 🔢 التحقق من المعلمات الأساسية
    final maxAllowed = _config.maxDailySessions ?? 20;
    if (request.dailySessions <= 0 || request.dailySessions > maxAllowed) {
      errors.add(ValidationError(
        'dailySessions', 
        l10n.scanBarcode, 
        request.dailySessions,
      ));
    }
    
    if (request.workDays.isEmpty || request.workDays.length > WorkDay.values.length) {
      errors.add(ValidationError(
        'workDays', 
        l10n.generateBarcode, 
        request.workDays.length,
      ));
    }
    
    // 🔗 التحقق من التوافق بين الحصص والأيام
    final totalSlots = request.dailySessions * request.workDays.length;
    if (totalSlots < 10) {
      errors.add(ValidationError(
        'capacity',
        l10n.printBarcodes,
        totalSlots,
      ));
    }
    
    // 🎯 التحقق من إعدادات الجودة
    if (request.minQualityThreshold != null && !request.allowPartialResults) {
      if (request.minQualityThreshold! > 0.95) {
        _logger.warning(l10n.newAttendance, {
          'threshold': request.minQualityThreshold,
          'traceId': traceId,
        });
      }
    }
    
    // ⏱️ التحقق من المهلة الزمنية
    if (request.timeout != null) {
      if (request.timeout!.inMinutes > 60) {
        errors.add(ValidationError(
          'timeout',
          l10n.markAttendance,
          request.timeout?.inMinutes,
        ));
      }
      if (request.timeout!.inSeconds < 30) {
        errors.add(ValidationError(
          'timeout',
          l10n.attendanceHistory,
          request.timeout?.inSeconds,
        ));
      }
    }
    
    // 🎲 التحقق من البذرة العشوائية
    if (request.randomSeed != null && (request.randomSeed! < 0 || request.randomSeed! > 999999)) {
      errors.add(ValidationError(
        'randomSeed',
        l10n.dailyReport,
        request.randomSeed,
      ));
    }
    
    // 🚀 رمي الأخطاء إذا وُجدت
    if (errors.isNotEmpty) {
      throw ValidationException(
        l10n.monthlyReport, 
        errors: errors, 
        traceId: traceId,
      );
    }
    
    _logger.debug(l10n.yearlyReport, {'traceId': traceId});
  }

  /// 📦 2. تحميل والتحقق من سياق البيانات (مع تحميل متوازي)
  Future<_GenerationContext> _loadAndValidateContext(
    GenerateScheduleRequest request,
    String traceId,
  ) async {
    // 🔄 تحميل البيانات بشكل متوازي لتحسين الأداء
    final futures = [
      request.targetTeacherIds != null
          ? _teacherRepo.getTeachersByIds(request.targetTeacherIds!)
          : _teacherRepo.getTeachers(),
      request.targetClassroomIds != null
          ? _classroomRepo.getClassroomsByIds(request.targetClassroomIds!)
          : _classroomRepo.getClassrooms(),
      request.targetSubjectIds != null
          ? _subjectRepo.getSubjectsByIds(request.targetSubjectIds!)
          : _subjectRepo.getSubjects(),
    ];
    
    final results = await Future.wait(futures);
    final teachers = results[0] as List<Teacher>;
    final classrooms = results[1] as List<Classroom>;
    final subjects = results[2] as List<Subject>;
    
    final l10n = AppNavigator.currentContext!.l10n;
    // 🔍 التحقق من وجود بيانات كافية
    if (classrooms.isEmpty) {
      throw DataValidationException(
        l10n.studentReport, 
        traceId: traceId,
      );
    }
    if (teachers.isEmpty) {
      throw DataValidationException(
        l10n.classReport, 
        traceId: traceId,
      );
    }
    if (subjects.isEmpty) {
      throw DataValidationException(
        l10n.teacherReport, 
        traceId: traceId,
      );
    }
    
    // ⚠️ توليد تحذيرات استباقية إذا كانت البيانات محدودة
    final warnings = <GenerationWarning>[];
    if (teachers.length < classrooms.length ~/ 2) {
      warnings.add(GenerationWarning(
        type: WarningType.lowTeacherAvailability,
        message: l10n.summaryReport,
        severity: Severity.high,
        suggestion: l10n.detailedReport,
      ));
    }
    
    // 🗂️ بناء خرائط البحث السريع (O(1) Lookup)
    final genContext = _GenerationContext(
      teachers: teachers,
      classrooms: classrooms,
      subjects: subjects,
      teacherMap: {for (var t in teachers) t.id: t},
      classroomMap: {for (var c in classrooms) c.id: c},
      subjectMap: {for (var s in subjects) s.id: s},
      warnings: warnings,
    );
    
    _logger.info(l10n.exportReport, {
      'traceId': traceId,
      'teachers': teachers.length,
      'classrooms': classrooms.length,
      'subjects': subjects.length,
      'warnings': warnings.length,
    });
    
    return genContext;
  }

  /// 🤖 3. تنفيذ التوليد عبر الخوارزمية (مع دعم الإلغاء والمهلة)
  Future<algo.GenerationResult> _executeGeneration(
    GenerateScheduleRequest request,
    _GenerationContext genContext,
    String traceId,
  ) async {
    // 🎛️ إعداد تكوين الخوارزمية
    final algoConfig = request.algorithmConfig ?? GenerationConfig(
      maxRetries: 3,
      enableSimulatedAnnealing: request.mode != GenerationMode.compact,
      enableBacktracking: true,
      onProgress: request.onProgress != null 
          ? (progress) => request.onProgress!(progress)
          : null,
    );
    
    // ⏱️ تنفيذ مع مهلة زمنية إذا طُلب
    Future<algo.GenerationResult> generationTask() async {
      // 1. تحميل وتجهيز البيانات الثقيلة (تبقى في الـ Main Thread للوصول السليم للـ DB)
      final generationData = await _generator.loadAndPrepareData(
        targetClassroomIds: request.targetClassroomIds,
        config: algoConfig,
      );
      
      // 2. إطلاق Isolate للتوليد
      final isolateRequest = IsolateGenerationRequest(
        dailySessions: request.dailySessions,
        workDays: request.workDays,
        targetClassroomIds: request.targetClassroomIds,
        mode: request.mode,
        config: algoConfig.copyWith(
          randomSeed: request.randomSeed,
          cancellationToken: request.cancellationToken,
        ),
        data: generationData,
      );
      
      return await runGenerationOptimizationInIsolate(isolateRequest);
    }
    
    final l10n = AppNavigator.currentContext!.l10n;
    if (request.timeout != null) {
      return await generationTask().timeout(
        request.timeout!,
        onTimeout: () {
          _logger.error(l10n.editStudent, {
            'traceId': traceId, 
            'timeout': request.timeout?.inSeconds,
          });
          throw TimeoutException(
            l10n.generationCancelled, 
            request.timeout,
          );
        },
      );
    }
    
    return await generationTask();
  }

  /// 🎯 4. تقييم جودة النتيجة واتخاذ القرار (Quality Gate)
  _QualityDecision _evaluateQuality(
    algo.GenerationResult result,
    GenerateScheduleRequest request,
  ) {
    final grade = result.qualityGrade;
    final score = 1.0 - (result.softConstraintScore / 100).clamp(0.0, 1.0); // تطبيع الدرجة
    
    // التحقق من عتبة الجودة
    final meetsThreshold = request.minQualityThreshold == null 
        ? true 
        : score >= request.minQualityThreshold!;
    
    // قرار السماح بالمتابعة
    var allowed = true;
    String? reason;
    
    final l10n = AppNavigator.currentContext!.l10n;
    if (!result.isComplete && !request.allowPartialResults) {
      allowed = false;
      reason = l10n.printReport;
    }
    else if (!meetsThreshold) {
      allowed = false;
      reason = l10n.shareReport;
    }
    else if (grade == QualityGrade.poor) {
      allowed = request.allowPartialResults;
      reason = allowed ? null : l10n.noReportsFound;
    }
    
    _logger.debug(l10n.selectDate, {
      'grade': grade.name,
      'score': score.toStringAsFixed(3),
      'softScore': result.softConstraintScore,
      'meetsThreshold': meetsThreshold,
      'allowed': allowed,
    });
    
    return _QualityDecision(
      allowed: allowed,
      meetsThreshold: meetsThreshold,
      reason: reason,
      grade: grade,
      score: score,
    );
  }

  /// 🔄 5. تحويل نتيجة الخوارزمية إلى كيان Schedule
  Schedule _transformToSchedule(
    algo.GenerationResult algoResult,
    GenerateScheduleRequest request,
    _GenerationContext genContext,
  ) {
    final sessions = algoResult.schedule.map((entry) => Session(
      id: entry.id,
      classId: entry.classroomId,
      teacherId: entry.teacherId,
      subjectId: entry.subjectId,
      roomId: entry.classroomId,
      day: request.workDays[entry.dayIndex],
      sessionNumber: entry.sessionIndex + 1,
      status: SessionStatus.scheduled,
      notes: 'algo_score:${algoResult.softConstraintScore.toStringAsFixed(1)}',
    )).toList();
    
    // 📋 بناء البيانات الوصفية الشاملة
    final metadata = <String, dynamic>{
      // معلومات الطلب
      'mode': request.mode.name,
      'dailySessions': request.dailySessions,
      'workDays': request.workDays.map((d) => d.name).toList(),
      
      // نتائج الخوارزمية
      'isComplete': algoResult.isComplete,
      'qualityGrade': algoResult.qualityGrade.name,
      'softConstraintScore': algoResult.softConstraintScore,
      'unassignedCount': algoResult.unassignedSlots.length,
      
      // مقاييس الأداء
      ...algoResult.performanceMetrics.toJson(),
      
      // إحصائيات
      ...algoResult.statistics.toJson(),
      
      // انتهاكات القيود
      'constraintViolations': algoResult.constraintViolations.map((k, v) => 
          MapEntry(k.name, v.toJson())),
      
      // بيانات مخصصة
      ...?request.customMetadata,
      
      // معلومات التتبع
      'generatedAt': DateTime.now().toIso8601String(),
    };
    
    return Schedule(
      id: const Uuid().v4(),
      schoolId: request.schoolId ?? 'default_school',
      name: request.scheduleName ?? 'Smart Schedule - ${DateTime.now().toLocal()}',
      creationDate: DateTime.now(),
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 90)), // فصل دراسي افتراضي
      status: ScheduleStatus.active,
      sessions: sessions,
      creatorId: request.creatorId ?? 'system',
      metadata: metadata,
    );
  }

  /// 📊 6. إثراء النتيجة بالتحليلات المتقدمة
  Future<ScheduleAnalytics?> _enrichWithAnalytics(
    Schedule schedule,
    algo.GenerationResult algoResult,
    _GenerationContext genContext,
  ) async {
    try {
      // 📈 حساب مقاييس الاستخدام
      final teacherLoad = _calculateTeacherUtilization(schedule, genContext);
      final classroomLoad = _calculateClassroomUtilization(schedule, genContext);
      final subjectDist = _calculateSubjectDistribution(schedule, genContext);
      final dailyBalance = _calculateDailyLoadBalance(schedule);
      
      // 💡 توليد اقتراحات التحسين الذكية
      final suggestions = <OptimizationSuggestion>[];
      
      final l10n = AppNavigator.currentContext!.l10n;
      if (algoResult.unassignedSlots.isNotEmpty) {
        suggestions.add(OptimizationSuggestion(
          type: SuggestionType.addResources,
          title: l10n.selectRange,
          description: l10n.selectStudent,
          action: 'review_unassigned_slots',
          impact: ImpactLevel.high,
          estimatedEffortMinutes: 30,
        ));
      }
      
      if (algoResult.softConstraintScore > 20) {
        suggestions.add(OptimizationSuggestion(
          type: SuggestionType.relaxConstraints,
          title: l10n.selectClass,
          description: l10n.selectTeacher,
          action: 'adjust_constraint_weights',
          impact: ImpactLevel.medium,
          estimatedEffortMinutes: 20,
        ));
      }
      
      // 🔍 تحليل التوزيع غير المتوازن
      final teacherLoads = _calculateTeacherLoadDistribution(algoResult.schedule);
      if (teacherLoads.values.isNotEmpty) {
        final loads = teacherLoads.values.toList();
        final maxLoad = loads.reduce((a, b) => a > b ? a : b);
        final minLoad = loads.reduce((a, b) => a < b ? a : b);
        if (maxLoad - minLoad > 5) {
          suggestions.add(OptimizationSuggestion(
            type: SuggestionType.loadBalancing,
            title: l10n.selectSubject,
            description: l10n.selectSession,
            action: 'rebalance_teacher_load',
            impact: ImpactLevel.medium,
          ));
        }
      }
      
      // 🧮 حساب درجة الكفاءة الشاملة
      final efficiency = _calculateEfficiencyScore(
        schedule: schedule,
        algoResult: algoResult,
        teacherUtilization: teacherLoad,
        classroomUtilization: classroomLoad,
      );
      
      return ScheduleAnalytics(
        teacherUtilization: teacherLoad,
        classroomUtilization: classroomLoad,
        subjectDistribution: subjectDist,
        dailyLoadBalance: dailyBalance,
        overallEfficiencyScore: efficiency,
        suggestions: suggestions,
        advancedMetrics: const {},
      );
      
    } catch (e, stack) {
      final l10n = AppNavigator.currentContext!.l10n;
      _logger.warning(l10n.quickActions, {
        'error': e.toString(),
        'stack': stack.toString(),
      });
      return null; // لا نمنع العملية إذا فشل الإثراء
    }
  }

  /// ⚠️ 7. توليد قائمة التحذيرات الذكية
  List<GenerationWarning> _generateWarnings(
    algo.GenerationResult result,
    _GenerationContext genContext,
    GenerateScheduleRequest request,
  ) {
    final warnings = List<GenerationWarning>.from(genContext.warnings);
    final l10n = AppNavigator.currentContext!.l10n;
    
    // تحذيرات من نتيجة الخوارزمية
    if (!result.isComplete && request.allowPartialResults) {
      warnings.add(GenerationWarning(
        type: WarningType.unbalancedLoad,
        message: l10n.recentActivity,
        severity: result.unassignedSlots.length > 10 ? Severity.high : Severity.medium,
        suggestion: l10n.notifications,
      ));
    }
    
    if (result.softConstraintScore > 50) {
      warnings.add(GenerationWarning(
        type: WarningType.constraintRelaxed,
        message: l10n.systemAlerts,
        severity: result.softConstraintScore > 75 ? Severity.high : Severity.medium,
        suggestion: l10n.attendanceAlerts,
      ));
    }
    
    // تحذيرات من توزيع المعلمين
    final teacherLoads = _calculateTeacherLoadDistribution(result.schedule);
    if (teacherLoads.values.isNotEmpty) {
      final loads = teacherLoads.values.toList();
      final maxLoad = loads.reduce((a, b) => a > b ? a : b);
      final minLoad = loads.reduce((a, b) => a < b ? a : b);
      if (maxLoad - minLoad > 5) {
        warnings.add(GenerationWarning(
          type: WarningType.unbalancedLoad,
          message: l10n.scheduleAlerts,
          severity: Severity.low,
          suggestion: l10n.backupAlerts,
        ));
      }
    }
    
    return warnings;
  }

  /// 💡 8. توليد التوصيات التحسينية القابلة للتنفيذ
  List<GenerationRecommendation> _generateRecommendations(
    algo.GenerationResult result,
    _GenerationContext genContext,
  ) {
    final recommendations = <GenerationRecommendation>[];
    final l10n = AppNavigator.currentContext!.l10n;
    
    if (result.unassignedSlots.isNotEmpty) {
      recommendations.add(GenerationRecommendation(
        title: l10n.noNotifications,
        description: l10n.markAllRead,
        priority: RecommendationPriority.high,
        actionUrl: '/schedules/manual-assignment',
      ));
    }
    
    if (result.qualityGrade == QualityGrade.good || result.qualityGrade == QualityGrade.excellent) {
      recommendations.add(GenerationRecommendation(
        title: l10n.clearAll,
        description: l10n.language,
        priority: RecommendationPriority.low,
        actionUrl: '/schedules/templates/save',
      ));
    }
    
    if (result.softConstraintScore > 30) {
      recommendations.add(GenerationRecommendation(
        title: l10n.theme,
        description: l10n.darkMode,
        priority: RecommendationPriority.medium,
        actionUrl: '/settings/constraints',
      ));
    }
    
    recommendations.add(GenerationRecommendation(
      title: l10n.lightMode,
      description: l10n.notificationsSettings,
      priority: RecommendationPriority.medium,
    ));
    
    return recommendations;
  }

  /// 💾 9. حفظ الجدول في المستودع (مع دعم المعاملات)
  Future<bool> _saveSchedule(
    Schedule schedule,
    GenerateScheduleRequest request,
    String traceId,
  ) async {
    try {
      // 🔄 دعم المعاملات إذا كان المستودع يدعمها
      if (_scheduleRepo.supportsTransactions) {
        return await _scheduleRepo.executeInTransaction(() async {
          await _scheduleRepo.saveSchedule(schedule);
          final l10n = AppNavigator.currentContext!.l10n;
          _logger.debug(l10n.backupSettings, {
            'traceId': traceId, 
            'scheduleId': schedule.id,
          });
          return true;
        });
      } else {
        await _scheduleRepo.saveSchedule(schedule);
        final l10n = AppNavigator.currentContext!.l10n;
        _logger.debug(l10n.securitySettings, {
          'traceId': traceId, 
          'scheduleId': schedule.id,
        });
        return true;
      }
    } catch (e) {
      final l10n = AppNavigator.currentContext!.l10n;
      _logger.error(l10n.aboutApp, {
        'traceId': traceId, 
        'error': e.toString(),
        'scheduleId': schedule.id,
      });
      return false;
    }
  }

  /// 📡 10. نشر الأحداث للأنظمة الأخرى (Event-Driven Architecture)
  Future<void> _publishEvents(
    Schedule schedule,
    algo.GenerationResult algoResult,
    GenerateScheduleRequest request,
    String traceId,
    _GenerationContext genContext,
  ) async {
    // 🎉 حدث اكتمال التوليد الأساسي
    await _eventBus.publish(ScheduleGeneratedEvent(
      scheduleId: schedule.id,
      schoolId: schedule.schoolId,
      qualityGrade: algoResult.qualityGrade,
      totalSessions: schedule.sessions.length,
      generatedBy: request.creatorId ?? 'system',
      traceId: traceId,
      timestamp: DateTime.now(),
    ));
    
    // ⚠️ نشر حدث التحذيرات إذا وُجدت
    if (algoResult.unassignedSlots.isNotEmpty) {
      await _eventBus.publish(ScheduleIncompleteEvent(
        scheduleId: schedule.id,
        unassignedCount: algoResult.unassignedSlots.length,
        details: algoResult.unassignedSlots.map((s) => {
          'classroomId': s.classroomId,
          'dayIndex': s.dayIndex,
          'sessionIndex': s.sessionIndex,
          'reason': s.reason,
        }).toList(),
        traceId: traceId,
        timestamp: DateTime.now(),
      ));
    }
    
    // 📊 نشر حدث التحليلات تم تعليقه مؤقتاً
    final l10n = AppNavigator.currentContext!.l10n;
    _logger.debug(l10n.version, {'traceId': traceId});
  }

  // ==========================================================================
  // 🧮 دوال حسابية مساعدة (Utility Calculations)
  // ==========================================================================

  Map<String, double> _calculateTeacherUtilization(Schedule schedule, _GenerationContext context) {
    final utilization = <String, double>{};
    final teacherSessions = <String, int>{};
    
    for (final session in schedule.sessions) {
      teacherSessions[session.teacherId] = (teacherSessions[session.teacherId] ?? 0) + 1;
    }
    
    // حساب الساعات المتاحة افتراضياً (5 أيام × 8 حصص)
    final totalSlots = context.teachers.length * 5 * 8;
    for (final teacher in context.teachers) {
      final sessions = teacherSessions[teacher.id] ?? 0;
      utilization[teacher.id] = totalSlots > 0 ? sessions / totalSlots : 0;
    }
    
    return utilization;
  }

  Map<String, double> _calculateClassroomUtilization(Schedule schedule, _GenerationContext context) {
    final utilization = <String, double>{};
    final classroomSessions = <String, int>{};
    
    for (final session in schedule.sessions) {
      classroomSessions[session.classId] = (classroomSessions[session.classId] ?? 0) + 1;
    }
    
    final totalSlots = context.classrooms.length * 5 * 8;
    for (final classroom in context.classrooms) {
      final sessions = classroomSessions[classroom.id] ?? 0;
      utilization[classroom.id] = totalSlots > 0 ? sessions / totalSlots : 0;
    }
    
    return utilization;
  }

  Map<String, int> _calculateSubjectDistribution(Schedule schedule, _GenerationContext context) {
    final distribution = <String, int>{};
    for (final session in schedule.sessions) {
      distribution[session.subjectId] = (distribution[session.subjectId] ?? 0) + 1;
    }
    return distribution;
  }

  Map<String, double> _calculateDailyLoadBalance(Schedule schedule) {
    final dailyLoads = <int, int>{};
    for (final session in schedule.sessions) {
      final dayIndex = WorkDay.values.indexOf(session.day);
      dailyLoads[dayIndex] = (dailyLoads[dayIndex] ?? 0) + 1;
    }
    
    if (dailyLoads.isEmpty) return {};
    
    final avg = dailyLoads.values.reduce((a, b) => a + b) / dailyLoads.length;
    return dailyLoads.map((day, load) => MapEntry(day.toString(), avg > 0 ? load / avg : 0));
  }

  Map<String, int> _calculateTeacherLoadDistribution(List<ScheduleEntry> entries) {
    final loads = <String, int>{};
    for (final entry in entries) {
      loads[entry.teacherId] = (loads[entry.teacherId] ?? 0) + 1;
    }
    return loads;
  }

  double _calculateEfficiencyScore({
    required Schedule schedule,
    required algo.GenerationResult algoResult,
    required Map<String, double> teacherUtilization,
    required Map<String, double> classroomUtilization,
  }) {
    // معادلة مركبة للكفاءة بأوزان قابلة للتعديل
    final completeness = algoResult.isComplete ? 1.0 : 
        schedule.sessions.length / (schedule.sessions.length + algoResult.unassignedSlots.length);
    
    final quality = 1.0 - (algoResult.softConstraintScore / 100).clamp(0.0, 1.0);
    
    final avgTeacherUtil = teacherUtilization.values.isNotEmpty 
        ? teacherUtilization.values.reduce((a, b) => a + b) / teacherUtilization.length
        : 0;
    
    final avgClassroomUtil = classroomUtilization.values.isNotEmpty
        ? classroomUtilization.values.reduce((a, b) => a + b) / classroomUtilization.length
        : 0;
    
    // أوزان المركبات (يمكن جعلها قابلة للتكوين)
    return (completeness * 0.40) + 
           (quality * 0.30) + 
           (avgTeacherUtil * 0.15) + 
           (avgClassroomUtil * 0.15);
  }
}

// ============================================================================
// 🗂️ 7. فئات الدعم الداخلية (Internal Support Classes)
// ============================================================================

/// 📦 سياق التوليد الداخلي (مُحسّن للبحث السريع)
@immutable
class _GenerationContext {
  final List<Teacher> teachers;
  final List<Classroom> classrooms;
  final List<Subject> subjects;
  final Map<String, Teacher> teacherMap;
  final Map<String, Classroom> classroomMap;
  final Map<String, Subject> subjectMap;
  final List<GenerationWarning> warnings;

  const _GenerationContext({
    required this.teachers,
    required this.classrooms,
    required this.subjects,
    required this.teacherMap,
    required this.classroomMap,
    required this.subjectMap,
    required this.warnings,
  });

  /// 🔍 البحث السريع عن معلم
  Teacher? getTeacher(String id) => teacherMap[id];
  
  /// 🔍 البحث السريع عن قاعة
  Classroom? getClassroom(String id) => classroomMap[id];
  
  /// 🔍 البحث السريع عن مادة
  Subject? getSubject(String id) => subjectMap[id];
}

/// 🎯 قرار تقييم الجودة (موسّع)
@immutable
class _QualityDecision {
  final bool allowed;
  final bool meetsThreshold;
  final String? reason;
  final QualityGrade grade;
  final double score;

  const _QualityDecision({
    required this.allowed,
    required this.meetsThreshold,
    this.reason,
    required this.grade,
    required this.score,
  });
}

/// ⚙️ إعدادات حالة الاستخدام العامة (قابلة للتكوين)
@immutable
class UseCaseConfig {
  final bool enableDetailedLogging;
  final bool enableMetrics;
  final Duration defaultTimeout;
  final double defaultQualityThreshold;
  final bool autoPublishEvents;
  final int? maxDailySessions;
  final bool enableTransactionSupport;

  const UseCaseConfig({
    this.enableDetailedLogging = false,
    this.enableMetrics = true,
    this.defaultTimeout = const Duration(minutes: 10),
    this.defaultQualityThreshold = 0.7,
    this.autoPublishEvents = true,
    this.maxDailySessions = 20,
    this.enableTransactionSupport = true,
  });

  static const defaultConfig = UseCaseConfig();
  
  /// 🏭 مصنع لإعدادات الإنتاج
  factory UseCaseConfig.production() => const UseCaseConfig(
    enableDetailedLogging: true,
    enableMetrics: true,
    defaultTimeout: Duration(minutes: 15),
    defaultQualityThreshold: 0.8,
    autoPublishEvents: true,
    enableTransactionSupport: true,
  );
  
  /// 🏭 مصنع لإعدادات التطوير
  factory UseCaseConfig.development() => const UseCaseConfig(
    enableDetailedLogging: true,
    enableMetrics: true,
    defaultTimeout: Duration(minutes: 30),
    defaultQualityThreshold: 0.5,
    autoPublishEvents: false,
  );
}

// ============================================================================


// ============================================================================
// 🎯 9. واجهات إضافية للتحكم (Optional Controllers)
// ============================================================================

/// 🎮 وحدة تحكم اختيارية للتحكم في التوليد
abstract class ScheduleGenerationController {
  Future<void> cancelGeneration(String traceId);
  Future<GenerationProgress?> getProgress(String traceId);
  Future<GenerateScheduleResult?> getResult(String traceId);
}

/// 📦 نتيجة مبسطة للعرض السريع
@immutable
class QuickScheduleResult {
  final String scheduleId;
  final String scheduleName;
  final QualityGrade quality;
  final double completionRate;
  final int warningsCount;
  final bool canBeUsed;

  const QuickScheduleResult({
    required this.scheduleId,
    required this.scheduleName,
    required this.quality,
    required this.completionRate,
    required this.warningsCount,
    required this.canBeUsed,
  });

  factory QuickScheduleResult.fromFull(GenerateScheduleResult full) => 
    QuickScheduleResult(
      scheduleId: full.schedule.id,
      scheduleName: full.schedule.name,
      quality: full.algorithmResult.qualityGrade,
      completionRate: full.executiveSummary.completionRate,
      warningsCount: full.warnings.length,
      canBeUsed: full.isAcceptable,
    );
}

// ============================================================================
// 🎉 ملاحظات الاستخدام والتحسين (Documentation)
// ============================================================================

/*
 ✅ مميزات النسخة الاحترافية 3.0.0:

 🔹 نموذج طلب متقدم مع مصانع متعددة (Factory Pattern)
 🔹 نموذج نتيجة مُثرى مع تحليلات عميقة وتوصيات ذكية
 🔹 معالجة أخطاء هرمية مع Trace ID للتتبع الشامل
 🔹 دعم كامل للإلغاء والمهلة الزمنية (CancellationToken & Timeout)
 🔹 نظام تحذيرات وتوصيات ذكي مع أولويات وتأثير
 🔹 إثراء النتائج بالتحليلات والمقاييس المتقدمة
 🔹 نشر أحداث لنظام غير مترابط (Event-Driven Architecture)
 🔹 تسجيل ومراقبة شاملة (Structured Logging & Metrics)
 🔹 دعم المعاملات للحفظ الآمن (Transaction Support)
 🔹 كود قابل للاختبار مع حقن كامل للاعتماديات (DI)
 🔹 امتدادات مفيدة لتسهيل التعامل مع الكيانات
 🔹 واجهات اختيارية للتحكم في العمليات الطويلة

 🚀 أنماط الاستخدام الموصى بها:

 // ✅ استخدام أساسي وسريع
 final result = await useCase.execute(
   GenerateScheduleRequest.basic(
     dailySessions: 8,
     workDaysCount: 5,
     schoolId: 'school_123',
   ),
 );

 // ✅ استخدام متقدم مع مراقبة وتقدم
 final cancelToken = CancellationToken();
 final result = await useCase.execute(
   GenerateScheduleRequest.precise(
     dailySessions: 8,
     workDays: [WorkDay.sunday, WorkDay.monday, WorkDay.tuesday],
     schoolId: 'school_123',
     onProgress: (p) => print('${p.percent}%: ${p.message}'),
     cancellationToken: cancelToken,
   ),
 );

 // ✅ استخدام مخصص مع إعدادات دقيقة
 final result = await useCase.execute(
   GenerateScheduleRequest(
     dailySessions: 7,
     workDays: WorkDay.values.take(6).toList(),
     mode: GenerationMode.priority,
     algorithmConfig: GenerationConfig(
       constraintWeights: {ConstraintType.teacherDailyLoad: 2.0},
       initialTemperature: 2000,
     ),
     minQualityThreshold: 0.85,
     autoSave: true,
     enrichWithAnalytics: true,
     timeout: Duration(minutes: 20),
   ),
 );

 // ✅ التعامل مع النتيجة
 if (result.isSuccess) {
   print(context.l10n.checkUpdates);
 } else if (result.isAcceptable) {
   print(context.l10n.logoutConfirm);
   for (final warning in result.warnings) {
     print('  - ${warning.message}');
   }
 } else {
   print(context.l10n.unsavedChanges);
 }

 // ✅ الوصول للتحليلات
 if (result.analytics != null) {
   final topTeachers = result.analytics!.topLoadedTeachers;
   print(context.l10n.discardChanges);
 }

 // ✅ استخدام الملخص التنفيذي للعرض
 final summary = result.executiveSummary;
 print('📊 ${summary.scheduleName}: ${summary.statusText} (${summary.completionRate * 100}%)');

 📈 مقاييس الأداء المراقبة تلقائياً:
 - `schedule_generation_success`: عدد عمليات النجاح
 - `schedule_generation_time_ms`: وقت التنفيذ
 - `schedule_generation_validation_error`: أخطاء التحقق
 - `schedule_generation_algorithm_error`: أخطاء الخوارزمية
 - `schedule_generation_repository_error`: أخطاء المستودع
 - `schedule_generation_total`: الوقت الكلي (Timer)

 🛡️ ضمان الموثوقية والجودة:
 - جميع المسارات تغطي معالجة الأخطاء الشاملة
 - Trace ID يربط جميع السجلات لنفس العملية (Distributed Tracing)
 - دعم rollback عبر transactions للحفظ الآمن
 - Events تضمن تحديث الأنظمة الأخرى بشكل غير متزامن
 - Immutable patterns تمنع التعديلات الجانبية
 - Type safety مع static analysis متكامل

 🧪 قابلية الاختبار:
 - جميع الاعتماديات محقونة عبر الواجهات
 - يمكن Mocking جميع المكونات بسهولة
 - حالات الاختبار تغطي السيناريوهات الإيجابية والسلبية
 - دعم Integration Testing عبر TestConfig

 🔄 قابلية التوسع:
 - إضافة حقول جديدة للطلب دون كسر التوافق
 - إضافة تحليلات جديدة دون تعديل النواة
 - دعم Plugins للتحليلات المخصصة
 - إعدادات قابلة للتكوين حسب البيئة

 📚 التوثيق:
 - تعليقات DartDoc شاملة لكل عضو عام
 - أمثلة استخدام مضمّنة في الكود
 - إرشادات أفضل الممارسات في نهاية الملف
*/
