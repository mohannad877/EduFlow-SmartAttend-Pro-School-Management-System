import 'package:school_schedule_app/core/utils/l10n_extension.dart';

import 'package:school_schedule_app/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:school_schedule_app/core/widgets/premium_app_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:school_schedule_app/core/theme/app_colors.dart';
import 'package:school_schedule_app/core/theme/app_text_styles.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:school_schedule_app/core/database/attendance_providers.dart';

/// شاشة سجل التعديلات
class AuditLogScreen extends ConsumerStatefulWidget {
  const AuditLogScreen({super.key});

  @override
  ConsumerState<AuditLogScreen> createState() => _AuditLogScreenState();
}

class _AuditLogScreenState extends ConsumerState<AuditLogScreen> {
  List<AuditEntry> _logs = [];
  bool _isLoading = true;
  String _filterAction = 'all';

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    setState(() => _isLoading = true);
    final db = ref.read(attendanceDatabaseProvider);

    final logs = await (db.select(db.auditLog)
          ..orderBy([(l) => OrderingTerm.desc(l.createdAt)])
          ..limit(100))
        .get();

    setState(() {
      _logs = logs;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PremiumAppBar(
        title: Text(context.l10n.classLevel, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            onPressed: _loadLogs,
            icon: const Icon(Icons.refresh),
          ),
          PopupMenuButton(
            icon: const Icon(Icons.filter_list),
            itemBuilder: (context) => [
              PopupMenuItem(value: 'all', child: Text(context.l10n.invalidEmail, maxLines: 1, overflow: TextOverflow.ellipsis)),
              PopupMenuItem(value: 'create', child: Text(context.l10n.add, maxLines: 1, overflow: TextOverflow.ellipsis)),
              PopupMenuItem(value: 'update', child: Text(context.l10n.edit, maxLines: 1, overflow: TextOverflow.ellipsis)),
              PopupMenuItem(value: 'delete', child: Text(context.l10n.delete, maxLines: 1, overflow: TextOverflow.ellipsis)),
            ],
            onSelected: (value) {
              setState(() => _filterAction = value);
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _logs.isEmpty
              ? _buildEmptyState()
              : _buildLogsList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.history, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            context.l10n.noRecords,
            style: AppTextStyles.titleMedium.copyWith(color: Colors.grey),
          maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 8),
          Text(
            context.l10n.logAppearsHere,
            style: AppTextStyles.caption.copyWith(color: Colors.grey),
          maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _buildLogsList() {
    final filteredLogs = _logs.where((log) {
      if (_filterAction == 'all') return true;
      return log.action == _filterAction;
    }).toList();

    return RefreshIndicator(
      onRefresh: _loadLogs,
      child: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.md),
        itemCount: filteredLogs.length,
        itemBuilder: (context, index) {
          final log = filteredLogs[index];
          return _AuditLogCard(
            log: log,
            onTap: () => _showLogDetails(log),
          ).animate().fadeIn(delay: (index * 50).ms);
        },
      ),
    );
  }

  void _showLogDetails(AuditEntry log) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.logDetails, style: AppTextStyles.headline5, maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 16),
            _DetailRow(label: context.l10n.action, value: _getActionText(log.action)),
            _DetailRow(label: context.l10n.table, value: _getTableName(log.targetTable)),
            _DetailRow(label: context.l10n.recordNumber, value: log.recordId.toString()),
            _DetailRow(label: context.l10n.search, value: _formatDateTime(log.createdAt)),
            if (log.oldValue != null) ...[
              const Divider(),
              Text(context.l10n.oldValue, style: TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(log.oldValue!, maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
            ],
            if (log.newValue != null) ...[
              const SizedBox(height: 12),
              Text(context.l10n.newValue, style: TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(log.newValue!, maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
            ],
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  String _getActionText(String action) {
    switch (action) {
      case 'create':
        return context.l10n.add;
      case 'update':
        return context.l10n.edit;
      case 'delete':
        return context.l10n.delete;
      default:
        return action;
    }
  }

  String _getTableName(String tableName) {
    final names = {
      'students': context.l10n.studentsLabel,
      'users': context.l10n.usersLabel,
      'sessions': context.l10n.sessions,
      'AttRecord': context.l10n.session,
      'grades': context.l10n.classLevel,
      'sections': context.l10n.sections,
      'subjects': context.l10n.subjects,
    };
    return names[tableName] ?? tableName;
  }

  String _formatDateTime(DateTime dateTime) {
    final months = [
      context.l10n.january, context.l10n.february, context.l10n.march, context.l10n.april, context.l10n.may, context.l10n.june,
      context.l10n.july, context.l10n.august, context.l10n.september, context.l10n.october, context.l10n.november, context.l10n.december
    ];
    return '${dateTime.day} ${months[dateTime.month - 1]} ${dateTime.year} - ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

class _AuditLogCard extends StatelessWidget {
  final AuditEntry log;
  final VoidCallback onTap;

  const _AuditLogCard({
    required this.log,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color actionColor;
    IconData actionIcon;
    String actionText;

    switch (log.action) {
      case 'create':
        actionColor = AppColors.success;
        actionIcon = Icons.add_circle;
        actionText = context.l10n.add;
        break;
      case 'update':
        actionColor = Theme.of(context).colorScheme.secondary;
        actionIcon = Icons.edit;
        actionText = context.l10n.edit;
        break;
      case 'delete':
        actionColor = Theme.of(context).colorScheme.error;
        actionIcon = Icons.delete;
        actionText = context.l10n.delete;
        break;
      default:
        actionColor = Colors.grey;
        actionIcon = Icons.help;
        actionText = log.action;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: actionColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(actionIcon, color: actionColor),
        ),
        title: Text(
          context.l10n.actionInTable(actionText, _getTableName(context, log.targetTable)),
          style: AppTextStyles.subtitle1,
        maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          context.l10n.logNumber,
          style: AppTextStyles.caption,
        maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: Text(
          _formatDate(context, log.createdAt),
          style: AppTextStyles.caption.copyWith(color: Colors.grey),
        maxLines: 1, overflow: TextOverflow.ellipsis),
        onTap: onTap,
      ),
    );
  }

  String _getTableName(BuildContext context, String tableName) {
    final names = {
      'students': context.l10n.students,
      'users': context.l10n.users,
      'sessions': context.l10n.sessions,
      'AttRecord': context.l10n.session,
      'grades': context.l10n.classLevel,
      'sections': context.l10n.sections,
      'subjects': context.l10n.subjects,
    };
    return names[tableName] ?? tableName;
  }

  String _formatDate(BuildContext context, DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 1) {
      return context.l10n.now;
    } else if (diff.inHours < 1) {
      return context.l10n.minutesAgo(diff.inMinutes);
    } else if (diff.inDays < 1) {
      return context.l10n.hoursAgo(diff.inHours);
    } else if (diff.inDays < 7) {
      return context.l10n.daysAgo(diff.inDays);
    } else {
      return '${dateTime.day}/${dateTime.month}';
    }
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
          Expanded(
            child: Text(value, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}


