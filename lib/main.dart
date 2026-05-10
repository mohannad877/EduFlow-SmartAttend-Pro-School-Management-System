import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'core/di/injection.dart';
import 'core/theme/dark_theme.dart';
import 'core/navigation/app_router.dart';
import 'core/providers/theme_provider.dart';
import 'core/providers/language_provider.dart';
import 'core/utils/l10n_extension.dart';


import 'presentation/bloc/schedule/schedule_bloc.dart';
import 'presentation/bloc/schedule/schedule_event.dart';
import 'core/services/backup_service.dart';
import 'core/services/notification_service.dart';
import 'core/services/background_worker_service.dart';

// =============================================================================
// ENTRY POINT
// نقطة دخول الـ App الموحد:
//   • ProviderScope    → للـ Riverpod (نظام الحضور واللغة)
//   • AppLocalizations → ترجمة النصوص (نظام l10n الرسمي)
//   • configureDependencies → GetIt / injectable (نظام الجداول)
//   • MaterialApp مع AppRouteGenerator → توجيه موحد
// =============================================================================

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── الاتجاه العمودي فقط
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // ── تسجيل الـ dependencies (GetIt — نظام الجداول الأصلي)
  await configureDependencies();

  // ── تهيئة خدمات الإشعارات والعمل في الخلفية
  await NotificationService().init();
  await BackgroundWorkerService.init();
  
  // ── جدولة النسخ الاحتياطي اليومي في الخلفية
  await BackgroundWorkerService.scheduleDailyBackup();

  // ── التحقق من تشغيل النسخ الاحتياطي التلقائي (العمل الفوري عند الفتح)
  BackupService.checkAndRunAutoBackup();

  runApp(
    // ── ProviderScope يُغلّف كل شيء لدعم Riverpod (نظام الحضور واللغات المتغيرة)
    const ProviderScope(
      child: _BlocApp(),
    ),
  );
}

// ─────────────────────────────────────────────────────────
// المحيط الداخلي (BLoC + MaterialApp)
// ─────────────────────────────────────────────────────────
class _BlocApp extends StatelessWidget {
  const _BlocApp();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      // ── BLoCs الأصلية لنظام الجداول — لا تمس هذه
      providers: [
        BlocProvider<ScheduleBloc>(
          create: (_) => GetIt.I<ScheduleBloc>()..add(const LoadSchedule()),
        ),
      ],
      child: const _UnifiedApp(),
    );
  }
}

// ─────────────────────────────────────────────────────────
// MaterialApp الموحد
// ─────────────────────────────────────────────────────────
class _UnifiedApp extends ConsumerWidget {
  const _UnifiedApp();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final locale = ref.watch(languageProvider); // الحصول على اللغة ديناميكياً

    ThemeData activeThemeData;
    switch (themeState.activeTheme) {
      case AppThemeType.light:
        activeThemeData = AppThemes.lightTheme;
        break;
      case AppThemeType.dark:
        activeThemeData = AppThemes.darkTheme;
        break;
      case AppThemeType.ocean:
        activeThemeData = AppThemes.oceanTheme;
        break;
      case AppThemeType.purple:
        activeThemeData = AppThemes.purpleTheme;
        break;
    }

    return MaterialApp(
      // ── معلومات التطبيق
      onGenerateTitle: (context) => context.l10n.appName,
      debugShowCheckedModeBanner: false,

      // ── الثيم الديناميكي الموحد
      theme: activeThemeData,
      darkTheme: AppThemes.darkTheme,
      themeMode: themeState.themeMode,

      // ── اللغة والترجمة الرسمية l10n
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // ── التوجيه الموحد: الـ navigator key + route generator
      navigatorKey: AppNavigator.navigatorKey,
      onGenerateRoute: AppRouteGenerator.generateRoute,

      // ── الصفحة الأولى هي Splash التي تقرر أين تذهب
      initialRoute: AppRoutes.splash,
    );
  }
}
