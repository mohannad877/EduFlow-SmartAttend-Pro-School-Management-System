import 'dart:isolate';
import 'package:school_schedule_app/domain/entities/enums.dart';

import 'package:school_schedule_app/domain/usecases/algorithm/intelligent_schedule_generator.dart';
import 'package:school_schedule_app/domain/usecases/algorithm/schedule_validator.dart';

class IsolateGenerationRequest {
  final int dailySessions;
  final List<WorkDay> workDays;
  final List<String>? targetClassroomIds;
  final GenerationMode mode;
  final GenerationConfig config;
  final GenerationData data;
  final SendPort? progressPort;

  IsolateGenerationRequest({
    required this.dailySessions,
    required this.workDays,
    this.targetClassroomIds,
    required this.mode,
    required this.config,
    required this.data,
    this.progressPort,
  });
}

Future<GenerationResult> runGenerationOptimizationInIsolate(IsolateGenerationRequest request) async {
  return await Isolate.run(() async {
    // 1️⃣ إنشاء مثيل معزول للمولد (بدون مخازن بيانات)
    final validator = ScheduleValidator();
    // تمرير null للمخازن لأننا سنستخدم generateScheduleFromData
    final generator = IntelligentScheduleGenerator(
      null, null, null, null, validator
    );

    // ⚠️ استخدام نسخة آمنة من الإعدادات (بدون metricsCollector و cancellationToken)
    // هذه الكائنات تحتوي على Completer وغير قابلة للإرسال عبر Isolate
    final safeConfig = request.config.toIsolateSafe();

    // 2️⃣ تشغيل الخوارزمية الثقيلة داخل عملية Isolate
    return await generator.generateScheduleFromData(
      dailySessions: request.dailySessions,
      workDays: request.workDays,
      targetClassroomIds: request.targetClassroomIds,
      mode: request.mode,
      config: safeConfig.copyWith(
        // إرسال التقدم عبر SendPort باستخدام Records لتجنب مشاكل الذاكرة
        onProgress: request.progressPort != null 
          ? (progress) {
              request.progressPort!.send((progress.phase.index, progress.progress, progress.message));
            }
          : null,
      ),
      data: request.data,
    );
  });
}
