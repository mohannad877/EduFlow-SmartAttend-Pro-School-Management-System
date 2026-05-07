import 'package:school_schedule_app/core/navigation/app_router.dart';
import 'package:school_schedule_app/core/utils/l10n_extension.dart';
import 'package:school_schedule_app/core/utils/l10n_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppNotification {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final bool isRead;
  final String type;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    this.isRead = false,
    required this.type,
  });

  AppNotification copyWith({bool? isRead}) {
    return AppNotification(
      id: id,
      title: title,
      message: message,
      timestamp: timestamp,
      isRead: isRead ?? this.isRead,
      type: type,
    );
  }
}

class NotificationsNotifier extends StateNotifier<List<AppNotification>> {
  NotificationsNotifier() : super([]);

  void addNotification(String title, String message, String type) {
    final notification = AppNotification(
      id: const Uuid().v4(),
      title: title,
      message: message,
      timestamp: DateTime.now(),
      type: type,
    );
    state = [notification, ...state];
  }

  void markAsRead(String id) {
    state = [
      for (final n in state)
        if (n.id == id) n.copyWith(isRead: true) else n
    ];
  }

  void markAllAsRead() {
    state = [for (final n in state) n.copyWith(isRead: true)];
  }

  void clearNotifications() {
    state = [];
  }
}

final notificationsProvider = StateNotifierProvider<NotificationsNotifier, List<AppNotification>>((ref) {
  return NotificationsNotifier()
    // إشعارات وهمية للاختبار وبداية العرض
    ..addNotification(AppNavigator.navigatorKey.currentContext!.l10n.backupSuccess, AppNavigator.navigatorKey.currentContext!.l10n.backupComplete, 'backup')
    ..addNotification(AppNavigator.navigatorKey.currentContext!.l10n.attendanceAlert, AppNavigator.navigatorKey.currentContext!.l10n.sessionClosed, 'attendance');
});

// Notifications Settings Provider
class NotificationSettings {
  final bool enableAll;
  final bool attendanceAlerts;
  final bool systemAlerts;
  final bool backupAlerts;

  const NotificationSettings({
    this.enableAll = true,
    this.attendanceAlerts = true,
    this.systemAlerts = true,
    this.backupAlerts = true,
  });

  NotificationSettings copyWith({
    bool? enableAll,
    bool? attendanceAlerts,
    bool? systemAlerts,
    bool? backupAlerts,
  }) {
    return NotificationSettings(
      enableAll: enableAll ?? this.enableAll,
      attendanceAlerts: attendanceAlerts ?? this.attendanceAlerts,
      systemAlerts: systemAlerts ?? this.systemAlerts,
      backupAlerts: backupAlerts ?? this.backupAlerts,
    );
  }
}

class NotificationSettingsNotifier extends StateNotifier<NotificationSettings> {
  NotificationSettingsNotifier() : super(const NotificationSettings()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    state = NotificationSettings(
      enableAll: prefs.getBool('notif_enableAll') ?? true,
      attendanceAlerts: prefs.getBool('notif_attendance') ?? true,
      systemAlerts: prefs.getBool('notif_system') ?? true,
      backupAlerts: prefs.getBool('notif_backup') ?? true,
    );
  }

  Future<void> _saveSettings(NotificationSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notif_enableAll', settings.enableAll);
    await prefs.setBool('notif_attendance', settings.attendanceAlerts);
    await prefs.setBool('notif_system', settings.systemAlerts);
    await prefs.setBool('notif_backup', settings.backupAlerts);
  }

  void toggleAll(bool value) {
    final newState = NotificationSettings(
      enableAll: value,
      attendanceAlerts: value,
      systemAlerts: value,
      backupAlerts: value,
    );
    state = newState;
    _saveSettings(newState);
  }

  void toggleAttendance(bool value) {
    final newState = state.copyWith(attendanceAlerts: value);
    state = newState;
    _saveSettings(newState);
  }

  void toggleSystem(bool value) {
    final newState = state.copyWith(systemAlerts: value);
    state = newState;
    _saveSettings(newState);
  }

  void toggleBackup(bool value) {
    final newState = state.copyWith(backupAlerts: value);
    state = newState;
    _saveSettings(newState);
  }
}

final notificationSettingsProvider = StateNotifierProvider<NotificationSettingsNotifier, NotificationSettings>(
  (ref) => NotificationSettingsNotifier(),
);
