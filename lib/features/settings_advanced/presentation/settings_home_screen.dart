import 'package:school_schedule_app/core/utils/l10n_extension.dart';
import 'package:school_schedule_app/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:school_schedule_app/core/widgets/premium_app_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:school_schedule_app/core/theme/app_colors.dart';
import 'package:school_schedule_app/core/theme/app_text_styles.dart';
import 'package:school_schedule_app/core/navigation/app_router.dart';
import 'package:school_schedule_app/core/database/attendance_providers.dart';

/// شاشة الإعدادات الرئيسية
class SettingsHomeScreen extends ConsumerWidget {
  const SettingsHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: PremiumAppBar(
        title: Text(context.l10n.settingsHeader, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            onPressed: () => _showAboutDialog(context),
            icon: const Icon(Icons.info_outline),
            tooltip: context.l10n.aboutApp,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // معلومات المدرسة
            _buildSchoolInfo(context, ref),
            const SizedBox(height: 24),

            // إعدادات عامة
            SectionHeader(title: context.l10n.generalSettings),
            const SizedBox(height: 12),
            _buildSettingsSection(context),

            const SizedBox(height: 24),

            // إدارة النظام
            SectionHeader(title: context.l10n.systemManagement),
            const SizedBox(height: 12),
            _buildSystemSection(context, ref),

            const SizedBox(height: 24),

            // البيانات والأمان
            SectionHeader(title: context.l10n.dataSecurity),
            const SizedBox(height: 12),
            _buildDataSection(context),

            const SizedBox(height: 24),

            //حول التطبيق
            SectionHeader(title: context.l10n.aboutApp),
            const SizedBox(height: 12),
            _buildAboutSection(context),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildSchoolInfo(BuildContext context, WidgetRef ref) {
    final schoolName = ref.watch(attSchoolNameProvider);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.school,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.schoolInfo,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                schoolName.when(
                  data: (name) => Text(
                    name,
                    style: AppTextStyles.headline5.copyWith(color: Colors.white),
                  maxLines: 1, overflow: TextOverflow.ellipsis),
                  loading: () => Text(
                    context.l10n.operationCancelled,
                    style: const TextStyle(color: Colors.white70),
                  maxLines: 1, overflow: TextOverflow.ellipsis),
                  error: (_, __) => Text(
                    context.l10n.from,
                    style: const TextStyle(color: Colors.white),
                  maxLines: 1, overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => AppNavigator.push(AppRoutes.schoolSettings),
            icon: const Icon(Icons.edit, color: Colors.white),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: -0.1, end: 0);
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          _SettingsTile(
            icon: Icons.school_outlined,
            title: context.l10n.schoolSettingsLabel,
            subtitle: context.l10n.schoolNameYear,
            color: AppColors.primary,
            onTap: () => AppNavigator.push(AppRoutes.schoolSettings),
          ),
          const Divider(height: 1),
          _SettingsTile(
            icon: Icons.schedule_outlined,
            title: context.l10n.schedule,
            subtitle: context.l10n.dailySessions,
            color: AppColors.secondary,
            onTap: () => AppNavigator.push(AppRoutes.timetableSettings),
          ),
          const Divider(height: 1),
          _SettingsTile(
            icon: Icons.notifications_outlined,
            title: context.l10n.userManagement,
            subtitle: context.l10n.alertSettings,
            color: Theme.of(context).colorScheme.secondary,
            onTap: () => AppNavigator.push(AppRoutes.notificationsSettings),
          ),
          const Divider(height: 1),
          _SettingsTile(
            icon: Icons.language,
            title: context.l10n.language,
            subtitle: context.l10n.languageThemeDir,
            color: AppColors.info,
            onTap: () => AppNavigator.push(AppRoutes.languageAndTheme),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemSection(BuildContext context, WidgetRef ref) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          _SettingsTile(
            icon: Icons.people_outline,
            title: context.l10n.userManagement,
            subtitle: context.l10n.addEditDeleteUsers,
            color: AppColors.primary,
            onTap: () => AppNavigator.push(AppRoutes.users),
          ),
          const Divider(height: 1),
          _SettingsTile(
            icon: Icons.class_outlined,
            title: context.l10n.manageClasses,
            subtitle: context.l10n.gradesSectionsSubjects,
            color: AppColors.secondary,
            onTap: () => AppNavigator.push(AppRoutes.grades),
          ),
          const Divider(height: 1),
          _SettingsTile(
            icon: Icons.history,
            title: context.l10n.classLevel,
            subtitle: context.l10n.trackChanges,
            color: Theme.of(context).colorScheme.secondary,
            onTap: () => AppNavigator.push(AppRoutes.auditLog),
          ),
        ],
      ),
    );
  }

  Widget _buildDataSection(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          _SettingsTile(
            icon: Icons.backup_outlined,
            title: context.l10n.backupLabel,
            subtitle: context.l10n.backupRestoreData,
            color: AppColors.success,
            onTap: () => AppNavigator.push(AppRoutes.backup),
          ),
          const Divider(height: 1),
          _SettingsTile(
            icon: Icons.cloud_download_outlined,
            title: context.l10n.importData,
            subtitle: context.l10n.importFromExcel,
            color: AppColors.info,
            onTap: () => AppNavigator.push(AppRoutes.importStudents),
          ),
          const Divider(height: 1),
          _SettingsTile(
            icon: Icons.delete_outline,
            title: context.l10n.clearData,
            subtitle: context.l10n.clearAllData,
            color: Theme.of(context).colorScheme.error,
            onTap: () => _showDeleteConfirmation(context),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          _SettingsTile(
            icon: Icons.info_outline,
            title: context.l10n.aboutApp,
            subtitle: context.l10n.newPassword,
            color: AppColors.primary,
            onTap: () => _showAboutDialog(context),
          ),
          const Divider(height: 1),
          _SettingsTile(
            icon: Icons.help_outline,
            title: context.l10n.help,
            subtitle: context.l10n.userGuide,
            color: AppColors.secondary,
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(context.l10n.guideComing, maxLines: 1, overflow: TextOverflow.ellipsis)),
            ),
          ),
          const Divider(height: 1),
          _SettingsTile(
            icon: Icons.feedback_outlined,
            title: context.l10n.sendFeedback,
            subtitle: context.l10n.shareFeedback,
            color: Theme.of(context).colorScheme.secondary,
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(context.l10n.thanksFeedback, maxLines: 1, overflow: TextOverflow.ellipsis)),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.clearData, maxLines: 1, overflow: TextOverflow.ellipsis),
        content: Text(
          '${context.l10n.clearDataConfirm}\n${context.l10n.cannotUndoAction}',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.cancel, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(context.l10n.clearedSuccessfully, maxLines: 1, overflow: TextOverflow.ellipsis)),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
            child: Text(context.l10n.clear, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: context.l10n.selectValue,
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.school,
          color: AppColors.primary,
          size: 48,
        ),
      ),
      children: [
        Text(context.l10n.integratedSystem, maxLines: 1, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 8),
        Text(context.l10n.rightsReserved, maxLines: 1, overflow: TextOverflow.ellipsis),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 24),
      ),
      title: Text(title, style: AppTextStyles.subtitle1, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(subtitle, style: AppTextStyles.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: AppTextStyles.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis);
  }
}



