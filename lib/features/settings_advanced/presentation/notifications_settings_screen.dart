import 'package:school_schedule_app/core/utils/l10n_extension.dart';
import 'package:school_schedule_app/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:school_schedule_app/core/widgets/premium_app_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_schedule_app/core/theme/app_colors.dart';
import 'package:school_schedule_app/core/theme/app_text_styles.dart';
import 'package:school_schedule_app/core/providers/notifications_provider.dart';

class NotificationsSettingsScreen extends ConsumerWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(notificationSettingsProvider);
    final notifier = ref.read(notificationSettingsProvider.notifier);

    return Scaffold(
      appBar: PremiumAppBar(
        title: Text(context.l10n.english, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          SwitchListTile(
            title: Text(context.l10n.enableAllNotifications, style: TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
            subtitle: Text(context.l10n.globalNotifications, maxLines: 1, overflow: TextOverflow.ellipsis),
            value: settings.enableAll,
            activeColor: AppColors.primary,
            onChanged: (val) => notifier.toggleAll(val),
          ),
          const Divider(),
          _buildToggleItem(
            context.l10n.attendanceAlerts,
            context.l10n.attendanceNotifications,
            settings.attendanceAlerts,
            settings.enableAll ? (val) => notifier.toggleAttendance(val) : null,
          ),
          _buildToggleItem(
            context.l10n.smartSystemAlerts,
            context.l10n.scheduleAlerts,
            settings.systemAlerts,
            settings.enableAll ? (val) => notifier.toggleSystem(val) : null,
          ),
          _buildToggleItem(
            context.l10n.backupAlerts,
            context.l10n.backupReminders,
            settings.backupAlerts,
            settings.enableAll ? (val) => notifier.toggleBackup(val) : null,
          ),
        ],
      ),
    );
  }

  Widget _buildToggleItem(String title, String subtitle, bool value, ValueChanged<bool>? onChanged) {
    return SwitchListTile(
      title: Text(title, style: AppTextStyles.subtitle1, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(subtitle, style: AppTextStyles.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
      value: value,
      activeColor: AppColors.primary,
      onChanged: onChanged,
    );
  }
}
