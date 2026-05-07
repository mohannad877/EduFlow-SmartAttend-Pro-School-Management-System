import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:school_schedule_app/core/database/attendance_database.dart';

// ============================================================================
// AuditLogger — Automatic database operation audit trail
// ============================================================================

class AuditLogger {
  static Future<void> logAction({
    required AttendanceDatabase db,
    int? userId,
    required String action,         // 'create', 'update', 'delete'
    required String targetTable,
    required int recordId,
    Map<String, dynamic>? oldValue,
    Map<String, dynamic>? newValue,
  }) async {
    try {
      await db.into(db.auditLog).insert(
            AuditLogCompanion.insert(
              userId: Value(userId),
              action: action,
              targetTable: targetTable,
              recordId: recordId,
              oldValue: Value(oldValue != null ? jsonEncode(oldValue) : null),
              newValue: Value(newValue != null ? jsonEncode(newValue) : null),
            ),
          );
    } catch (e) {
      // Swallow audit failures so they never block main business logic.
      debugPrint('AuditLogger failed: $e');
    }
  }

  // ── Convenience wrappers ──────────────────────────────────────────────────

  /// Wraps an INSERT with automatic audit logging.
  static Future<int> insertWithAudit<T extends Table, D extends DataClass>({
    required AttendanceDatabase db,
    required TableInfo<T, D> table,
    required Insertable<D> entity,
    int? userId,
    Map<String, dynamic>? newValueData,
  }) async {
    final id = await db.into(table).insert(entity);
    await logAction(
      db: db,
      userId: userId,
      action: 'create',
      targetTable: table.actualTableName,
      recordId: id,
      newValue: newValueData,
    );
    return id;
  }

  /// Wraps an UPDATE with automatic audit logging.
  static Future<bool> updateWithAudit<T extends Table, D extends DataClass>({
    required AttendanceDatabase db,
    required TableInfo<T, D> table,
    required Insertable<D> entity,
    required int recordId,
    int? userId,
    Map<String, dynamic>? oldValueData,
    Map<String, dynamic>? newValueData,
  }) async {
    final success = await db.update(table).replace(entity);
    if (success) {
      await logAction(
        db: db,
        userId: userId,
        action: 'update',
        targetTable: table.actualTableName,
        recordId: recordId,
        oldValue: oldValueData,
        newValue: newValueData,
      );
    }
    return success;
  }

  /// Wraps a DELETE with automatic audit logging.
  /// The [pkColumn] selector extracts the primary key expression.
  static Future<int> deleteWithAudit<T extends Table, D extends DataClass>({
    required AttendanceDatabase db,
    required TableInfo<T, D> table,
    required Expression<bool> Function(T) pkFilter,
    required int recordId,
    int? userId,
    Map<String, dynamic>? oldValueData,
  }) async {
    final count = await (db.delete(table)..where(pkFilter)).go();
    if (count > 0) {
      await logAction(
        db: db,
        userId: userId,
        action: 'delete',
        targetTable: table.actualTableName,
        recordId: recordId,
        oldValue: oldValueData,
      );
    }
    return count;
  }
}
