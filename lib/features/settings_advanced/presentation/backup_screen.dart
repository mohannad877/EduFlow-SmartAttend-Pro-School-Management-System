import 'package:school_schedule_app/core/utils/l10n_extension.dart';
import 'package:school_schedule_app/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:school_schedule_app/core/widgets/premium_app_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:school_schedule_app/core/theme/app_colors.dart';
import 'package:school_schedule_app/core/theme/app_text_styles.dart';
import 'package:school_schedule_app/core/services/backup_service.dart';
import 'package:school_schedule_app/core/navigation/app_router.dart';

// ============================================================================
// BackupScreen — Real SQLite Backup & Restore
// ============================================================================

enum _OperationState { idle, running, done, error }

class BackupScreen extends ConsumerStatefulWidget {
  const BackupScreen({super.key});

  @override
  ConsumerState<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends ConsumerState<BackupScreen> {
  _OperationState _backupState = _OperationState.idle;
  _OperationState _restoreState = _OperationState.idle;

  double _backupProgress = 0.0;
  double _restoreProgress = 0.0;
  String _backupMessage = '';
  String _restoreMessage = '';

  BackupResult? _lastBackupResult;
  RestoreResult? _lastRestoreResult;
  List<BackupEntry> _backupHistory = [];
  bool _historyLoading = true;
  int _autoBackupInterval = 0;

  @override
  void initState() {
    super.initState();
    _loadHistory();
    BackupService.getAutoBackupInterval().then((value) {
      if (mounted) setState(() => _autoBackupInterval = value);
    });
  }

  Future<void> _loadHistory() async {
    setState(() => _historyLoading = true);
    final history = await BackupService.getBackupHistory();
    if (mounted) {
      setState(() {
      _backupHistory = history;
      _historyLoading = false;
    });
    }
  }

  Future<void> _createBackup() async {
    setState(() {
      _backupState = _OperationState.running;
      _backupProgress = 0;
      _backupMessage = context.l10n.initializing;
      _lastBackupResult = null;
    });

    final result = await BackupService.createBackup(
      onProgress: (msg, progress) {
        if (mounted) {
          setState(() {
          _backupMessage = msg;
          _backupProgress = progress;
        });
        }
      },
    );

    if (!mounted) return;
    setState(() {
      _lastBackupResult = result;
      _backupState = result.isSuccess ? _OperationState.done : _OperationState.error;
    });

    if (result.isSuccess) {
      _loadHistory();
    }
  }

  Future<void> _pickAndRestore() async {
    // Confirm first
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Theme.of(ctx).colorScheme.secondary, size: 28),
            const SizedBox(width: 10),
            Expanded(child: Text(context.l10n.restoreWarning, maxLines: 1, overflow: TextOverflow.ellipsis)),
          ],
        ),
        content: Text(
          '${context.l10n.willReplaceData}\n${context.l10n.cannotUndo}',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(context.l10n.cancel, maxLines: 1, overflow: TextOverflow.ellipsis)),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.secondary),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(context.l10n.continueAction, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _restoreState = _OperationState.running;
      _restoreProgress = 0;
      _restoreMessage = context.l10n.selectBackupFolder;
      _lastRestoreResult = null;
    });

    final result = await BackupService.pickAndRestore(
      onProgress: (msg, progress) {
        if (mounted) {
          setState(() {
          _restoreMessage = msg;
          _restoreProgress = progress;
        });
        }
      },
    );

    if (!mounted) return;
    setState(() {
      _lastRestoreResult = result;
      _restoreState = result.isCancelled
          ? _OperationState.idle
          : result.isSuccess
              ? _OperationState.done
              : _OperationState.error;
    });

    if (result.isSuccess) {
      // Show restart dialog
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          title: Text(context.l10n.restoreSuccess, maxLines: 1, overflow: TextOverflow.ellipsis),
          content: Text(context.l10n.restartRequired, maxLines: 1, overflow: TextOverflow.ellipsis),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.pop(ctx);
                AppNavigator.pushAndRemoveAll(AppRoutes.splash);
              },
              child: Text(context.l10n.restart, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _restoreFromEntry(BackupEntry entry) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.restore, color: Theme.of(ctx).colorScheme.secondary, size: 28),
            const SizedBox(width: 10),
            Expanded(child: Text(context.l10n.restoreFromLog, maxLines: 1, overflow: TextOverflow.ellipsis)),
          ],
        ),
        content: Text(
          '${context.l10n.willRestoreDate}\n${context.l10n.size}\n${context.l10n.willReplaceData2}',
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(context.l10n.cancel, maxLines: 1, overflow: TextOverflow.ellipsis)),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.secondary),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(context.l10n.restore, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() {
      _restoreState = _OperationState.running;
      _restoreProgress = 0;
      _restoreMessage = context.l10n.restoring;
    });

    final result = await BackupService.restoreFromDirectory(
      backupPath: entry.path,
      onProgress: (msg, progress) {
        if (mounted) {
          setState(() {
          _restoreMessage = msg;
          _restoreProgress = progress;
        });
        }
      },
    );

    if (!mounted) return;
    setState(() {
      _lastRestoreResult = result;
      _restoreState =
          result.isSuccess ? _OperationState.done : _OperationState.error;
    });

    if (result.isSuccess) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          title: Text(context.l10n.restoreSuccess, maxLines: 1, overflow: TextOverflow.ellipsis),
          content: Text(context.l10n.restartRequired, maxLines: 1, overflow: TextOverflow.ellipsis),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.pop(ctx);
                AppNavigator.pushAndRemoveAll(AppRoutes.splash);
              },
              child: Text(context.l10n.restart, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _deleteBackupEntry(BackupEntry entry) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.deleteBackup, maxLines: 1, overflow: TextOverflow.ellipsis),
        content: Text(context.l10n.confirmDeleteBackup, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(context.l10n.cancel, maxLines: 1, overflow: TextOverflow.ellipsis)),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(context.l10n.delete, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await BackupService.deleteBackup(entry.path);
      _loadHistory();
    }
  }

  // ── build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PremiumAppBar(
        title: Text(context.l10n.backupLabel, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadHistory,
            tooltip: context.l10n.update,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header info
            _buildInfoCard().animate().fadeIn(duration: 300.ms),
            const SizedBox(height: 20),

            // Auto Backup Section
            _buildSectionHeader(context.l10n.autoBackupSettings),
            const SizedBox(height: 12),
            _buildAutoBackupSection().animate().fadeIn(delay: 100.ms),
            const SizedBox(height: 24),

            // Create backup section
            _buildSectionHeader(context.l10n.createBackup),
            const SizedBox(height: 12),
            _buildCreateBackupSection().animate().fadeIn(delay: 100.ms),
            const SizedBox(height: 24),

            // Restore section
            _buildSectionHeader(context.l10n.restoreBackup),
            const SizedBox(height: 12),
            _buildRestoreSection().animate().fadeIn(delay: 200.ms),
            const SizedBox(height: 24),

            // History
            _buildSectionHeader(context.l10n.backupLog),
            const SizedBox(height: 12),
            _buildBackupHistory().animate().fadeIn(delay: 300.ms),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1565C0), Color(0xFF1E88E5)],
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.shield_rounded, color: Colors.white, size: 36),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.l10n.protectData, style: AppTextStyles.titleMedium.copyWith(color: Colors.white), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(
                  context.l10n.actualTables,
                  style: AppTextStyles.caption.copyWith(color: Colors.white70),
                maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(title, style: AppTextStyles.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis);
  }

  Widget _buildAutoBackupSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(context.l10n.enableAutoBackup, style: TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                      SizedBox(height: 4),
                      Text(context.l10n.backgroundBackup, style: AppTextStyles.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                DropdownButton<int>(
                  value: _autoBackupInterval,
                  items: [
                    DropdownMenuItem(value: 0, child: Text(context.l10n.stop, maxLines: 1, overflow: TextOverflow.ellipsis)),
                    DropdownMenuItem(value: 1, child: Text(context.l10n.daily, maxLines: 1, overflow: TextOverflow.ellipsis)),
                    DropdownMenuItem(value: 7, child: Text(context.l10n.weekly, maxLines: 1, overflow: TextOverflow.ellipsis)),
                    DropdownMenuItem(value: 30, child: Text(context.l10n.monthly, maxLines: 1, overflow: TextOverflow.ellipsis)),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _autoBackupInterval = val);
                      BackupService.setAutoBackupInterval(val);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${context.l10n.autoEnabled}: ${val == 0 ? context.l10n.stop : val == 1 ? context.l10n.daily : val == 7 ? context.l10n.weekly : context.l10n.monthly}', maxLines: 1, overflow: TextOverflow.ellipsis))
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateBackupSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.save_rounded, color: AppColors.success, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(context.l10n.newBackup, style: AppTextStyles.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                      Text(context.l10n.saveDbSeparate, style: AppTextStyles.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ],
            ),

            if (_backupState == _OperationState.running) ...[
              const SizedBox(height: 16),
              Text(_backupMessage, style: AppTextStyles.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: _backupProgress,
                borderRadius: BorderRadius.circular(4),
                backgroundColor: AppColors.success.withOpacity(0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.success),
              ),
            ],

            if (_lastBackupResult != null) ...[
              const SizedBox(height: 12),
              _buildResultBanner(
                success: _lastBackupResult!.isSuccess,
                message: _lastBackupResult!.isSuccess
                    ? context.l10n.savedSuccessfully
                    : '❌ ${_lastBackupResult!.error}',
              ),
            ],

            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _backupState == _OperationState.running ? null : _createBackup,
                    icon: _backupState == _OperationState.running
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.cloud_upload_rounded),
                    label: Text(_backupState == _OperationState.running ? context.l10n.saving : context.l10n.createBackupNow, maxLines: 1, overflow: TextOverflow.ellipsis),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.success,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRestoreSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.restore_rounded, color: AppColors.secondary, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(context.l10n.restoreFromFile, style: AppTextStyles.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                      Text(context.l10n.selectBackupFolderDevice, style: AppTextStyles.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ],
            ),

            if (_restoreState == _OperationState.running) ...[
              const SizedBox(height: 16),
              Text(_restoreMessage, style: AppTextStyles.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: _restoreProgress,
                borderRadius: BorderRadius.circular(4),
                backgroundColor: AppColors.secondary.withOpacity(0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.secondary),
              ),
            ],

            if (_lastRestoreResult != null && !_lastRestoreResult!.isCancelled) ...[
              const SizedBox(height: 12),
              _buildResultBanner(
                success: _lastRestoreResult!.isSuccess,
                message: _lastRestoreResult!.isSuccess
                    ? context.l10n.restoreSuccess2
                    : '❌ ${_lastRestoreResult!.error}',
              ),
            ],

            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Theme.of(context).colorScheme.error.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Theme.of(context).colorScheme.error, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      context.l10n.warningRestore,
                      style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12),
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _restoreState == _OperationState.running ? null : _pickAndRestore,
                icon: _restoreState == _OperationState.running
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.folder_open_rounded),
                label: Text(_restoreState == _OperationState.running ? context.l10n.restoring : context.l10n.selectFolderRestore, maxLines: 1, overflow: TextOverflow.ellipsis),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackupHistory() {
    if (_historyLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_backupHistory.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: AppColors.textHint.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.textHint.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(Icons.history_rounded, size: 48, color: AppColors.textHint),
            const SizedBox(height: 12),
            Text(context.l10n.noBackups, style: TextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Text(context.l10n.createBackupStart, style: TextStyle(color: AppColors.textHint, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
      );
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: _backupHistory.asMap().entries.map((entry) {
          final i = entry.key;
          final backup = entry.value;
          return Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.folder_zip_rounded, color: AppColors.primary),
                ),
                title: Text(backup.timestamp, style: AppTextStyles.subtitle1, maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Text(context.l10n.sizeBackup, style: AppTextStyles.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.restore_rounded, color: Theme.of(context).colorScheme.secondary),
                      onPressed: () => _restoreFromEntry(backup),
                      tooltip: context.l10n.restore,
                    ),
                    IconButton(
                      icon: Icon(Icons.delete_outline_rounded, color: Theme.of(context).colorScheme.error),
                      onPressed: () => _deleteBackupEntry(backup),
                      tooltip: context.l10n.delete,
                    ),
                  ],
                ),
              ),
              if (i < _backupHistory.length - 1) const Divider(height: 1),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildResultBanner({required bool success, required String message}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: (success ? AppColors.success : Theme.of(context).colorScheme.error).withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: (success ? AppColors.success : Theme.of(context).colorScheme.error).withOpacity(0.3),
        ),
      ),
      child: Text(
        message,
        style: TextStyle(
          color: success ? AppColors.success : Theme.of(context).colorScheme.error,
          fontSize: 13,
          fontFamily: 'Cairo',
        ),
      maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }
}
