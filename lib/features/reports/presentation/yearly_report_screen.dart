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

/// شاشة التقرير السنوي
class YearlyReportScreen extends ConsumerStatefulWidget {
  const YearlyReportScreen({super.key});

  @override
  ConsumerState<YearlyReportScreen> createState() => _YearlyReportScreenState();
}

class _YearlyReportScreenState extends ConsumerState<YearlyReportScreen> {
  int _selectedYear = DateTime.now().year;
  YearlyStats _yearlyStats = YearlyStats.empty();
  Map<int, MonthlySummary> _monthlySummaries = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final db = ref.read(attendanceDatabaseProvider);

    final startOfYear = DateTime(_selectedYear, 1, 1);
    final endOfYear = DateTime(_selectedYear, 12, 31);

    // جلب جميع الجلسات للسنة
    final sessions = await (db.select(db.attSessions)
          ..where((s) => s.date.isBetweenValues(startOfYear, endOfYear)))
        .get();

    // حساب الإحصائيات لكل شهر
    var monthlyMap = <int, MonthlySummary>{};
    var totalPresent = 0;
    var totalAbsent = 0;
    var totalLate = 0;
    var totalExcused = 0;
    var totalSessions = sessions.length;

    for (var AttSession in sessions) {
      final attRecordsList = await (db.select(db.attRecords)
            ..where((a) => a.sessionId.equals(AttSession.id)))
          .get();

      final month = AttSession.date.month;

      for (var record in attRecordsList) {
        switch (record.status) {
          case 'present':
            totalPresent++;
            monthlyMap[month] = (monthlyMap[month] ?? MonthlySummary.empty())
                .copyWith(present: monthlyMap[month]!.present + 1);
            break;
          case 'absent':
            totalAbsent++;
            monthlyMap[month] = (monthlyMap[month] ?? MonthlySummary.empty())
                .copyWith(absent: monthlyMap[month]!.absent + 1);
            break;
          case 'late':
            totalLate++;
            monthlyMap[month] = (monthlyMap[month] ?? MonthlySummary.empty())
                .copyWith(late: monthlyMap[month]!.late + 1);
            break;
          case 'excused':
            totalExcused++;
            break;
        }
      }
    }

    final students = await db.select(db.attStudents).get();
    final totalStudents = students.length;

