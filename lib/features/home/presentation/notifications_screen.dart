import 'package:school_schedule_app/core/utils/l10n_extension.dart';

import 'package:school_schedule_app/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:school_schedule_app/core/widgets/premium_app_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:school_schedule_app/core/theme/app_colors.dart';
import 'package:school_schedule_app/core/theme/app_text_styles.dart';
import 'package:school_schedule_app/core/providers/notifications_provider.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // إعداد اللغة العربية في مكتبة timeago إذا لزم
    timeago.setLocaleMessages('ar', timeago.ArMessages());

    final notifications = ref.watch(notificationsProvider);

    return Scaffold(
      appBar: PremiumAppBar(
        title: Text(context.l10n.noActiveScheduleDesc, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          if (notifications.isNotEmpty)
            TextButton(
              onPressed: () {
                ref.read(notificationsProvider.notifier).markAllAsRead();
              },
              child: Text(context.l10n.generateNewSchedule, style: TextStyle(color: Colors.white), maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
        ],
      ),
      body: notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_none_rounded, size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(context.l10n.scheduleStats, style: AppTextStyles.headline6.copyWith(color: Colors.grey.shade600), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: notifications.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final notif = notifications[index];
                return _NotificationTile(notification: notif);
              },
            ),
    );
  }
}

class _NotificationTile extends ConsumerWidget {
  final AppNotification notification;
  
  const _NotificationTile({required this.notification});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    IconData icon;
    Color iconColor;

    switch (notification.type) {
      case 'attendance':
        icon = Icons.fact_check_rounded;
        iconColor = AppColors.secondary;
        break;
      case 'backup':
        icon = Icons.cloud_done_rounded;
        iconColor = AppColors.success;
        break;
      case 'system':
      default:
        icon = Icons.info_outline_rounded;
        iconColor = AppColors.info;
        break;
    }

    return InkWell(
      onTap: () {
        if (!notification.isRead) {
          ref.read(notificationsProvider.notifier).markAsRead(notification.id);
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: notification.isRead ? AppColors.surface : AppColors.primaryLight.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: notification.isRead ? AppColors.divider : AppColors.primaryLight.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: notification.isRead ? null : AppColors.softShadow,
        ),
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: iconColor.withOpacity(0.15),
              radius: 24,
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(notification.title, style: AppTextStyles.subtitle1.copyWith(
                        fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.bold,
                      ), maxLines: 1, overflow: TextOverflow.ellipsis),
                      Text(
                        timeago.format(notification.timestamp, locale: 'ar'),
                        style: AppTextStyles.caption,
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.message,
                    style: AppTextStyles.body2.copyWith(
                      color: notification.isRead ? AppColors.textSecondary : AppColors.textPrimary,
                    ),
                  maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            if (!notification.isRead) ...[
              const SizedBox(width: 8),
              const Center(
                child: CircleAvatar(radius: 4, backgroundColor: AppColors.primary),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
