import 'package:school_schedule_app/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:school_schedule_app/core/widgets/premium_app_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_schedule_app/core/database/attendance_providers.dart';
import 'package:school_schedule_app/core/theme/app_colors.dart';
import 'package:school_schedule_app/core/theme/app_text_styles.dart';
import 'package:school_schedule_app/core/navigation/app_router.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:school_schedule_app/core/utils/l10n_extension.dart';

/// الشاشة الرئيسية للتحضير
class AttendanceHomeScreen extends ConsumerStatefulWidget {
  const AttendanceHomeScreen({super.key});

  @override
  ConsumerState<AttendanceHomeScreen> createState() => _AttendanceHomeScreenState();
}

class _AttendanceHomeScreenState extends ConsumerState<AttendanceHomeScreen> {
  List<AttSession> _todaySessions = [];
  Map<int, String> _gradeNames = {};
  Map<int, String> _sectionNames = {};
  Map<int, String> _subjectNames = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final db = ref.read(attendanceDatabaseProvider);

    final grades = await db.select(db.attGrades).get();
    final sections = await db.select(db.attSections).get();
    final subjects = await db.select(db.attSubjects).get();

    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final sessions = await (db.select(db.attSessions)
          ..where((s) => s.date.isBetweenValues(startOfDay, endOfDay))
          ..orderBy([(s) => OrderingTerm.desc(s.periodNumber)]))
        .get();

    setState(() {
      _todaySessions = sessions;
      _gradeNames = {for (var g in grades) g.id: g.name};
      _sectionNames = {for (var s in sections) s.id: s.name};
      _subjectNames = {for (var s in subjects) s.id: s.name};
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PremiumAppBar(
        title: Text(context.l10n.attendance, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            onPressed: () => AppNavigator.push(AppRoutes.scanBarcode),
            icon: const Icon(Icons.qr_code_scanner),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.md),
                children: [
                  _buildQuickActions(),
                  const SizedBox(height: 24),
                  _buildTodaySessions(),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => AppNavigator.push(AppRoutes.attendanceSession),
        icon: const Icon(Icons.add),
        label: Text(context.l10n.newAttendance, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: _ActionCard(
            icon: Icons.add_circle_outline,
            title: context.l10n.newAttendance,
            color: AppColors.primary,
            onTap: () => AppNavigator.push(AppRoutes.attendanceSession),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ActionCard(
            icon: Icons.qr_code_scanner,
            title: context.l10n.scanBarcode,
            color: AppColors.success,
            onTap: () => AppNavigator.push(AppRoutes.scanBarcode),
          ),
        ),
      ],
    );
  }

  Widget _buildTodaySessions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${context.l10n.todayPeriods} (${_todaySessions.length})', style: AppTextStyles.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 12),
        if (_todaySessions.isEmpty)
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.event_available, size: 48, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4)),
                  const SizedBox(height: 16),
                  Text(context.l10n.noPeriodsToday, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          )
        else
          ...List.generate(_todaySessions.length, (i) {
            final s = _todaySessions[i];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  child: Text('${s.periodNumber}', style: const TextStyle(color: AppColors.primary), maxLines: 1, overflow: TextOverflow.ellipsis),
                ),
                title: Text(_subjectNames[s.subjectId] ?? context.l10n.subject, maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Text('${_gradeNames[s.gradeId]} - ${_sectionNames[s.sectionId]}', maxLines: 1, overflow: TextOverflow.ellipsis),
                trailing: Chip(
                  label: Text(s.status == 'closed' ? context.l10n.closed : context.l10n.active, maxLines: 1, overflow: TextOverflow.ellipsis),
                  backgroundColor: s.status == 'closed' ? Theme.of(context).colorScheme.onSurface.withOpacity(0.1) : AppColors.success.withOpacity(0.1),
                ),
                onTap: () => AppNavigator.push(AppRoutes.attendanceSession, arguments: s),
              ),
            );
          }),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({required this.icon, required this.title, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color.withOpacity(0.1),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }
}