    setState(() {
      _monthlySummaries = monthlyMap;
      _yearlyStats = YearlyStats(
        year: _selectedYear,
        totalStudents: totalStudents,
        totalPresent: totalPresent,
        totalAbsent: totalAbsent,
        totalLate: totalLate,
        totalExcused: totalExcused,
        totalSessions: totalSessions,
      );
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PremiumAppBar(
        title: Text(context.l10n.yearlyReportLabel, maxLines: 1, overflow: TextOverflow.ellipsis),
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
                  // اختيار السنة
                  _buildYearSelector(),
                  const SizedBox(height: 20),

                  // ملخص السنة
                  _buildYearSummary(),
                  const SizedBox(height: 24),

                  // الرسم البياني السنوي
                  _buildYearChart(),
                  const SizedBox(height: 24),

                  //、月별 통계
                  SectionHeader(title: context.l10n.monthlyStats),
                  const SizedBox(height: 12),
                  _buildMonthlyStats(),

                  const SizedBox(height: 24),

                  // أهم الأحداث
                  _buildHighlights(),

                  const SizedBox(height: 80),
                ],
              ),
            ),
    );
  }

  Widget _buildYearSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () => setState(() => _selectedYear--),
            icon: const Icon(Icons.chevron_right),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
              Icon(Icons.calendar_today, color: Theme.of(context).colorScheme.secondary),
                const SizedBox(width: 8),
                Text(
                  '$_selectedYear',
                  style: AppTextStyles.headline5.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          IconButton(
            onPressed: () => setState(() => _selectedYear++),
            icon: const Icon(Icons.chevron_left),
          ),
        ],
      ),
    );
  }

  Widget _buildYearSummary() {
    final total = _yearlyStats.totalPresent +
        _yearlyStats.totalAbsent +
        _yearlyStats.totalLate;
    final attendanceRate = total > 0
        ? ((_yearlyStats.totalPresent / total) * 100).toStringAsFixed(1)
        : '0';

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Theme.of(context).colorScheme.secondary, Theme.of(context).colorScheme.secondary.withOpacity(0.7)],
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.analytics, color: Colors.white, size: 32),
              const SizedBox(width: 12),
              Text(
                context.l10n.yearReport,
                style: AppTextStyles.headline6.copyWith(color: Colors.white),
              maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  '$attendanceRate%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                  ),
                maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(
                  context.l10n.overallAttendance,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _YearStatItem(
                icon: Icons.people,
                label: context.l10n.savedSuccessfully,
                value: _yearlyStats.totalStudents.toString(),
              ),
              _YearStatItem(
                icon: Icons.event_note,
                label: context.l10n.totalSessions,
                value: _yearlyStats.totalSessions.toString(),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn().scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildYearChart() {
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
          Text(context.l10n.monthlyAttendanceRate, style: AppTextStyles.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: _buildYearBarChart(),
          ),
        ],
      ),
    );
  }

  Widget _buildYearBarChart() {
    final months = [
      context.l10n.january, context.l10n.february, context.l10n.march, context.l10n.april, context.l10n.may, context.l10n.june,
      context.l10n.july, context.l10n.august, context.l10n.september, context.l10n.october, context.l10n.november, context.l10n.december
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(12, (index) {
        final month = index + 1;
        final summary = _monthlySummaries[month];
        final total = summary != null
            ? summary.present + summary.absent + summary.late
            : 0;
        final rate = total > 0 && summary != null
            ? (summary.present / total) * 100
            : 0.0;

        return Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 120,
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: 20,
                  height: rate > 0 ? (rate / 100) * 120 : 4,
                  decoration: BoxDecoration(
                    color: rate >= 80
                        ? AppColors.success
                        : rate >= 60
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).colorScheme.error,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                months[index].substring(0, 3),
                style: const TextStyle(fontSize: 10),
              maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildMonthlyStats() {
    final months = [
      context.l10n.january, context.l10n.february, context.l10n.march, context.l10n.april, context.l10n.may, context.l10n.june,
      context.l10n.july, context.l10n.august, context.l10n.september, context.l10n.october, context.l10n.november, context.l10n.december
    ];

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(context.l10n.month, style: AppTextStyles.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
                ),
                Expanded(
                  child: Center(child: Text(context.l10n.present, style: AppTextStyles.caption.copyWith(color: AppColors.success), maxLines: 1, overflow: TextOverflow.ellipsis)),
                ),
                Expanded(
                  child: Center(child: Text(context.l10n.absent, style: AppTextStyles.caption.copyWith(color: Theme.of(context).colorScheme.error), maxLines: 1, overflow: TextOverflow.ellipsis)),
                ),
                Expanded(
                  child: Center(child: Text(context.l10n.percentage, style: AppTextStyles.caption.copyWith(color: AppColors.primary), maxLines: 1, overflow: TextOverflow.ellipsis)),
                ),
              ],
            ),
            const Divider(),
            ...List.generate(12, (index) {
              final month = index + 1;
              final summary = _monthlySummaries[month];
              final total = summary != null
                  ? summary.present + summary.absent + summary.late
                  : 0;
              final rate = total > 0 && summary != null
                  ? ((summary.present / total) * 100).toStringAsFixed(0)
                  : '-';

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(months[index], maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          summary?.present.toString() ?? '-',
                          style: const TextStyle(color: AppColors.success),
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          summary?.absent.toString() ?? '-',
                          style: TextStyle(color: Theme.of(context).colorScheme.error),
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: rate != '-'
                                ? (double.parse(rate) >= 80
                                    ? AppColors.success.withOpacity(0.1)
                                    : Theme.of(context).colorScheme.error.withOpacity(0.1))
                                : AppColors.textHint.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '$rate%',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: rate != '-'
                                  ? (double.parse(rate) >= 80
                                      ? AppColors.success
                                      : Theme.of(context).colorScheme.error)
                                  : AppColors.textHint,
                            ),
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildHighlights() {
    final total = _yearlyStats.totalPresent + _yearlyStats.totalAbsent;
    final bestMonth = _findBestMonth();
    final worstMonth = _findWorstMonth();

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.yearSummary, style: AppTextStyles.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 16),
          _HighlightItem(
            icon: Icons.trending_up,
            title: context.l10n.bestMonthAttendance,
            value: bestMonth,
            color: AppColors.success,
          ),
          const SizedBox(height: 12),
          _HighlightItem(
            icon: Icons.trending_down,
            title: context.l10n.worstMonthAttendance,
            value: worstMonth,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 12),
          _HighlightItem(
            icon: Icons.calendar_month,
            title: context.l10n.selectClassroom,
            value: _monthlySummaries.length.toString(),
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }

  String _findBestMonth() {
    final months = [
      context.l10n.january, context.l10n.february, context.l10n.march, context.l10n.april, context.l10n.may, context.l10n.june,
      context.l10n.july, context.l10n.august, context.l10n.september, context.l10n.october, context.l10n.november, context.l10n.december
    ];

    var bestRate = 0;
    var bestMonth = 1;

    for (var entry in _monthlySummaries.entries) {
      final total = entry.value.present + entry.value.absent;
      if (total > 0) {
        final rate = entry.value.present / total;
        if (rate > bestRate) {
          bestRate = rate.toInt();
          bestMonth = entry.key;
        }
      }
    }

    return months[bestMonth - 1];
  }

  String _findWorstMonth() {
    final months = [
      context.l10n.january, context.l10n.february, context.l10n.march, context.l10n.april, context.l10n.may, context.l10n.june,
      context.l10n.july, context.l10n.august, context.l10n.september, context.l10n.october, context.l10n.november, context.l10n.december
    ];

    var worstRate = 1;
    var worstMonth = 1;

    for (var entry in _monthlySummaries.entries) {
      final total = entry.value.present + entry.value.absent;
      if (total > 0) {
        final rate = entry.value.present / total;
        if (rate < worstRate) {
          worstRate = rate.toInt();
          worstMonth = entry.key;
        }
      }
    }

    return months[worstMonth - 1];
  }

  void _exportReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.scheduleGenerationSuccess, maxLines: 1, overflow: TextOverflow.ellipsis)),
    );
  }
}

