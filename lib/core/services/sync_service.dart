// ============================================================================
// 📦 sync_service.dart  (REFACTORED — Context-Free)
// 🎯 Pure sync/audit service. All localized descriptions received as parameters
//    — no BuildContext, no NavigatorKey, safe for Background Tasks & Isolates.
// ============================================================================
// ============================================================================
// 📦 الملف: sync_service.dart
// 🎯 الوصف: خدمة المزامنة وسجل النشاطات - تضمن تتبع جميع العمليات الحساسة
//            (حذف، تعديل، إضافة) وربطها بمنظومة Audit Log
// ============================================================================

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:school_schedule_app/core/database/attendance_database.dart';
import 'package:school_schedule_app/core/database/audit_logger.dart';

// ============================================================================
// 🏷️ أنواع العمليات القابلة للتتبع
// ============================================================================

enum SyncAction {
  create('create'),
  update('update'),
  delete('delete'),
  bulkCreate('bulk_create'),
  bulkDelete('bulk_delete'),
  import('import'),
  export('export'),
  generateSchedule('generate_schedule'),
  backup('backup'),
  restore('restore');

  const SyncAction(this.value);
  final String value;
}

// ============================================================================
// 📦 نموذج حدث المزامنة
// ============================================================================

class SyncEvent {
  final SyncAction action;
  final String targetTable;
  final int recordId;
  final Map<String, dynamic>? oldValue;
  final Map<String, dynamic>? newValue;
  final String? description;
  final int? userId;
  final DateTime timestamp;

