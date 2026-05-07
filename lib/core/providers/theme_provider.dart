import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:school_schedule_app/core/navigation/app_router.dart';
import 'package:school_schedule_app/core/utils/l10n_extension.dart';

enum AppThemeType {
  light,
  dark,
  ocean,
  purple;

  String get label {
    switch (this) {
      case AppThemeType.light:
        return AppNavigator.navigatorKey.currentContext!.l10n.themeLight;
      case AppThemeType.dark:
        return AppNavigator.navigatorKey.currentContext!.l10n.themeDark;
      case AppThemeType.ocean:
        return AppNavigator.navigatorKey.currentContext!.l10n.themeOcean;
      case AppThemeType.purple:
        return AppNavigator.navigatorKey.currentContext!.l10n.themePurple;
    }
  }
}

class ThemeState {
  final ThemeMode themeMode;
  final AppThemeType activeTheme;
  
  const ThemeState({
    required this.themeMode,
    required this.activeTheme,
  });

  ThemeState copyWith({ThemeMode? themeMode, AppThemeType? activeTheme}) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      activeTheme: activeTheme ?? this.activeTheme,
    );
  }
}

class ThemeNotifier extends StateNotifier<ThemeState> {
  ThemeNotifier() : super(const ThemeState(themeMode: ThemeMode.light, activeTheme: AppThemeType.light)) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeStr = prefs.getString('app_theme') ?? 'light';
    final theme = AppThemeType.values.firstWhere((e) => e.name == themeStr, orElse: () => AppThemeType.light);
    
    final modeStr = prefs.getString('theme_mode') ?? 'light';
    final setMode = modeStr == 'dark' ? ThemeMode.dark : ThemeMode.light;

    state = ThemeState(themeMode: setMode, activeTheme: theme);
  }

  Future<void> _saveTheme(AppThemeType theme, ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_theme', theme.name);
    await prefs.setString('theme_mode', mode == ThemeMode.dark ? 'dark' : 'light');
  }

  void setThemeMode(ThemeMode mode) {
    state = state.copyWith(themeMode: mode);
    _saveTheme(state.activeTheme, mode);
  }

  void setActiveTheme(AppThemeType theme) {
    ThemeMode modeToSet = ThemeMode.light;
    if (theme == AppThemeType.dark) {
      modeToSet = ThemeMode.dark;
    }
    
    state = state.copyWith(activeTheme: theme, themeMode: modeToSet);
    _saveTheme(theme, modeToSet);
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((ref) => ThemeNotifier());
