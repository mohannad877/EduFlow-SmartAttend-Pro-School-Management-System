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
import 'package:school_schedule_app/core/services/attendance_pdf_service.dart';
import 'package:school_schedule_app/core/services/attendance_excel_service.dart';

/// شاشة التقرير اليومي
class DailyReportScreen extends ConsumerStatefulWidget {
  const DailyReportScreen({super.key});

  @override
  ConsumerState<DailyReportScreen> createState() => _DailyReportScreenState();
}

class _DailyReportScreenState extends ConsumerState<DailyReportScreen> {
  DateTime _selectedDate = DateTime.now();
  List<AttSession> _sessions = [];
  Map<int, List<AttRecord>> _attendanceBySession = {};
  bool _isLoading = true;
  bool _isExporting = false;
  // Cached lookup maps
  Map<int, String> _gradeLookup = {};
  Map<int, String> _subjectLookup = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final db = ref.read(attendanceDatabaseProvider);

    final startOfDay = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final sessions = await (db.select(db.attSessions)
          ..where((s) => s.date.isBetweenValues(startOfDay, endOfDay))
          ..orderBy([(s) => OrderingTerm.asc(s.periodNumber)]))
        .get();

    // Build lookup maps
    final grades = await db.select(db.attGrades).get();
    final subjects = await db.select(db.attSubjects).get();
    _gradeLookup = {for (var g in grades) g.id: g.name};
    _subjectLookup = {for (var s in subjects) s.id: s.name};

    var attendanceMap = <int, List<AttRecord>>{};

    for (var session in sessions) {
      final recordsList = await (db.select(db.attRecords)
            ..where((a) => a.sessionId.equals(session.id)))
          .get();
      attendanceMap[session.id] = recordsList;
    }

