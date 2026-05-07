import 'package:school_schedule_app/core/navigation/app_router.dart';
import 'package:school_schedule_app/core/utils/l10n_extension.dart';

import 'package:school_schedule_app/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:school_schedule_app/core/theme/app_colors.dart';
import 'package:school_schedule_app/core/theme/app_text_styles.dart';

// ============================================================================
// SHARED UI WIDGETS — لكلا النظامين (الجداول + الحضور)
// ============================================================================

// ===== مؤشر التحميل =====
class LoadingIndicator extends StatelessWidget {
  final String? message;
  const LoadingIndicator({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 3,
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(message!, style: AppTextStyles.body2, maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ],
      ),
    );
  }
}

// ===== حالة فارغة =====
class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 64, color: AppColors.primary.withOpacity(0.6)),
            ),
            const SizedBox(height: 24),
            Text(title, style: AppTextStyles.headline5, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(subtitle!, style: AppTextStyles.body2, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.add),
                label: Text(actionLabel!, maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ===== حوار تأكيد =====
class ConfirmDialog {
  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    String? confirmLabel,
    String? cancelLabel,
    Color? confirmColor,
    IconData? icon,
  }) {
    final finalConfirmLabel = confirmLabel ?? AppNavigator.navigatorKey.currentContext?.l10n.requiredField ?? 'Confirm';
    final finalCancelLabel = cancelLabel ?? AppNavigator.navigatorKey.currentContext?.l10n.cancel ?? 'Cancel';

    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: confirmColor),
              const SizedBox(width: 12),
            ],
            Text(title, style: AppTextStyles.headline6, maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
        content: Text(message, style: AppTextStyles.body2, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(finalCancelLabel, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: confirmColor),
            child: Text(finalConfirmLabel, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}

// ===== SnackBar موحد =====
enum SnackBarType { success, error, warning, info }

class AppSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    final colors = {
      SnackBarType.success: AppColors.success,
      SnackBarType.error: Theme.of(context).colorScheme.error,
      SnackBarType.warning: Theme.of(context).colorScheme.secondary,
      SnackBarType.info: AppColors.primary,
    };
    final icons = {
      SnackBarType.success: Icons.check_circle_outline,
      SnackBarType.error: Icons.error_outline,
      SnackBarType.warning: Icons.warning_amber_outlined,
      SnackBarType.info: Icons.info_outline,
    };

    final color = colors[type]!;
    final icon = icons[type]!;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(message, style: const TextStyle(color: Colors.white, fontFamily: 'Cairo'), maxLines: 1, overflow: TextOverflow.ellipsis)),
          ],
        ),
        backgroundColor: color,
        duration: duration,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(AppSpacing.md),
      ),
    );
  }
}

// ===== بطاقة إحصائية موحدة =====
class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 12),
            Text(value, style: AppTextStyles.headline4.copyWith(color: color), maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Text(label, style: AppTextStyles.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}

// ===== شريط تقدم الحضور =====
class AttendanceProgressBar extends StatelessWidget {
  final int present;
  final int absent;
  final int late;
  final int total;

  const AttendanceProgressBar({
    super.key,
    required this.present,
    required this.absent,
    required this.late,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    if (total == 0) return const SizedBox.shrink();
    final presentRatio = present / total;
    final absentRatio = absent / total;
    final lateRatio = late / total;

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            height: 12,
            child: Row(
              children: [
                if (presentRatio > 0)
                  Expanded(
                    flex: present,
                    child: Container(color: AppColors.present),
                  ),
                if (lateRatio > 0)
                  Expanded(
                    flex: late,
                    child: Container(color: AppColors.late),
                  ),
                if (absentRatio > 0)
                  Expanded(
                    flex: absent,
                    child: Container(color: AppColors.absent),
                  ),
                Expanded(
                  flex: total - present - absent - late,
                  child: Container(color: AppColors.divider),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _LegendItem(color: AppColors.present, label: AppNavigator.navigatorKey.currentContext!.l10n.present, count: present),
            _LegendItem(color: AppColors.late, label: AppNavigator.navigatorKey.currentContext!.l10n.late, count: late),
            _LegendItem(color: AppColors.absent, label: AppNavigator.navigatorKey.currentContext!.l10n.absent, count: absent),
          ],
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final int count;

  const _LegendItem({required this.color, required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text('$label ($count)', style: AppTextStyles.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
      ],
    );
  }
}

// ===== زر الحالة (حاضر/غائب/متأخر/معذور) =====
class AttendanceStatusButton extends StatelessWidget {
  final String status;
  final bool isSelected;
  final VoidCallback onTap;

  const AttendanceStatusButton({
    super.key,
    required this.status,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppColors.getAttendanceColor(status);
    final label = AppColors.getAttendanceLabel(status);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: color, width: isSelected ? 2 : 1),
        ),
        child: Text(
          label,
          style: AppTextStyles.subtitle2.copyWith(
            color: isSelected ? Colors.white : color,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
    );
  }
}
