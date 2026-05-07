import 'package:school_schedule_app/core/navigation/app_router.dart';
import 'package:school_schedule_app/core/utils/l10n_extension.dart';
import 'package:flutter/material.dart';

/// ألوان التطبيق الموحدة — تعتمد على نظام الجداول الدراسية كمرجع رئيسي
/// مع إضافة ألوان حالات الحضور
class AppColors {
  AppColors._();

  // ========== الألوان الأساسية (من نظام الجداول) ==========
  static const Color primary = Color(0xFF1565C0); // Blue 800
  static const Color primaryLight = Color(0xFF1E88E5); // Blue 600
  static const Color primaryDark = Color(0xFF0D47A1); // Blue 900

  static const Color secondary = Color(0xFF26A69A); // Teal 400
  static const Color secondaryLight = Color(0xFF80CBC4);
  static const Color secondaryDark = Color(0xFF00897B);

  // ========== ألوان الخلفية ==========
  static const Color background = Color(0xFFF5F7FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color card = Color(0xFFFFFFFF);
  static const Color divider = Color(0xFFE0E0E0);

  // ========== ألوان النص ==========
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ========== ألوان الحالة ==========
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // ========== ألوان حالات الحضور ==========
  static const Color present = Color(0xFF4CAF50);
  static const Color presentLight = Color(0xFFE8F5E9);
  static const Color presentDark = Color(0xFF388E3C);

  static const Color absent = Color(0xFFF44336);
  static const Color absentLight = Color(0xFFFFEBEE);
  static const Color absentDark = Color(0xFFD32F2F);

  static const Color late = Color(0xFFFF9800);
  static const Color lateLight = Color(0xFFFFF3E0);
  static const Color lateDark = Color(0xFFF57C00);

  static const Color excused = Color(0xFFFFC107);
  static const Color excusedLight = Color(0xFFFFF8E1);
  static const Color excusedDark = Color(0xFFFFA000);

  // ========== الوضع الداكن ==========
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkCard = Color(0xFF2C2C2C);
  static const Color darkTextPrimary = Color(0xFFE0E0E0);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);

  // ========== تدرجات لونية ==========
  static const LinearGradient premiumGradient = LinearGradient(
    colors: [Color(0xFF0D47A1), Color(0xFF1565C0), Color(0xFF1E88E5)],
    begin: AlignmentDirectional.topStart,
    end: AlignmentDirectional.bottomEnd,
  );

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryLight, primaryDark],
    begin: AlignmentDirectional.topStart,
    end: AlignmentDirectional.bottomEnd,
  );

  static const LinearGradient presentGradient = LinearGradient(
    colors: [present, presentDark],
    begin: AlignmentDirectional.topStart,
    end: AlignmentDirectional.bottomEnd,
  );

  static const LinearGradient absentGradient = LinearGradient(
    colors: [absent, absentDark],
    begin: AlignmentDirectional.topStart,
    end: AlignmentDirectional.bottomEnd,
  );

  static const LinearGradient cardGradient = premiumGradient;

  // ========== ظلال ==========
  static List<BoxShadow> get softShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 20,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ];

  // ========== دالة حالات الحضور ==========
  static Color getAttendanceColor(String status) {
    switch (status) {
      case 'present':
        return present;
      case 'absent':
        return absent;
      case 'late':
        return late;
      case 'excused':
        return excused;
      default:
        return textHint;
    }
  }

  static Color getAttendanceLightColor(String status) {
    switch (status) {
      case 'present':
        return presentLight;
      case 'absent':
        return absentLight;
      case 'late':
        return lateLight;
      case 'excused':
        return excusedLight;
      default:
        return background;
    }
  }

  static String getAttendanceLabel(String status) {
    switch (status) {
      case 'present':
        return AppNavigator.navigatorKey.currentContext!.l10n.present;
      case 'absent':
        return AppNavigator.navigatorKey.currentContext!.l10n.absent;
      case 'late':
        return AppNavigator.navigatorKey.currentContext!.l10n.late;
      case 'excused':
        return AppNavigator.navigatorKey.currentContext!.l10n.refresh;
      default:
        return AppNavigator.navigatorKey.currentContext!.l10n.about;
    }
  }
}
