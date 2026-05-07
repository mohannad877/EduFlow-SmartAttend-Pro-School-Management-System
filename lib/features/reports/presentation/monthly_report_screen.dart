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

/// شاشة التقرير الشهري
class MonthlyReportScreen extends ConsumerStatefulWidget {
  const MonthlyReportScreen({super.key});

  @override
  ConsumerState<MonthlyReportScreen> createState() => _MonthlyReportScreenState();
}

class _MonthlyReportScreenState extends ConsumerState<MonthlyReportScreen> {
  DateTime _selectedMonth = DateTime.now();
  Map<int, DayStats> _dailyStats = {};
  MonthlyStats _monthlyStats = MonthlyStats.empty();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final db = ref.read(attendanceDatabaseProvider);

    final startOfMonth = DateTime(_selectedMonth.year, _selectedMonth.month, 1);
    final endOfMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0);

    // جلب جميع الجلسات للشهر المحدد
    final sessions = await (db.select(db.attSessions)
          ..where((s) => s.date.isBetweenValues(startOfMonth, endOfMonth)))
        .get();

    // حساب الإحصائيات لكل يوم
    var dailyStatsMap = <int, DayStats>{};
    var totalPresent = 0;
    var totalAbsent = 0;
    var totalLate = 0;
    var totalExcused = 0;

    for (var session in sessions) {
      final recordsList = await (db.select(db.attRecords)
            ..where((a) => a.sessionId.equals(session.id)))
          .get();

      final dayOfMonth = session.date.day;

      for (var record in recordsList) {
        switch (record.status) {
          case 'present':
            totalPresent++;
            dailyStatsMap[dayOfMonth] = (dailyStatsMap[dayOfMonth] ?? DayStats.empty())
                .copyWith(present: dailyStatsMap[dayOfMonth]!.present + 1);
            break;
          case 'absent':
            totalAbsent++;
            dailyStatsMap[dayOfMonth] = (dailyStatsMap[dayOfMonth] ?? DayStats.empty())
                .copyWith(absent: dailyStatsMap[dayOfMonth]!.absent + 1);
            break;
          case 'late':
            totalLate++;
            dailyStatsMap[dayOfMonth] = (dailyStatsMap[dayOfMonth] ?? DayStats.empty())
                .copyWith(late: dailyStatsMap[dayOfMonth]!.late + 1);
            break;
          case 'excused':
            totalExcused++;
            break;
        }
      }
    }

    final students = await db.select(db.attStudents).get();
    final totalStudents = students.length;
    final daysWithSessions = dailyStatsMap.length;

    setState(() {
      _dailyStats = dailyStatsMap;
      _monthlyStats = MonthlyStats(
        totalStudents: totalStudents,
        totalPresent: totalPresent,
        totalAbsent: totalAbsent,
        totalLate: totalLate,
        totalExcused: totalExcused,
        daysWithSessions: daysWithSessions,
        totalSessions: sessions.length,
      );
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PremiumAppBar(
        title: Text(context.l10n.monthlyReportLabel, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            onPressed: _exportReport,
            icon: const Icon(Icons.share),
            tooltip: context.l10n.exportLabel,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // اختيار الشهر
                  _buildMonthSelector(),
                  const SizedBox(height: 20),

                  // إحصائيات الشهر
                  _buildMonthlyStats(),
                  const SizedBox(height: 24),

                  // الرسم البياني
                  _buildChart(),
                  const SizedBox(height: 24),

                  // تفاصيل الأيام
                  SectionHeader(title: context.l10n.validate),
                  const SizedBox(height: 12),
                  _buildDaysList(),

                  const SizedBox(height: 80),
                ],
              ),
            ),
    );
  }

  Widget _buildMonthSelector() {
    final months = [
      context.l10n.january, context.l10n.february, context.l10n.march, context.l10n.april, context.l10n.may, context.l10n.june,
      context.l10n.july, context.l10n.august, context.l10n.september, context.l10n.october, context.l10n.november, context.l10n.december
    ];

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => _changeMonth(-1),
            icon: const Icon(Icons.chevron_right),
          ),
          Expanded(
            child: InkWell(
              onTap: _selectMonth,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.calendar_month, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      '${months[_selectedMonth.month - 1]} ${_selectedMonth.year}',
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () => _changeMonth(1),
            icon: const Icon(Icons.chevron_left),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyStats() {
    final rate = _monthlyStats.totalPresent + _monthlyStats.totalAbsent > 0
        ? ((_monthlyStats.totalPresent /
                (_monthlyStats.totalPresent + _monthlyStats.totalAbsent)) *
            100)
            .toStringAsFixed(1)
        : '0';

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.secondary, AppColors.secondary.withOpacity(0.7)],
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.clearSchedule,
                style: AppTextStyles.titleMedium.copyWith(color: Colors.white),
              maxLines: 1, overflow: TextOverflow.ellipsis),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  context.l10n.exportPdf,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatBox(
                label: context.l10n.pleaseSelectTeacher,
                value: _monthlyStats.totalPresent.toString(),
                color: AppColors.success,
              ),
              _StatBox(
                label: context.l10n.dismiss,
                value: _monthlyStats.totalAbsent.toString(),
                color: Theme.of(context).colorScheme.error,
              ),
              _StatBox(
                label: context.l10n.clearScheduleConfirm,
                value: _monthlyStats.totalLate.toString(),
                color: Theme.of(context).colorScheme.secondary,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatBox(
                label: context.l10n.exportExcel,
                value: _monthlyStats.totalExcused.toString(),
                color: AppColors.info,
              ),
              _StatBox(
                label: context.l10n.selectClassroom,
                value: _monthlyStats.daysWithSessions.toString(),
                color: Colors.white,
              ),
              _StatBox(
                label: context.l10n.totalSessions,
                value: _monthlyStats.totalSessions.toString(),
                color: Colors.white70,
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn().scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildChart() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.pleaseSelectClassroom, style: AppTextStyles.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 16),
          SizedBox(
            height: 150,
            child: _buildBarChart(),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart() {
    final daysInMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0).day;
    final maxValue = _dailyStats.values.fold<int>(
      0,
      (max, stats) {
        final total = stats.present + stats.absent + stats.late;
        return total > max ? total : max;
      },
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(daysInMonth, (index) {
        final day = index + 1;
        final stats = _dailyStats[day];
        final total = stats != null ? stats.present + stats.absent + stats.late : 0;
        final height = maxValue > 0 ? (total / maxValue) * 120 : 0.0;

        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 1),
            height: height > 0 ? height : 4,
            decoration: BoxDecoration(
              color: stats != null
                  ? (stats.absent > stats.present ? Theme.of(context).colorScheme.error : AppColors.success)
                  : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildDaysList() {
    final daysInMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0).day;

    return Column(
      children: List.generate(daysInMonth, (index) {
        final day = index + 1;
        final stats = _dailyStats[day];

        if (stats == null) return const SizedBox.shrink();

        final total = stats.present + stats.absent + stats.late;
        final rate = total > 0 ? ((stats.present / total) * 100).toStringAsFixed(0) : '0';

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: Text(
                '$day',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
            title: Text(context.l10n.free, maxLines: 1, overflow: TextOverflow.ellipsis),
            subtitle: Row(
              children: [
                _MiniStat(icon: Icons.check, value: stats.present, color: AppColors.success),
                const SizedBox(width: 8),
                _MiniStat(icon: Icons.close, value: stats.absent, color: Theme.of(context).colorScheme.error),
                const SizedBox(width: 8),
                _MiniStat(icon: Icons.schedule, value: stats.late, color: Theme.of(context).colorScheme.secondary),
              ],
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: double.parse(rate) >= 80
                    ? AppColors.success.withOpacity(0.1)
                    : Theme.of(context).colorScheme.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$rate%',
                style: TextStyle(
                  color: double.parse(rate) >= 80 ? AppColors.success : Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
              maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ),
        );
      }),
    );
  }

  void _changeMonth(int months) {
    setState(() {
      _selectedMonth = DateTime(
        _selectedMonth.year,
        _selectedMonth.month + months,
        1,
      );
    });
    _loadData();
  }

  Future<void> _selectMonth() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedMonth,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.year,
      locale: const Locale('ar', 'SA'),
    );
    if (date != null) {
      setState(() => _selectedMonth = DateTime(date.year, date.month, 1));
      _loadData();
    }
  }

  void _exportReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.scheduleGenerationSuccess, maxLines: 1, overflow: TextOverflow.ellipsis)),
    );
  }
}

