import 'package:school_schedule_app/core/navigation/app_router.dart';
import 'package:school_schedule_app/core/utils/l10n_extension.dart';

// ============================================================================
// ArabicFormatter — Arabic locale formatting utilities
// ============================================================================

class ArabicFormatter {
  static List<String> get _months => [
    AppNavigator.navigatorKey.currentContext!.l10n.january,
    AppNavigator.navigatorKey.currentContext!.l10n.february,
    AppNavigator.navigatorKey.currentContext!.l10n.march,
    AppNavigator.navigatorKey.currentContext!.l10n.april,
    AppNavigator.navigatorKey.currentContext!.l10n.may,
    AppNavigator.navigatorKey.currentContext!.l10n.june,
    AppNavigator.navigatorKey.currentContext!.l10n.july,
    AppNavigator.navigatorKey.currentContext!.l10n.august,
    AppNavigator.navigatorKey.currentContext!.l10n.september,
    AppNavigator.navigatorKey.currentContext!.l10n.october,
    AppNavigator.navigatorKey.currentContext!.l10n.november,
    AppNavigator.navigatorKey.currentContext!.l10n.december,
  ];

  static List<String> get _weekdays => [
    '',
    AppNavigator.navigatorKey.currentContext!.l10n.monday,
    AppNavigator.navigatorKey.currentContext!.l10n.tuesday,
    AppNavigator.navigatorKey.currentContext!.l10n.wednesday,
    AppNavigator.navigatorKey.currentContext!.l10n.thursday,
    AppNavigator.navigatorKey.currentContext!.l10n.friday,
    AppNavigator.navigatorKey.currentContext!.l10n.saturday,
    AppNavigator.navigatorKey.currentContext!.l10n.sunday,
  ];

  /// Formats a date as "الإثنين، 21 أبريل 2026"
  static String formatFullDate(DateTime date) =>
      '${_weekdays[date.weekday]}، ${formatDate(date)}';

  /// Formats a date as "21 أبريل 2026"
  static String formatDate(DateTime date) =>
      '${date.day} ${_months[date.month - 1]} ${date.year}';

  /// Formats a date as "أبريل 2026"
  static String formatMonthYear(DateTime date) =>
      '${_months[date.month - 1]} ${date.year}';

  /// Short format: "21/04/2026"
  static String formatShort(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

  /// Formats time as "14:30"
  static String formatTime(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

  /// Formats date + time as "21 أبريل 2026، الساعة 14:30"
  static String formatDateTime(DateTime dt) =>
      '${formatDate(dt)}، الساعة ${formatTime(dt)}';

  /// Converts an attendance status key to its Arabic label.
  static String attendanceStatusLabel(String status) => switch (status) {
        'present' => AppNavigator.navigatorKey.currentContext!.l10n.present,
        'absent' => AppNavigator.navigatorKey.currentContext!.l10n.absent,
        'late' => AppNavigator.navigatorKey.currentContext!.l10n.late,
        'excused' => AppNavigator.navigatorKey.currentContext!.l10n.excused,
        _ => status,
      };

  /// Converts a percentage (0.0–1.0) to a display string like "87.5%".
  static String formatRate(double rate) => '${(rate * 100).toStringAsFixed(1)}%';

  /// Returns a human-readable relative label for a date.
  static String relativeDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(date.year, date.month, date.day);
    final diff = today.difference(d).inDays;
    if (diff == 0) return AppNavigator.navigatorKey.currentContext!.l10n.now;
    if (diff == 1) return AppNavigator.navigatorKey.currentContext!.l10n.yesterday;
    if (diff <= 7) return AppNavigator.navigatorKey.currentContext!.l10n.daysAgoLog(diff);
    return formatDate(date);
  }

  /// Converts English numbers to Arabic-Indic numbers (0 -> ٠)
  static String toArabicNumber(dynamic input) {
    if (input == null) return '';
    final s = input.toString();
    const englishDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    var result = s;
    for (var i = 0; i < englishDigits.length; i++) {
      result = result.replaceAll(englishDigits[i], arabicDigits[i]);
    }
    return result;
  }
}
