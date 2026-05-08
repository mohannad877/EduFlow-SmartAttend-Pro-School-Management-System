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

import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:school_schedule_app/core/services/attendance_pdf_service.dart';

/// شاشة تقرير طالب محدد
class StudentReportScreen extends ConsumerStatefulWidget {
  final AttStudent? student;
  const StudentReportScreen({super.key, this.student});

  @override
  ConsumerState<StudentReportScreen> createState() => _StudentReportScreenState();
}

class _StudentReportScreenState extends ConsumerState<StudentReportScreen> {
  AttStudent? _selectedStudent;
  List<AttRecord> _attendanceRecords = [];
  StudentStats _stats = StudentStats.empty();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.student != null) {
      _selectedStudent = widget.student;
      // We will load the data post-build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadStudentData(widget.student!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PremiumAppBar(
        title: Text(context.l10n.barcode, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          if (_selectedStudent != null)
            IconButton(
              icon: const Icon(Icons.picture_as_pdf),
              tooltip: context.l10n.classroomsView,
              onPressed: _exportToPdf,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // اختيار الطالب
            _buildStudentSelector(),
            const SizedBox(height: 20),

            if (_selectedStudent != null) ...[
              // معلومات الطالب
              _buildStudentCard(),
              const SizedBox(height: 20),

              // إحصائيات الطالب
              _buildStudentStats(),
              const SizedBox(height: 24),

              // الرسم البياني للتوجهات
              _buildAttendanceTrend(),
              const SizedBox(height: 24),

              // سجل الحضور
              SectionHeader(title: context.l10n.studentStats),
              const SizedBox(height: 12),
              _buildAttendanceHistory(),

              const SizedBox(height: 80),
            ] else
              _buildEmptyState(),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentSelector() {
    return InkWell(
      onTap: _showSearchableStudentPicker,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.person_search, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _selectedStudent?.name ?? context.l10n.selectStudent,
                style: TextStyle(
                  color: _selectedStudent == null ? Colors.grey : AppColors.textPrimary,
                  fontSize: 15,
                ),
              maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
            const Icon(Icons.arrow_drop_down, color: AppColors.primary),
          ],
        ),
      ),
    );
  }

  void _showSearchableStudentPicker() async {
    final students = await _getAllStudents();
    if (!mounted) return;
    final result = await showSearch<AttStudent?>(
      context: context,
      delegate: StudentSearchDelegate(
        students: students,
        label: context.l10n.searchStudent,
      ),
    );
    if (result != null) {
      setState(() => _selectedStudent = result);
      _loadStudentData(result);
    }
  }

  Widget _buildAttendanceTrend() {
    if (_attendanceRecords.isEmpty) return const SizedBox.shrink();

    // Group records by month for a simple trend
    final grouped = <String, List<AttRecord>>{};
    for (var r in _attendanceRecords) {
      final key = DateFormat('MM').format(r.recordedAt);
      grouped.putIfAbsent(key, () => []).add(r);
    }

    final spots = <FlSpot>[];
    final keys = grouped.keys.toList()..sort();
    for (var i = 0; i < keys.length; i++) {
      final monthRecords = grouped[keys[i]]!;
      final present = monthRecords.where((r) => r.status == 'present').length;
      final rate = (present / monthRecords.length) * 100;
      spots.add(FlSpot(i.toDouble(), rate));
    }

    return Container(
      height: 200,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.attendanceDetails, style: AppTextStyles.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 20),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: AppColors.primary,
                    barWidth: 4,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.primary.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _exportToPdf() async {
    if (_selectedStudent == null) return;

    final db = ref.read(attendanceDatabaseProvider);
    final settings = await db.select(db.attSettings).get();
    if (!mounted) return;
    final schoolName = settings.where((s) => s.key == 'school_name').firstOrNull?.value ?? context.l10n.schoolName;

    final path = await AttendancePdfService.generateStudentReport(
      db: db,
      student: _selectedStudent!,
      records: _attendanceRecords,
      schoolName: schoolName,
    );

    if (path != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.exportSuccessPath, maxLines: 1, overflow: TextOverflow.ellipsis)),
      );
    }
  }

  Widget _buildStudentCard() {
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
          CircleAvatar(
            radius: 35,
            backgroundColor: Colors.white.withOpacity(0.2),
            child: Text(
              _selectedStudent!.name.substring(0, 1),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _selectedStudent!.name,
                  style: AppTextStyles.headline5.copyWith(color: Colors.white),
                maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _InfoChip(
                      icon: Icons.school,
                      label: '${_selectedStudent!.stage} - ${_selectedStudent!.grade}',
                    ),
                    const SizedBox(width: 8),
                    _InfoChip(
                      icon: Icons.qr_code,
                      label: _selectedStudent!.barcode,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: -0.1, end: 0);
  }

  Widget _buildStudentStats() {
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
          Text(context.l10n.studentStatistics, style: AppTextStyles.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.check_circle,
                  label: context.l10n.session,
                  value: _stats.presentCount.toString(),
                  color: AppColors.success,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  icon: Icons.cancel,
                  label: context.l10n.absence,
                  value: _stats.absentCount.toString(),
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  icon: Icons.schedule,
                  label: context.l10n.delay,
                  value: _stats.lateCount.toString(),
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // نسبة الحضور
          _buildAttendanceRate(),
        ],
      ),
    );
  }

  Widget _buildAttendanceRate() {
    final total = _stats.presentCount + _stats.absentCount;
    final rate = total > 0 ? ((_stats.presentCount / total) * 100) : 0.0;
    final rateStr = rate.toStringAsFixed(1);

    Color rateColor;
    String statusText;
    IconData statusIcon;

    if (rate >= 90) {
      rateColor = AppColors.success;
      statusText = context.l10n.excellent;
      statusIcon = Icons.emoji_events;
    } else if (rate >= 75) {
      rateColor = AppColors.primary;
      statusText = context.l10n.studentCount;
      statusIcon = Icons.thumb_up;
    } else if (rate >= 60) {
      rateColor = Theme.of(context).colorScheme.secondary;
      statusText = context.l10n.noClassroomsFound;
      statusIcon = Icons.thumbs_up_down;
    } else {
      rateColor = Theme.of(context).colorScheme.error;
      statusText = context.l10n.needsImprovement;
      statusIcon = Icons.warning;
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: rateColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: rateColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(statusIcon, color: rateColor, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.attendanceRate,
                  style: AppTextStyles.caption,
                maxLines: 1, overflow: TextOverflow.ellipsis),
                Row(
                  children: [
                    Text(
                      '$rateStr%',
                      style: AppTextStyles.headline6.copyWith(
                        color: rateColor,
                        fontWeight: FontWeight.bold,
                      ),
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: rateColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        statusText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceHistory() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_attendanceRecords.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            children: [
              const Icon(Icons.history, size: 48, color: Colors.grey),
              const SizedBox(height: 12),
              Text(context.l10n.noRecord, style: const TextStyle(color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      );
    }

    return Column(
      children: _attendanceRecords.take(20).map((record) {
        return _AttendanceHistoryItem(
          record: record,
          onTap: () => _showRecordDetails(record),
        );
      }).toList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.person_search, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            context.l10n.selectStudentReport,
            style: AppTextStyles.titleMedium.copyWith(color: Colors.grey),
          maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Future<List<AttStudent>> _getAllStudents() async {
    final db = ref.read(attendanceDatabaseProvider);
    return await (db.select(db.attStudents)
          ..orderBy([(s) => OrderingTerm.asc(s.name)]))
        .get();
  }

  Future<void> _loadStudentData(AttStudent AttStudent) async {
    setState(() => _isLoading = true);

    final db = ref.read(attendanceDatabaseProvider);

    // جلب جميع سجلات الحضور للطالب
    final records = await (db.select(db.attRecords)
          ..where((a) => a.studentId.equals(AttStudent.id))
          ..orderBy([(a) => OrderingTerm.desc(a.recordedAt)]))
        .get();

    // حساب الإحصائيات
    var presentCount = 0;
    var absentCount = 0;
    var lateCount = 0;

    for (var record in records) {
      switch (record.status) {
        case 'present':
          presentCount++;
          break;
        case 'absent':
          absentCount++;
          break;
        case 'late':
          lateCount++;
          break;
      }
    }

    setState(() {
      _attendanceRecords = records;
      _stats = StudentStats(
        presentCount: presentCount,
        absentCount: absentCount,
        lateCount: lateCount,
      );
      _isLoading = false;
    });
  }

  void _showRecordDetails(AttRecord record) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.recordDetails, style: AppTextStyles.headline5, maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.schedule),
              title: Text(context.l10n.dateTime, maxLines: 1, overflow: TextOverflow.ellipsis),
              subtitle: Text(_formatDateTime(record.recordedAt), maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
            ListTile(
              leading: Icon(
                _getStatusIcon(record.status),
                color: _getStatusColor(record.status),
              ),
              title: Text(context.l10n.sort, maxLines: 1, overflow: TextOverflow.ellipsis),
              subtitle: Text(_getStatusText(record.status), maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
            if (record.notes != null)
              ListTile(
                leading: const Icon(Icons.note),
                title: Text(context.l10n.select, maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Text(record.notes!, maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final months = [
      context.l10n.january, context.l10n.february, context.l10n.march, context.l10n.april, context.l10n.may, context.l10n.june,
      context.l10n.july, context.l10n.august, context.l10n.september, context.l10n.october, context.l10n.november, context.l10n.december
    ];
    return '${dateTime.day} ${months[dateTime.month - 1]} ${dateTime.year} - ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'present':
        return Icons.check_circle;
      case 'absent':
        return Icons.cancel;
      case 'late':
        return Icons.schedule;
      default:
        return Icons.help;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'present':
        return AppColors.success;
      case 'absent':
        return Theme.of(context).colorScheme.error;
      case 'late':
        return Theme.of(context).colorScheme.secondary;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'present':
        return context.l10n.present;
      case 'absent':
        return context.l10n.absent;
      case 'late':
        return context.l10n.late;
      default:
        return status;
    }
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.white70),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.headline6.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          maxLines: 1, overflow: TextOverflow.ellipsis),
          Text(label, style: AppTextStyles.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

class _AttendanceHistoryItem extends StatelessWidget {
  final AttRecord record;
  final VoidCallback onTap;

  const _AttendanceHistoryItem({
    required this.record,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (record.status) {
      case 'present':
        statusColor = AppColors.success;
        statusIcon = Icons.check_circle;
        statusText = context.l10n.present;
        break;
      case 'absent':
        statusColor = Theme.of(context).colorScheme.error;
        statusIcon = Icons.cancel;
        statusText = context.l10n.absent;
        break;
      case 'late':
        statusColor = Theme.of(context).colorScheme.secondary;
        statusIcon = Icons.schedule;
        statusText = context.l10n.late;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
        statusText = record.status;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: statusColor.withOpacity(0.1),
          child: Icon(statusIcon, color: statusColor),
        ),
        title: Text(statusText, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(_formatDate(context, record.recordedAt), maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: IconButton(
          icon: const Icon(Icons.info_outline),
          onPressed: onTap,
        ),
        onTap: onTap,
      ),
    );
  }

  String _formatDate(BuildContext context, DateTime dateTime) {
    final months = [
      context.l10n.january, context.l10n.february, context.l10n.march, context.l10n.april, context.l10n.may, context.l10n.june,
      context.l10n.july, context.l10n.august, context.l10n.september, context.l10n.october, context.l10n.november, context.l10n.december
    ];
    return '${dateTime.day} ${months[dateTime.month - 1]} ${dateTime.year}';
  }
}

class StudentStats {
  final int presentCount;
  final int absentCount;
  final int lateCount;

  StudentStats({
    required this.presentCount,
    required this.absentCount,
    required this.lateCount,
  });

  factory StudentStats.empty() => StudentStats(
        presentCount: 0,
        absentCount: 0,
        lateCount: 0,
      );
}

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: AppTextStyles.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis);
  }
}

// ── Search Delegate ──────────────────────────────────────────────────────────

class StudentSearchDelegate extends SearchDelegate<AttStudent?> {
  final List<AttStudent> students;
  final String? label;

  StudentSearchDelegate({required this.students, this.label});

  @override
  String? get searchFieldLabel => label;

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, null),
      );

  @override
  Widget buildResults(BuildContext context) => _buildList();

  @override
  Widget buildSuggestions(BuildContext context) => _buildList();

  Widget _buildList() {
    final results = query.isEmpty
        ? students
        : students
            .where((s) => s.name.contains(query) || s.barcode.contains(query))
            .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final s = results[index];
        return ListTile(
          leading: const Icon(Icons.person),
          title: Text(s.name, maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Text('${s.grade} - ${s.section}', maxLines: 1, overflow: TextOverflow.ellipsis),
          onTap: () => close(context, s),
        );
      },
    );
  }

}