class MonthlyStats {
  final int totalStudents;
  final int totalPresent;
  final int totalAbsent;
  final int totalLate;
  final int totalExcused;
  final int daysWithSessions;
  final int totalSessions;

  MonthlyStats({
    required this.totalStudents,
    required this.totalPresent,
    required this.totalAbsent,
    required this.totalLate,
    required this.totalExcused,
    required this.daysWithSessions,
    required this.totalSessions,
  });

  factory MonthlyStats.empty() => MonthlyStats(
        totalStudents: 0,
        totalPresent: 0,
        totalAbsent: 0,
        totalLate: 0,
        totalExcused: 0,
        daysWithSessions: 0,
        totalSessions: 0,
      );
}

class DayStats {
  final int present;
  final int absent;
  final int late;

  DayStats({required this.present, required this.absent, required this.late});

  factory DayStats.empty() => DayStats(present: 0, absent: 0, late: 0);

  DayStats copyWith({int? present, int? absent, int? late}) {
    return DayStats(
      present: present ?? this.present,
      absent: absent ?? this.absent,
      late: late ?? this.late,
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatBox({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        maxLines: 1, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: color.withOpacity(0.8),
            fontSize: 12,
          ),
        maxLines: 1, overflow: TextOverflow.ellipsis),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final int value;
  final Color color;

  const _MiniStat({
    required this.icon,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 2),
        Text(
          '$value',
          style: TextStyle(color: color, fontSize: 12),
        maxLines: 1, overflow: TextOverflow.ellipsis),
      ],
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



