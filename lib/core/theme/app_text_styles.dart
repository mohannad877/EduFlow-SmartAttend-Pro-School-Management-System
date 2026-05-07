import 'package:flutter/material.dart';
import 'app_colors.dart';

/// أنماط النصوص الموحدة للتطبيق
class AppTextStyles {
  AppTextStyles._();

  static const String _fontFamily = 'Cairo';

  // ========== عناوين ==========
  static const TextStyle headline1 = TextStyle(fontFamily: _fontFamily, fontSize: 32, fontWeight: FontWeight.bold, height: 1.4);
  static const TextStyle headline2 = TextStyle(fontFamily: _fontFamily, fontSize: 28, fontWeight: FontWeight.bold, height: 1.4);
  static const TextStyle headline3 = TextStyle(fontFamily: _fontFamily, fontSize: 24, fontWeight: FontWeight.bold, height: 1.4);
  static const TextStyle headline4 = TextStyle(fontFamily: _fontFamily, fontSize: 20, fontWeight: FontWeight.w600, height: 1.4);
  static const TextStyle headline5 = TextStyle(fontFamily: _fontFamily, fontSize: 18, fontWeight: FontWeight.w600, height: 1.4);
  static const TextStyle headline6 = TextStyle(fontFamily: _fontFamily, fontSize: 16, fontWeight: FontWeight.w600, height: 1.4);

  // ========== نصوص عادية ==========
  static const TextStyle body1 = TextStyle(fontFamily: _fontFamily, fontSize: 16, fontWeight: FontWeight.normal, height: 1.6);
  static const TextStyle body2 = TextStyle(fontFamily: _fontFamily, fontSize: 14, fontWeight: FontWeight.normal, height: 1.6);

  // ========== نصوص فرعية ==========
  static const TextStyle subtitle1 = TextStyle(fontFamily: _fontFamily, fontSize: 16, fontWeight: FontWeight.w500, height: 1.5);
  static const TextStyle subtitle2 = TextStyle(fontFamily: _fontFamily, fontSize: 14, fontWeight: FontWeight.w500, height: 1.5);
  static const TextStyle titleMedium = TextStyle(fontFamily: _fontFamily, fontSize: 16, fontWeight: FontWeight.w600, height: 1.4);

  // ========== أزرار ==========
  static const TextStyle button = TextStyle(fontFamily: _fontFamily, fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textOnPrimary, height: 1.4, letterSpacing: 0.5);

  // ========== ملاحظات ==========
  static const TextStyle caption = TextStyle(fontFamily: _fontFamily, fontSize: 12, fontWeight: FontWeight.normal, height: 1.4);
  static const TextStyle overline = TextStyle(fontFamily: _fontFamily, fontSize: 10, fontWeight: FontWeight.w500, height: 1.4, letterSpacing: 1.5);

  // ========== خاصة بالحضور ==========
  static const TextStyle attendanceCount = TextStyle(fontFamily: _fontFamily, fontSize: 36, fontWeight: FontWeight.bold, height: 1.2);
  static const TextStyle studentName = TextStyle(fontFamily: _fontFamily, fontSize: 16, fontWeight: FontWeight.w600, height: 1.4);
  static const TextStyle studentInfo = TextStyle(fontFamily: _fontFamily, fontSize: 13, fontWeight: FontWeight.normal, height: 1.4);
  static const TextStyle cardTitle = TextStyle(fontFamily: _fontFamily, fontSize: 18, fontWeight: FontWeight.bold, height: 1.4);
  static const TextStyle cardSubtitle = TextStyle(fontFamily: _fontFamily, fontSize: 14, fontWeight: FontWeight.normal, height: 1.4);
  static const TextStyle barcodeId = TextStyle(fontFamily: _fontFamily, fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 2);
}
