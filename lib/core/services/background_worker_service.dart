import 'package:workmanager/workmanager.dart';
import 'package:flutter/foundation.dart';
import 'backup_service.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      if (task == BackgroundWorkerService.backupTaskName) {
        debugPrint('Background Worker: Running Auto Backup Task');
        await BackupService.checkAndRunAutoBackup();
      }
      return Future.value(true);
    } catch (e) {
      debugPrint('Background Worker Error: $e');
      return Future.value(false);
    }
  });
}

class BackgroundWorkerService {
  static const String backupTaskName = "com.school_schedule.auto_backup";

  static Future<void> init() async {
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: kDebugMode, // shows notification on running in debug
    );
  }

  static Future<void> scheduleDailyBackup() async {
    await Workmanager().registerPeriodicTask(
      "auto_backup_task_1", // unique id
      backupTaskName,
      frequency: const Duration(days: 1), // Runs daily
      initialDelay: const Duration(minutes: 15), // Small delay initially
      constraints: Constraints(
        networkType: NetworkType.notRequired,
        requiresBatteryNotLow: true,
        requiresStorageNotLow: true, // Prevents backup if device is full
        requiresDeviceIdle: false,
      ),
      backoffPolicy: BackoffPolicy.exponential,
      backoffPolicyDelay: const Duration(minutes: 30), // Retry after 30 mins if fails
      existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
    );
  }
}