class YearlyStats {
  final int year;
  final int totalStudents;
  final int totalPresent;
  final int totalAbsent;
  final int totalLate;
  final int totalExcused;
  final int totalSessions;

  YearlyStats({
    required this.year,
    required this.totalStudents,
    required this.totalPresent,
    required this.totalAbsent,
    required this.totalLate,
    required this.totalExcused,
    required this.totalSessions,
  });

  factory YearlyStats.empty() => YearlyStats(
        year: DateTime.now().year,
        totalStudents: 0,
        totalPresent: 0,
        totalAbsent: 0,
        totalLate: 0,
        totalExcused: 0,
        totalSessions: 0,
      );
}

class MonthlySummary {
  final int present;
  final int absent;
  final int late;

  MonthlySummary({required this.present, required this.absent, required this.late});

  factory MonthlySummary.empty() => MonthlySummary(present: 0, absent: 0, late: 0);

  MonthlySummary copyWith({int? present, int? absent, int? late}) {
    return MonthlySummary(
      present: present ?? this.present,
      absent: absent ?? this.absent,
      late: late ?? this.late,
    );
  }
}

class _YearStatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _YearStatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        maxLines: 1, overflow: TextOverflow.ellipsis),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          ),
        maxLines: 1, overflow: TextOverflow.ellipsis),
      ],
    );
  }
}

class _HighlightItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? label;
  final String value;
  final Color color;

  const _HighlightItem({
    required this.icon,
    required this.title,
    this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
              Text(
                value,
                style: AppTextStyles.titleMedium.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
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



