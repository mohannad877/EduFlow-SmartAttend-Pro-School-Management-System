import 'package:school_schedule_app/core/utils/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:school_schedule_app/core/widgets/premium_app_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_schedule_app/core/providers/notifications_provider.dart';
import 'package:school_schedule_app/core/theme/app_colors.dart';
import 'package:school_schedule_app/core/theme/app_text_styles.dart';
import 'package:school_schedule_app/core/navigation/app_router.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationsProvider);
    final notifier = ref.read(notificationsProvider.notifier);

    return Scaffold(
      appBar: PremiumAppBar(
        title: Text(context.l10n.userManagement, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: context.l10n.english,
            onPressed: () {
              AppNavigator.push(AppRoutes.notificationsSettings);
            },
          ),
          if (notifications.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.done_all),
              tooltip: context.l10n.markAllRead,
              onPressed: () {
                notifier.markAllAsRead();
              },
            ),
        ],
      ),
      body: notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off_outlined,
                      size: 80, color: AppColors.textHint.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  Text(context.l10n.noNotifications,
                      style: AppTextStyles.headline6
                          .copyWith(), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            )
          : ListView.separated(
              itemCount: notifications.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  tileColor: notification.isRead
                      ? null
                      : AppColors.primaryLight.withOpacity(0.1),
                  leading: CircleAvatar(
                    backgroundColor: _getIconColor(notification.type).withOpacity(0.1),
                    child: Icon(_getIcon(notification.type),
                        color: _getIconColor(notification.type)),
                  ),
                  title: Text(
                    notification.title,
                    style: TextStyle(
                      fontWeight:
                          notification.isRead ? FontWeight.normal : FontWeight.bold,
                    ),
                  maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(notification.message, maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('yyyy-MM-dd HH:mm').format(notification.timestamp),
                        style: AppTextStyles.caption
                            .copyWith(color: AppColors.textHint),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                  onTap: () {
                    if (!notification.isRead) {
                      notifier.markAsRead(notification.id);
                    }
                  },
                );
              },
            ),
    );
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'backup':
        return Icons.cloud_done;
      case 'attendance':
        return Icons.co_present;
      case 'system':
        return Icons.error_outline;
      default:
        return Icons.notifications;
    }
  }

  Color _getIconColor(String type) {
    switch (type) {
      case 'backup':
        return Colors.blue;
      case 'attendance':
        return Colors.green;
      case 'system':
        return Colors.blue;
      default:
        return AppColors.primary;
    }
  }
}
