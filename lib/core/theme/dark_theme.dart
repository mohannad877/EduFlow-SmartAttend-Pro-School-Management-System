import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

/// الثيمات المستخدمة في التطبيق (فاتح وداكن)
/// يدعم نظام الجداول ونظام الحضور معاً بنفس الهوية البصرية
class AppThemes {
  AppThemes._();

  // ========== الثيم الفاتح ==========
  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        fontFamily: 'Cairo',
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          primaryContainer: AppColors.primaryLight,
          secondary: AppColors.secondary,
          secondaryContainer: AppColors.secondaryLight,
          surface: AppColors.surface,
          error: AppColors.error,
          onPrimary: AppColors.textOnPrimary,
          onSecondary: AppColors.textOnPrimary,
          onSurface: AppColors.textPrimary,
          onError: AppColors.textOnPrimary,
        ),
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          titleTextStyle: AppTextStyles.headline6.copyWith(color: Colors.white, fontFamily: 'Cairo'),
          iconTheme: const IconThemeData(color: Colors.white, size: 24),
        ),
        cardTheme: CardTheme(
          elevation: 0,
          color: AppColors.card,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textOnPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: AppTextStyles.button,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            side: const BorderSide(color: AppColors.primary, width: 1.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: AppTextStyles.button.copyWith(color: AppColors.primary),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            textStyle: AppTextStyles.button.copyWith(color: AppColors.primary),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.background,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.error, width: 1)),
          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.error, width: 2)),
          labelStyle: AppTextStyles.body2.copyWith(),
          hintStyle: AppTextStyles.body2.copyWith(color: AppColors.textHint),
          prefixIconColor: AppColors.primary,
          suffixIconColor: AppColors.textSecondary,
        ),
        dividerTheme: const DividerThemeData(color: AppColors.divider, thickness: 1, space: 1),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          elevation: 4,
          shape: CircleBorder(),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return AppColors.primary;
            return Colors.transparent;
          }),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        chipTheme: ChipThemeData(
          selectedColor: AppColors.primaryLight.withOpacity(0.2),
          labelStyle: AppTextStyles.caption,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        dialogTheme: DialogTheme(
          backgroundColor: AppColors.surface,
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          titleTextStyle: AppTextStyles.headline6.copyWith(fontFamily: 'Cairo'),
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: AppColors.surface,
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.textPrimary,
          contentTextStyle: AppTextStyles.body2.copyWith(color: AppColors.textOnPrimary),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          behavior: SnackBarBehavior.floating,
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: AppColors.primary,
          linearTrackColor: AppColors.primaryLight,
        ),
      );

  // ========== الثيم الداكن ==========
  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        fontFamily: 'Cairo',
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primaryLight,
          primaryContainer: AppColors.primaryDark,
          secondary: AppColors.secondaryLight,
          secondaryContainer: AppColors.secondaryDark,
          surface: AppColors.darkSurface,
          // سطح الحاوية
          surfaceContainerLowest: Color(0xFF1A1A1A),
          surfaceContainerLow: Color(0xFF1E1E1E),
          surfaceContainer: Color(0xFF242424),
          surfaceContainerHigh: AppColors.darkCard,
          surfaceContainerHighest: Color(0xFF303030),
          error: Color(0xFFCF6679),
          errorContainer: Color(0xFF5C1A22),
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: AppColors.darkTextPrimary,
          onError: Colors.white,
          onErrorContainer: Color(0xFFFFB3BC),
        ),
        scaffoldBackgroundColor: AppColors.darkBackground,
        appBarTheme: AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: AppColors.darkSurface,
          foregroundColor: AppColors.darkTextPrimary,
          surfaceTintColor: Colors.transparent,
          iconTheme: const IconThemeData(color: AppColors.darkTextPrimary, size: 24),
          titleTextStyle: AppTextStyles.headline6.copyWith(
              color: AppColors.darkTextPrimary, fontFamily: 'Cairo'),
        ),
        cardTheme: CardTheme(
          elevation: 0,
          color: AppColors.darkCard,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: AppColors.primaryLight,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: AppTextStyles.button,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primaryLight,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            side: const BorderSide(color: AppColors.primaryLight, width: 1.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: AppTextStyles.button.copyWith(color: AppColors.primaryLight),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primaryLight,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            textStyle: AppTextStyles.button.copyWith(color: AppColors.primaryLight),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.darkCard,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF3A3A3A))),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF3A3A3A))),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primaryLight, width: 2)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFCF6679), width: 1)),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFCF6679), width: 2)),
          labelStyle: AppTextStyles.body2.copyWith(color: AppColors.darkTextSecondary),
          hintStyle: AppTextStyles.body2.copyWith(color: AppColors.darkTextSecondary),
          prefixIconColor: AppColors.primaryLight,
          suffixIconColor: AppColors.darkTextSecondary,
        ),
        dividerTheme: const DividerThemeData(
            color: Color(0xFF2E2E2E), thickness: 1, space: 1),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.primaryLight,
          foregroundColor: Colors.white,
          elevation: 4,
          shape: CircleBorder(),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return AppColors.primaryLight;
            return Colors.transparent;
          }),
          checkColor: WidgetStateProperty.all(Colors.white),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          side: const BorderSide(color: AppColors.darkTextSecondary, width: 1.5),
        ),
        chipTheme: ChipThemeData(
          selectedColor: AppColors.primaryLight.withOpacity(0.25),
          backgroundColor: AppColors.darkCard,
          labelStyle: AppTextStyles.caption.copyWith(color: AppColors.darkTextPrimary),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          side: const BorderSide(color: Color(0xFF3A3A3A)),
        ),
        dialogTheme: DialogTheme(
          backgroundColor: AppColors.darkSurface,
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          titleTextStyle: AppTextStyles.headline6.copyWith(
              color: AppColors.darkTextPrimary, fontFamily: 'Cairo'),
          contentTextStyle: AppTextStyles.body1.copyWith(
              color: AppColors.darkTextSecondary, fontFamily: 'Cairo'),
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: AppColors.darkSurface,
          elevation: 8,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.darkCard,
          contentTextStyle: AppTextStyles.body2.copyWith(color: AppColors.darkTextPrimary),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          behavior: SnackBarBehavior.floating,
          actionTextColor: AppColors.primaryLight,
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: AppColors.primaryLight,
          linearTrackColor: AppColors.primaryDark,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: AppColors.darkSurface,
          indicatorColor: AppColors.primaryLight.withOpacity(0.2),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: AppColors.primaryLight, size: 24);
            }
            return const IconThemeData(color: AppColors.darkTextSecondary, size: 24);
          }),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppTextStyles.caption.copyWith(
                  color: AppColors.primaryLight, fontWeight: FontWeight.bold);
            }
            return AppTextStyles.caption.copyWith(color: AppColors.darkTextSecondary);
          }),
        ),
        listTileTheme: const ListTileThemeData(
          iconColor: AppColors.darkTextSecondary,
          textColor: AppColors.darkTextPrimary,
        ),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return AppColors.primaryLight;
            return AppColors.darkTextSecondary;
          }),
          trackColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.primaryLight.withOpacity(0.4);
            }
            return const Color(0xFF3A3A3A);
          }),
        ),
      );


  // ========== السمة المحيطية (Ocean Blue) ==========
  static ThemeData get oceanTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        fontFamily: 'Cairo',
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF0097A7), // Cyan 700
          primaryContainer: Color(0xFFB2EBF2),
          secondary: Color(0xFF00796B), // Teal 700
          secondaryContainer: Color(0xFFB2DFDB),
          surface: Color(0xFFF5FDFF),
          error: AppColors.error,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: AppColors.textPrimary,
        ),
        scaffoldBackgroundColor: const Color(0xFFE0F7FA),
        appBarTheme: AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: const Color(0xFF0097A7),
          foregroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.white, size: 24),
          titleTextStyle: AppTextStyles.headline6.copyWith(color: Colors.white, fontFamily: 'Cairo'),
        ),
        cardTheme: CardTheme(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF0097A7),
          foregroundColor: Colors.white,
        ),
      );

  // ========== السمة الأرجوانية (Royal Purple) ==========
  static ThemeData get purpleTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        fontFamily: 'Cairo',
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF6A1B9A), // Purple 800
          primaryContainer: Color(0xFFE1BEE7),
          secondary: Color(0xFF880E4F), // Pink 900
          secondaryContainer: Color(0xFFF8BBD0),
          surface: Color(0xFFFAFAFA),
          error: AppColors.error,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: AppColors.textPrimary,
        ),
        scaffoldBackgroundColor: const Color(0xFFF3E5F5),
        appBarTheme: AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: const Color(0xFF6A1B9A),
          foregroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.white, size: 24),
          titleTextStyle: AppTextStyles.headline6.copyWith(color: Colors.white, fontFamily: 'Cairo'),
        ),
        cardTheme: CardTheme(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF6A1B9A),
          foregroundColor: Colors.white,
        ),
      );
}
