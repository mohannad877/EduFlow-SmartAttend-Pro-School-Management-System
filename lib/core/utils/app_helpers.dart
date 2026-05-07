import 'package:school_schedule_app/core/navigation/app_router.dart';
import 'package:school_schedule_app/core/utils/l10n_extension.dart';
import 'package:intl/intl.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

// ============================================================================
// ثوابت التطبيق
// ============================================================================

class AppConstants {
  AppConstants._();

  static const String displayDateFormat = 'dd/MM/yyyy';
  static const String arabicDateFormat = 'd MMMM yyyy';
  static const String timeFormat = 'hh:mm a';
  static const String dateTimeFormat = 'dd/MM/yyyy hh:mm a';
}

// ============================================================================
// أدوات التاريخ والوقت
// ============================================================================

class DateTimeUtils {
  DateTimeUtils._();

  static DateTime get today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  static String formatDate(DateTime date, {String? pattern}) {
    return DateFormat(pattern ?? AppConstants.displayDateFormat, 'ar').format(date);
  }

  static String formatArabicDate(DateTime date) {
    return DateFormat(AppConstants.arabicDateFormat, 'ar').format(date);
  }

  static String formatTime(DateTime time) {
    return DateFormat(AppConstants.timeFormat, 'ar').format(time);
  }

  static String formatDateTime(DateTime dateTime) {
    return DateFormat(AppConstants.dateTimeFormat, 'ar').format(dateTime);
  }

  static String getDayName(DateTime date) => DateFormat('EEEE', 'ar').format(date);
  static String getMonthName(DateTime date) => DateFormat('MMMM', 'ar').format(date);

  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  static DateTime getStartOfMonth(DateTime date) => DateTime(date.year, date.month, 1);
  static DateTime getEndOfMonth(DateTime date) => DateTime(date.year, date.month + 1, 0);

  static List<DateTime> getDaysInMonth(DateTime date) {
    final start = getStartOfMonth(date);
    final end = getEndOfMonth(date);
    return List.generate(end.day, (i) => DateTime(start.year, start.month, i + 1));
  }
}

// ============================================================================
// أدوات التشفير
// ============================================================================

class CryptoUtils {
  CryptoUtils._();

  static String hashPassword(String password) {
    final bytes = utf8.encode('${password}school_att_salt_2024');
    return sha256.convert(bytes).toString();
  }

  static bool verifyPassword(String password, String hash) => hashPassword(password) == hash;

  static String generateId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final hash = sha256.convert(utf8.encode(timestamp + DateTime.now().toString()));
    return hash.toString().substring(0, 12).toUpperCase();
  }
}

// ============================================================================
// أدوات الباركود / QR
// ============================================================================

class BarcodeUtils {
  BarcodeUtils._();

  static String generateQRData({
    required int id,
    required String name,
    required String grade,
    required String section,
  }) {
    return jsonEncode({
      'app': 'SCHOOL_ATT',
      'id': id,
      'name': name,
      'grade': grade,
      'section': section,
      'ts': DateTime.now().millisecondsSinceEpoch,
    });
  }

  static Map<String, dynamic>? parseQRData(String data) {
    try {
      return jsonDecode(data) as Map<String, dynamic>?;
    } catch (_) {
      return null;
    }
  }

  static String generateBarcode() {
    final now = DateTime.now();
    final base = '${now.year}${now.month.toString().padLeft(2, '0')}';
    final random = CryptoUtils.generateId().substring(0, 6);
    return '$base$random';
  }

  /// Original format parser: SCHOOL_ATT|id|...
  static int? parseStudentIdFromBarcode(String raw) {
    final parts = raw.split('|');
    if (parts.length >= 2 && parts[0] == 'SCHOOL_ATT') {
      return int.tryParse(parts[1]);
    }
    // Try JSON format
    final parsed = parseQRData(raw);
    if (parsed != null && parsed['id'] != null) {
      return parsed['id'] as int?;
    }
    return null;
  }
}

// ============================================================================
// أدوات التحقق من الإدخال
// ============================================================================

class ValidationUtils {
  ValidationUtils._();

  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) return AppNavigator.navigatorKey.currentContext!.l10n.close;
    if (value.length < 3) return AppNavigator.navigatorKey.currentContext!.l10n.confirm;
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) return AppNavigator.navigatorKey.currentContext!.l10n.areYouSure;
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return AppNavigator.navigatorKey.currentContext!.l10n.confirmDelete;
    if (value.length < 6) return AppNavigator.navigatorKey.currentContext!.l10n.deleteSuccess;
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) return AppNavigator.navigatorKey.currentContext!.l10n.required;
    if (value.length < 2) return AppNavigator.navigatorKey.currentContext!.l10n.invalidInput;
    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) return AppNavigator.navigatorKey.currentContext!.l10n.savedSuccessfully;
    return null;
  }
}

// ============================================================================
// أدوات النصوص
// ============================================================================

class TextUtils {
  TextUtils._();
  static String cleanText(String text) => text.trim().replaceAll(RegExp(r'\s+'), ' ');
  static bool isEmpty(String? text) => text == null || text.trim().isEmpty;
  static String truncate(String text, int maxLength) =>
      text.length <= maxLength ? text : '${text.substring(0, maxLength)}...';
  static String getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts[0][0];
    return '${parts[0][0]}${parts.last[0]}';
  }
}

// ============================================================================
// امتدادات String و DateTime و List
// ============================================================================

extension StringExtensions on String {
  bool get isBlank => trim().isEmpty;
  bool get isNotBlank => !isBlank;
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}

extension DateTimeExtensions on DateTime {
  bool get isToday => DateTimeUtils.isToday(this);
  String get formatted => DateTimeUtils.formatDate(this);
  String get arabicFormatted => DateTimeUtils.formatArabicDate(this);
}

extension ListExtensions<T> on List<T> {
  T? getOrNull(int index) {
    if (index < 0 || index >= length) return null;
    return this[index];
  }
}
