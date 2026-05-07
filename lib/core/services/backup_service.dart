import 'package:school_schedule_app/core/navigation/app_router.dart';
import 'package:school_schedule_app/core/utils/l10n_extension.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ============================================================================
// BackupService — Real SQLite backup & restore
// ============================================================================
/// Manages backup and restore of both databases:
///   • school_timetable.sqlite  (timetable module — GetIt/Drift)
///   • school_attendance.db     (attendance module — Riverpod/Drift)
class BackupService {
  static const String _timetableDbName = 'school_timetable.sqlite';
  static const String _attendanceDbName = 'school_attendance.db';
  static const String _prefAutoBackupInterval = 'auto_backup_interval_days';
  static const String _prefLastBackupDate = 'last_backup_date';

  // ── Auto Backup Logic ──────────────────────────────────────────────────────

  /// Get the configured auto backup interval in days (0 means disabled)
  static Future<int> getAutoBackupInterval() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_prefAutoBackupInterval) ?? 0;
  }

  /// Update the auto backup interval
  static Future<void> setAutoBackupInterval(int days) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefAutoBackupInterval, days);
  }

  /// Check and run auto backup if needed. Should be called on app startup.
  static Future<bool> checkAndRunAutoBackup() async {
    try {
      final interval = await getAutoBackupInterval();
      if (interval <= 0) return false;

      final prefs = await SharedPreferences.getInstance();
      final lastBackupStr = prefs.getString(_prefLastBackupDate);
      
      var needsBackup = false;
      if (lastBackupStr == null) {
        needsBackup = true;
      } else {
        final lastBackup = DateTime.tryParse(lastBackupStr);
        if (lastBackup == null) {
          needsBackup = true;
        } else {
          final diff = DateTime.now().difference(lastBackup).inDays;
          if (diff >= interval) {
            needsBackup = true;
          }
        }
      }

      if (needsBackup) {
        final result = await createBackup();
        if (result.isSuccess) {
          await prefs.setString(_prefLastBackupDate, DateTime.now().toIso8601String());
          return true;
        }
      }
      return false;
    } catch (e) {
      debugPrint('Auto backup failed: \$e');
      return false;
    }
  }

  // ── locate ─────────────────────────────────────────────────────────────────

  static Future<String> get _dbDirectory async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  static Future<File> get _timetableDbFile async {
    final dir = await _dbDirectory;
    return File(p.join(dir, _timetableDbName));
  }

  static Future<File> get _attendanceDbFile async {
    final dir = await _dbDirectory;
    return File(p.join(dir, _attendanceDbName));
  }

  // ── backup ─────────────────────────────────────────────────────────────────

  /// Creates a timestamped backup folder and copies both DB files into it.
  /// Returns BackupResult with the backup path or error.
  static Future<BackupResult> createBackup({
    void Function(String message, double progress)? onProgress,
  }) async {
    try {
      final context = AppNavigator.navigatorKey.currentContext;
      onProgress?.call(context != null ? context.l10n.backupInProgress : 'Starting backup...', 0.1);

      final docsDir = await getApplicationDocumentsDirectory();
      final timestamp = _formatTimestamp(DateTime.now());
      final backupDir = Directory(p.join(docsDir.path, 'backups', timestamp));
      await backupDir.create(recursive: true);

      onProgress?.call(AppNavigator.navigatorKey.currentContext!.l10n.backupDatabase, 0.35);
      final timetableDb = await _timetableDbFile;
      if (await timetableDb.exists()) {
        await timetableDb.copy(p.join(backupDir.path, _timetableDbName));
      }

      onProgress?.call(AppNavigator.navigatorKey.currentContext!.l10n.backupAttendance, 0.65);
      final attendanceDb = await _attendanceDbFile;
      if (await attendanceDb.exists()) {
        await attendanceDb.copy(p.join(backupDir.path, _attendanceDbName));
      }

      // Write manifest
      onProgress?.call(AppNavigator.navigatorKey.currentContext!.l10n.backupWritingManifest, 0.85);
      final manifest = File(p.join(backupDir.path, 'backup_info.txt'));
      await manifest.writeAsString(
        'Backup Date: ${DateTime.now().toIso8601String()}\n'
        'Timetable DB: $_timetableDbName\n'
        'Attendance DB: $_attendanceDbName\n'
        'Version: 2.0.0\n',
      );

      onProgress?.call(AppNavigator.navigatorKey.currentContext!.l10n.backupComplete, 1.0);

      return BackupResult.success(
        path: backupDir.path,
        timestamp: timestamp,
        timetableSize: await _getFileSize(timetableDb),
        attendanceSize: await _getFileSize(attendanceDb),
      );
    } catch (e, stack) {
      debugPrint('Backup failed: $e\n$stack');
      return BackupResult.failure(AppNavigator.navigatorKey.currentContext?.l10n.backupFailed ?? 'Backup failed');
    }
  }

  /// Shares the backup folder as files using share_plus.
  static Future<void> shareBackup(String backupPath) async {
    final dir = Directory(backupPath);
    final files = dir.listSync().whereType<File>().toList();
    await Share.shareXFiles(
      files.map((f) => XFile(f.path)).toList(),
      subject: AppNavigator.navigatorKey.currentContext!.l10n.share,
    );
  }

  // ── restore ────────────────────────────────────────────────────────────────

  /// Lets user pick a backup directory and restores both DB files.
  /// ⚠️ CLOSES any active DB connections before replacing files.
  static Future<RestoreResult> restoreFromDirectory({
    required String backupPath,
    void Function(String message, double progress)? onProgress,
  }) async {
    try {
      onProgress?.call(AppNavigator.navigatorKey.currentContext!.l10n.restoreCheck, 0.1);

      final backupDir = Directory(backupPath);
      if (!await backupDir.exists()) {
        return RestoreResult.failure(AppNavigator.navigatorKey.currentContext!.l10n.restoreFolderNotFound);
      }

      final backupTimetable = File(p.join(backupPath, _timetableDbName));
      final backupAttendance = File(p.join(backupPath, _attendanceDbName));

      final hasTimetable = await backupTimetable.exists();
      final hasAttendance = await backupAttendance.exists();

      if (!hasTimetable && !hasAttendance) {
        return RestoreResult.failure(
          AppNavigator.navigatorKey.currentContext!.l10n.restoreNoDbFiles,
        );
      }

      final dbDir = await _dbDirectory;

      if (hasTimetable) {
        onProgress?.call(AppNavigator.navigatorKey.currentContext!.l10n.restoringTimetableDb, 0.4);
        await backupTimetable.copy(p.join(dbDir, _timetableDbName));
      }

      if (hasAttendance) {
        onProgress?.call(AppNavigator.navigatorKey.currentContext!.l10n.restoringAttendanceDb, 0.7);
        await backupAttendance.copy(p.join(dbDir, _attendanceDbName));
      }

      onProgress?.call(AppNavigator.navigatorKey.currentContext!.l10n.restoreComplete, 1.0);

      return RestoreResult.success(
        timetableRestored: hasTimetable,
        attendanceRestored: hasAttendance,
      );
    } catch (e, stack) {
      debugPrint('Restore failed: $e\n$stack');
      return RestoreResult.failure(AppNavigator.navigatorKey.currentContext!.l10n.restoreFailedGeneric);
    }
  }

  /// Picks a backup folder using FilePicker and restores both databases.
  static Future<RestoreResult> pickAndRestore({
    void Function(String message, double progress)? onProgress,
  }) async {
    try {
      final result = await FilePicker.platform.getDirectoryPath(
        dialogTitle: AppNavigator.navigatorKey.currentContext!.l10n.selectBackupFolder,
      );

      if (result == null) {
        return RestoreResult.cancelled();
      }

      return await restoreFromDirectory(
        backupPath: result,
        onProgress: onProgress,
      );
    } catch (e) {
      return RestoreResult.failure(AppNavigator.navigatorKey.currentContext!.l10n.restoreFailedGeneric);
    }
  }

  // ── history ────────────────────────────────────────────────────────────────

  /// Returns a list of available backup entries, sorted newest first.
  static Future<List<BackupEntry>> getBackupHistory() async {
    try {
      final docsDir = await getApplicationDocumentsDirectory();
      final backupsDir = Directory(p.join(docsDir.path, 'backups'));

      if (!await backupsDir.exists()) return [];

      final dirs = backupsDir
          .listSync()
          .whereType<Directory>()
          .toList()
        ..sort((a, b) => b.path.compareTo(a.path));

      final entries = <BackupEntry>[];
      for (final dir in dirs) {
        final timetableFile = File(p.join(dir.path, _timetableDbName));
        final attendanceFile = File(p.join(dir.path, _attendanceDbName));
        final manifestFile = File(p.join(dir.path, 'backup_info.txt'));

        String? dateStr = p.basename(dir.path);
        if (await manifestFile.exists()) {
          final content = await manifestFile.readAsString();
          final match = RegExp(r'Backup Date: (.+)').firstMatch(content);
          if (match != null) dateStr = match.group(1);
        }

        entries.add(BackupEntry(
          path: dir.path,
          timestamp: dateStr ?? p.basename(dir.path),
          timetableSize: await _getFileSize(timetableFile),
          attendanceSize: await _getFileSize(attendanceFile),
        ));
      }

      return entries;
    } catch (e) {
      debugPrint('Error loading backup history: $e');
      return [];
    }
  }

  /// Deletes a specific backup entry.
  static Future<bool> deleteBackup(String backupPath) async {
    try {
      final dir = Directory(backupPath);
      if (await dir.exists()) {
        await dir.delete(recursive: true);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // ── helpers ────────────────────────────────────────────────────────────────

  static String _formatTimestamp(DateTime dt) {
    return '${dt.year}-${_pad(dt.month)}-${_pad(dt.day)}_${_pad(dt.hour)}-${_pad(dt.minute)}-${_pad(dt.second)}';
  }

  static String _pad(int n) => n.toString().padLeft(2, '0');

  static Future<int> _getFileSize(File file) async {
    try {
      return await file.exists() ? await file.length() : 0;
    } catch (_) {
      return 0;
    }
  }

  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }
}

// ── Result models ─────────────────────────────────────────────────────────────

class BackupResult {
  final bool isSuccess;
  final String? path;
  final String? timestamp;
  final int timetableSize;
  final int attendanceSize;
  final String? error;

  const BackupResult._({
    required this.isSuccess,
    this.path,
    this.timestamp,
    this.timetableSize = 0,
    this.attendanceSize = 0,
    this.error,
  });

  factory BackupResult.success({
    required String path,
    required String timestamp,
    required int timetableSize,
    required int attendanceSize,
  }) =>
      BackupResult._(
        isSuccess: true,
        path: path,
        timestamp: timestamp,
        timetableSize: timetableSize,
        attendanceSize: attendanceSize,
      );

  factory BackupResult.failure(String error) =>
      BackupResult._(isSuccess: false, error: error);

  int get totalSize => timetableSize + attendanceSize;
}

class RestoreResult {
  final bool isSuccess;
  final bool isCancelled;
  final bool timetableRestored;
  final bool attendanceRestored;
  final String? error;

  const RestoreResult._({
    required this.isSuccess,
    this.isCancelled = false,
    this.timetableRestored = false,
    this.attendanceRestored = false,
    this.error,
  });

  factory RestoreResult.success({
    required bool timetableRestored,
    required bool attendanceRestored,
  }) =>
      RestoreResult._(
        isSuccess: true,
        timetableRestored: timetableRestored,
        attendanceRestored: attendanceRestored,
      );

  factory RestoreResult.failure(String error) =>
      RestoreResult._(isSuccess: false, error: error);

  factory RestoreResult.cancelled() =>
      const RestoreResult._(isSuccess: false, isCancelled: true);
}

class BackupEntry {
  final String path;
  final String timestamp;
  final int timetableSize;
  final int attendanceSize;

  const BackupEntry({
    required this.path,
    required this.timestamp,
    required this.timetableSize,
    required this.attendanceSize,
  });

  int get totalSize => timetableSize + attendanceSize;
  String get formattedSize => BackupService.formatFileSize(totalSize);
  String get name => p.basename(path);
}
