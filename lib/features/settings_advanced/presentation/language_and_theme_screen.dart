import 'package:school_schedule_app/core/utils/l10n_extension.dart';
import 'package:school_schedule_app/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:school_schedule_app/core/widgets/premium_app_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_schedule_app/core/theme/app_colors.dart';
import 'package:school_schedule_app/core/theme/app_text_styles.dart';
import 'package:school_schedule_app/core/providers/theme_provider.dart';
import 'package:school_schedule_app/core/providers/language_provider.dart';

class LanguageAndThemeScreen extends ConsumerWidget {
  const LanguageAndThemeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);

    return Scaffold(
      appBar: PremiumAppBar(
        title: Text(context.l10n.language, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.language, style: AppTextStyles.titleMedium.copyWith(color: AppColors.primary), maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 12),
            _buildLanguageCard(context, ref),
            const SizedBox(height: 32),
            Text(context.l10n.theme, style: AppTextStyles.titleMedium.copyWith(color: AppColors.primary), maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 12),
            _buildThemeSelector(context, themeState, themeNotifier),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageCard(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(languageProvider).languageCode;
    final langNotifier = ref.read(languageProvider.notifier);
    
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          RadioListTile<String>(
            title: Text(context.l10n.arabic, style: TextStyle(fontFamily: 'Cairo'), maxLines: 1, overflow: TextOverflow.ellipsis),
            value: 'ar',
            groupValue: currentLocale,
            activeColor: AppColors.primary,
            onChanged: (val) {
              if (val != null) langNotifier.changeLanguage(val);
            },
          ),
          const Divider(height: 1),
          RadioListTile<String>(
            title: const Text('English', style: TextStyle(fontFamily: 'Cairo'), maxLines: 1, overflow: TextOverflow.ellipsis),
            value: 'en',
            groupValue: currentLocale,
            activeColor: AppColors.primary,
            onChanged: (val) {
              if (val != null) langNotifier.changeLanguage(val);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildThemeSelector(BuildContext context, ThemeState themeState, ThemeNotifier themeNotifier) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: AppThemeType.values.map((theme) {
        final isSelected = themeState.activeTheme == theme;
        return GestureDetector(
          onTap: () => themeNotifier.setActiveTheme(theme),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: _getThemeColor(theme).withOpacity(0.1),
              border: Border.all(
                color: isSelected ? _getThemeColor(theme) : Colors.transparent,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _getThemeIcon(theme),
                  color: _getThemeColor(theme),
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  theme.label,
                  style: AppTextStyles.subtitle1.copyWith(
                    color: _getThemeColor(theme),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
                maxLines: 1, overflow: TextOverflow.ellipsis),
                if (isSelected)
                  const Padding(
                    padding: EdgeInsetsDirectional.only(),
                    child: Icon(Icons.check_circle, color: AppColors.success, size: 20),
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Color _getThemeColor(AppThemeType type) {
    switch (type) {
      case AppThemeType.light: return AppColors.primary;
      case AppThemeType.dark: return Colors.blueGrey.shade800;
      case AppThemeType.ocean: return const Color(0xFF0097A7);
      case AppThemeType.purple: return const Color(0xFF6A1B9A);
    }
  }

  IconData _getThemeIcon(AppThemeType type) {
    switch (type) {
      case AppThemeType.light: return Icons.wb_sunny_rounded;
      case AppThemeType.dark: return Icons.nightlight_round;
      case AppThemeType.ocean: return Icons.water_drop_rounded;
      case AppThemeType.purple: return Icons.auto_awesome;
    }
  }
}