  SyncEvent({
    required this.action,
    required this.targetTable,
    required this.recordId,
    this.oldValue,
    this.newValue,
    this.description,
    this.userId,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

// ============================================================================
// 🔄 خدمة المزامنة الرئيسية (SyncService)
// ============================================================================

/// خدمة المزامنة تضمن تتبع جميع العمليات الحساسة في النظام
/// وربطها بمنظومة Audit Log لقابلية التتبع الكاملة.
class SyncService {
  final AttendanceDatabase _db;

  /// قائمة انتظار الأحداث غير المسجّلة (للحماية من فشل الاتصال)
  final List<SyncEvent> _pendingEvents = [];

  SyncService(this._db);

  // ── الواجهة العامة ──────────────────────────────────────────────────────────

  /// تسجيل حدث إضافة سجل جديد مع ضمان تسجيله في Audit Log
  Future<void> logCreate({
    required String targetTable,
    required int recordId,
    Map<String, dynamic>? newValue,
    String? description,
    int? userId,
  }) async {
    await _syncEvent(SyncEvent(
      action: SyncAction.create,
      targetTable: targetTable,
      recordId: recordId,
      newValue: newValue,
      description: description,
      userId: userId,
    ));
  }

  /// تسجيل حدث تعديل سجل موجود مع حفظ القيم القديمة والجديدة
  Future<void> logUpdate({
    required String targetTable,
    required int recordId,
    Map<String, dynamic>? oldValue,
    Map<String, dynamic>? newValue,
    String? description,
    int? userId,
  }) async {
    await _syncEvent(SyncEvent(
      action: SyncAction.update,
      targetTable: targetTable,
      recordId: recordId,
      oldValue: oldValue,
      newValue: newValue,
      description: description,
      userId: userId,
    ));
  }

  /// تسجيل حدث حذف سجل مع حفظ القيم القديمة قبل الحذف
  Future<void> logDelete({
    required String targetTable,
    required int recordId,
    Map<String, dynamic>? oldValue,
    String? description,
    int? userId,
  }) async {
    await _syncEvent(SyncEvent(
      action: SyncAction.delete,
      targetTable: targetTable,
      recordId: recordId,
      oldValue: oldValue,
      description: description,
      userId: userId,
    ));
  }

  /// تسجيل حدث استيراد دفعي (مثل استيراد طلاب من Excel)
  Future<void> logBulkImport({
    required String targetTable,
    required int recordCount,
    String? description,
    int? userId,
  }) async {
    await _syncEvent(SyncEvent(
      action: SyncAction.import,
      targetTable: targetTable,
      recordId: recordCount,
      newValue: {
        'count': recordCount,
        'description': description ?? 'bulk_import',
      },
      description: description,
      userId: userId,
    ));
  }

  /// تسجيل حدث توليد جدول دراسي
  Future<void> logScheduleGeneration({
    required String scheduleId,
    required bool isComplete,
    required int sessionCount,
    required int unassignedCount,
    String? qualityGrade,
    int? userId,
  }) async {
    await _syncEvent(SyncEvent(
      action: SyncAction.generateSchedule,
      targetTable: 'schedules',
      recordId: scheduleId.hashCode,
      newValue: {
        'scheduleId': scheduleId,
        'isComplete': isComplete,
        'sessionCount': sessionCount,
        'unassignedCount': unassignedCount,
        'qualityGrade': qualityGrade,
      },
      description: 'schedule_generation',
      userId: userId,
    ));
  }

  /// تسجيل حدث نسخ احتياطي
  Future<void> logBackup({
    required String backupPath,
    required bool isSuccess,
    int? fileSizeBytes,
    int? userId,
  }) async {
    await _syncEvent(SyncEvent(
      action: SyncAction.backup,
      targetTable: 'system',
      recordId: 0,
      newValue: {
        'path': backupPath,
        'success': isSuccess,
        'sizeBytes': fileSizeBytes,
      },
      description: isSuccess ? 'backup_success' : 'backup_failed',
      userId: userId,
    ));
  }

  /// مزامنة حذف طالب مع سجل النشاطات (وظيفة مخصصة لضمان التتبع)
  Future<void> syncStudentDeletion({
    required int studentId,
    required String studentName,
    required String studentBarcode,
    int? userId,
  }) async {
    await logDelete(
      targetTable: 'att_students',
      recordId: studentId,
      oldValue: {
        'id': studentId,
        'name': studentName,
        'barcode': studentBarcode,
        'deletedAt': DateTime.now().toIso8601String(),
      },
      description: 'student_deleted: $studentName',
      userId: userId,
    );
  }

  /// مزامنة تعديل بيانات طالب مع سجل النشاطات
  Future<void> syncStudentUpdate({
    required int studentId,
    required Map<String, dynamic> oldData,
    required Map<String, dynamic> newData,
    int? userId,
  }) async {
    await logUpdate(
      targetTable: 'att_students',
      recordId: studentId,
      oldValue: oldData,
      newValue: newData,
      description: 'student_updated: ${newData['name'] ?? studentId}',
      userId: userId,
    );
  }

  // ── الوظائف الداخلية ────────────────────────────────────────────────────────

  /// تنفيذ تسجيل الحدث مع معالجة الأخطاء
  Future<void> _syncEvent(SyncEvent event) async {
    try {
      await AuditLogger.logAction(
        db: _db,
        userId: event.userId,
        action: event.action.value,
        targetTable: event.targetTable,
        recordId: event.recordId,
        oldValue: event.oldValue,
        newValue: _buildNewValue(event),
      );

      // إزالة الحدث من قائمة الانتظار إذا كان موجوداً
      _pendingEvents.remove(event);

      debugPrint('✅ SyncService: ${event.action.value} on ${event.targetTable}#${event.recordId}');
    } catch (e) {
      // إضافة الحدث لقائمة الانتظار في حالة الفشل
      _pendingEvents.add(event);
      debugPrint('⚠️ SyncService: Failed to log event, queued. Error: $e');
    }
  }

  /// بناء خريطة القيم الجديدة مع إضافة البيانات الوصفية
  Map<String, dynamic> _buildNewValue(SyncEvent event) {
    final base = event.newValue ?? {};
    return {
      ...base,
      if (event.description != null) '_description': event.description,
      '_timestamp': event.timestamp.toIso8601String(),
      '_action': event.action.value,
    };
  }

  /// محاولة إعادة تسجيل الأحداث المعلقة في قائمة الانتظار
  Future<int> flushPendingEvents() async {
    if (_pendingEvents.isEmpty) return 0;

    var flushed = 0;
    final toFlush = List<SyncEvent>.from(_pendingEvents);

    for (final event in toFlush) {
      try {
        await AuditLogger.logAction(
          db: _db,
          userId: event.userId,
          action: event.action.value,
          targetTable: event.targetTable,
          recordId: event.recordId,
          oldValue: event.oldValue,
          newValue: _buildNewValue(event),
        );
        _pendingEvents.remove(event);
        flushed++;
      } catch (e) {
        debugPrint('⚠️ SyncService: Still cannot flush event: $e');
      }
    }

    debugPrint('🔄 SyncService: Flushed $flushed pending events');
    return flushed;
  }

  /// عدد الأحداث المعلقة
  int get pendingCount => _pendingEvents.length;

  /// تصدير الأحداث المعلقة كـ JSON (للتشخيص)
  String exportPendingAsJson() {
    return jsonEncode(_pendingEvents.map((e) => {
      'action': e.action.value,
      'table': e.targetTable,
      'recordId': e.recordId,
      'timestamp': e.timestamp.toIso8601String(),
      'description': e.description,
    }).toList());
  }
}