    setState(() {
      _sessions = sessions;
      _attendanceBySession = attendanceMap;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PremiumAppBar(
        title: Text(context.l10n.dailyReportLabel, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          if (_isExporting)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))),
            )
          else
            PopupMenuButton<String>(
              icon: const Icon(Icons.download_rounded),
              tooltip: context.l10n.exportLabel,
              onSelected: _handleExport,
              itemBuilder: (_) => [
                PopupMenuItem(value: 'pdf', child: Row(children: [Icon(Icons.picture_as_pdf, color: Theme.of(context).colorScheme.error), SizedBox(width: 8), Text(context.l10n.classroomsView, maxLines: 1, overflow: TextOverflow.ellipsis)])),
                PopupMenuItem(value: 'excel', child: Row(children: [Icon(Icons.table_chart, color: Colors.green), SizedBox(width: 8), Text(context.l10n.teachersView, maxLines: 1, overflow: TextOverflow.ellipsis)])),
              ],
            ),
        ],
      ),
      body: Column(
        children: [
          // اختيار التاريخ
          _buildDateSelector(),

          // إحصائيات اليوم
          _buildDayStats(),

          // قائمة الحصص
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _sessions.isEmpty
                    ? _buildEmptyState()
                    : _buildSessionsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      color: Theme.of(context).cardColor,
      child: Row(
        children: [
          IconButton(
            onPressed: () => _changeDate(-1),
            icon: const Icon(Icons.chevron_right),
          ),
          Expanded(
            child: InkWell(
              onTap: _selectDate,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.calendar_today, color: AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      _formatDate(_selectedDate),
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
            onPressed: () => _changeDate(1),
            icon: const Icon(Icons.chevron_left),
          ),
        ],
      ),
    );
  }

  Widget _buildDayStats() {
    var totalPresent = 0;
    var totalAbsent = 0;
    var totalLate = 0;

    for (var records in _attendanceBySession.values) {
      for (var record in records) {
        switch (record.status) {
          case 'present':
            totalPresent++;
            break;
          case 'absent':
            totalAbsent++;
            break;
          case 'late':
            totalLate++;
            break;
        }
      }
    }

    final total = totalPresent + totalAbsent + totalLate;
    final rate = total > 0 ? ((totalPresent / total) * 100).toStringAsFixed(1) : '0';

    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.7)],
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            context.l10n.selectTeacher,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _DayStatItem(
                label: context.l10n.pleaseSelectTeacher,
                value: totalPresent,
                color: AppColors.success,
                icon: Icons.check_circle,
              ),
              _DayStatItem(
                label: context.l10n.dismiss,
                value: totalAbsent,
                color: Theme.of(context).colorScheme.error,
                icon: Icons.cancel,
              ),
              _DayStatItem(
                label: context.l10n.clearScheduleConfirm,
                value: totalLate,
                color: Theme.of(context).colorScheme.secondary,
                icon: Icons.schedule,
              ),
              _DayStatItem(
                label: context.l10n.attendanceRate,
                value: double.parse(rate),
                suffix: '%',
                color: Colors.white,
                icon: Icons.trending_up,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.event_busy, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            context.l10n.cancel,
            style: AppTextStyles.titleMedium.copyWith(color: Colors.grey),
          maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 8),
          Text(
            _formatDate(_selectedDate),
            style: AppTextStyles.caption.copyWith(color: Colors.grey),
          maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _buildSessionsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: _sessions.length,
      itemBuilder: (context, index) {
        final session = _sessions[index];
        final recordsList = _attendanceBySession[session.id] ?? [];

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ExpansionTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: Text(
                '${session.periodNumber}',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
            title: Text(
              context.l10n.clear,
              style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
            maxLines: 1, overflow: TextOverflow.ellipsis),
            subtitle: Text(
              '${_getSubjectName(session.subjectId)} - ${_getGradeName(session.gradeId)}',
              style: AppTextStyles.caption,
            maxLines: 1, overflow: TextOverflow.ellipsis),
            children: [
              if (recordsList.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Text(context.l10n.balancedMode, maxLines: 1, overflow: TextOverflow.ellipsis),
                )
              else
                ...recordsList.map((record) => _buildAttendanceItem(record)),
            ],
          ),
        ).animate().fadeIn(delay: (index * 100).ms);
      },
    );
  }

  Widget _buildAttendanceItem(AttRecord record) {
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

    return FutureBuilder<AttStudent?>(
      future: _getStudent(record.studentId),
      builder: (context, snapshot) {
        final student = snapshot.data;
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: statusColor.withOpacity(0.1),
            radius: 18,
            child: Icon(statusIcon, color: statusColor, size: 18),
          ),
          title: Text(student?.name ?? context.l10n.balancedModeDesc, maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: student != null ? Text(student.barcode ?? '', maxLines: 1, overflow: TextOverflow.ellipsis) : null,
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              statusText,
              style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
            maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        );
      },
    );
  }

  Future<AttStudent?> _getStudent(int studentId) async {
    final db = ref.read(attendanceDatabaseProvider);
    final result = await (db.select(db.attStudents)
          ..where((s) => s.id.equals(studentId)))
        .getSingleOrNull();
    return result;
  }

  String _getSubjectName(int subjectId) => _subjectLookup[subjectId] ?? context.l10n.compactMode;

  String _getGradeName(int gradeId) => _gradeLookup[gradeId] ?? context.l10n.compactModeDesc;

  void _changeDate(int days) {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: days));
    });
    _loadData();
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      locale: const Locale('ar', 'SA'),
    );
    if (date != null) {
      setState(() => _selectedDate = date);
      _loadData();
    }
  }

  String _formatDate(DateTime date) {
    final weekdays = [context.l10n.monday, context.l10n.tuesday, context.l10n.wednesday, context.l10n.thursday, context.l10n.friday, context.l10n.saturday, context.l10n.sunday];
    final months = [
      context.l10n.january, context.l10n.february, context.l10n.march, context.l10n.april, context.l10n.may, context.l10n.june,
      context.l10n.july, context.l10n.august, context.l10n.september, context.l10n.october, context.l10n.november, context.l10n.december
    ];
    return '${weekdays[date.weekday - 1]} ${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Future<void> _handleExport(String format) async {
    setState(() => _isExporting = true);
    final db = ref.read(attendanceDatabaseProvider);
    String schoolName = 'نظام إدارة المدارس';
    
    try {
      final settings = await db.select(db.attSettings).get();
      final setting = settings.where((s) => s.key == 'school_name').firstOrNull;
      if (setting != null) {
        schoolName = setting.value;
      }

      String? path;
      if (format == 'pdf') {
        path = await AttendancePdfService.generateDailyReport(
          db: db,
          date: _selectedDate,
          schoolName: schoolName,
        );
      } else {
        path = await AttendanceExcelService.generateDailyReport(
          db: db,
          date: _selectedDate,
          schoolName: schoolName,
        );
      }

      if (!mounted) return;
      setState(() => _isExporting = false);
      if (path != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(context.l10n.priorityMode,
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              backgroundColor: AppColors.success),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(context.l10n.priorityModeDesc,
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              backgroundColor: Theme.of(context).colorScheme.error),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isExporting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('${context.l10n.priorityModeDesc}: $e',
                maxLines: 1, overflow: TextOverflow.ellipsis),
            backgroundColor: Theme.of(context).colorScheme.error),
      );
    }
  }
}

class _DayStatItem extends StatelessWidget {
  final String label;
  final dynamic value;
  final String? suffix;
  final Color color;
  final IconData icon;

  const _DayStatItem({
    required this.label,
    required this.value,
    this.suffix,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          '$value${suffix ?? ''}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        maxLines: 1, overflow: TextOverflow.ellipsis),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 11,
          ),
        maxLines: 1, overflow: TextOverflow.ellipsis),
      ],
    );
  }
}



