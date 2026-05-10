import 'package:school_schedule_app/core/utils/l10n_extension.dart';
import 'package:school_schedule_app/core/theme/app_spacing.dart';
import 'dart:io';
import 'package:school_schedule_app/core/widgets/premium_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:printing/printing.dart';
import 'package:school_schedule_app/core/theme/app_colors.dart';
import 'package:school_schedule_app/core/theme/app_text_styles.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:school_schedule_app/core/navigation/app_router.dart';
import 'package:school_schedule_app/core/database/attendance_providers.dart';
import 'package:school_schedule_app/core/services/attendance_pdf_service.dart';
import 'package:school_schedule_app/core/services/attendance_excel_service.dart';
import 'package:school_schedule_app/core/services/csv_export_service.dart';
import 'package:school_schedule_app/core/services/html_report_service.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:open_file/open_file.dart';
import 'report_preview_screen.dart';
import 'student_report_screen.dart' show StudentSearchDelegate;
import 'package:school_schedule_app/core/services/comparative_report_service.dart';

// ============================================================================
// نموذج بيانات فلتر التقرير
// ============================================================================

/// نموذج فلتر التقرير المتقدم
class ReportFilter {
  final DateTimeRange? dateRange;
  final String? classId;
  final String? subjectId;
  final String? teacherId;

  const ReportFilter({
    this.dateRange,
    this.classId,
    this.subjectId,
    this.teacherId,
  });
}

/// دالة مساعدة لعرض حوار الفلترة المتقدم
Future<ReportFilter?> showReportFilterDialog(BuildContext context) {
  return showDialog<ReportFilter>(
    context: context,
    builder: (ctx) => ReportFilterDialog(),
  );
}

// ============================================================================
// الشاشة الرئيسية – ReportsHomeScreen (مطورة بالكامل)
// ============================================================================

class ReportsHomeScreen extends ConsumerStatefulWidget {
  const ReportsHomeScreen({super.key});

  @override
  ConsumerState<ReportsHomeScreen> createState() => _ReportsHomeScreenState();
}

class _ReportsHomeScreenState extends ConsumerState<ReportsHomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // ضمان اتجاه RTL للغة العربية
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: _buildAppBar(),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).scaffoldBackgroundColor,
                Theme.of(context).scaffoldBackgroundColor.withOpacity(0.97),
              ],
            ),
          ),
          child: _buildBody(),
        ),
        floatingActionButton: _buildFloatingActionButton(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PremiumAppBar(
      title: Text(context.l10n.reportsSection, maxLines: 1, overflow: TextOverflow.ellipsis),
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.filter_alt_outlined),
          tooltip: context.l10n.advancedFilter,
          onPressed: () => _showAdvancedFilterDialog(),
        ),
        IconButton(
          icon: const Icon(Icons.print),
          tooltip: context.l10n.print,
          onPressed: () => _printCurrentReport(),
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) => _handleMenuAction(value),
          itemBuilder: (context) => [
            PopupMenuItem(value: 'export_pdf', child: Text(context.l10n.exportPdf, maxLines: 1, overflow: TextOverflow.ellipsis)),
            PopupMenuItem(value: 'export_excel', child: Text(context.l10n.exportExcel, maxLines: 1, overflow: TextOverflow.ellipsis)),
            PopupMenuItem(value: 'export_csv', child: Text(context.l10n.exportCsv, maxLines: 1, overflow: TextOverflow.ellipsis)),
            PopupMenuItem(value: 'export_html', child: Text(context.l10n.exportHtml, maxLines: 1, overflow: TextOverflow.ellipsis)),
            PopupMenuItem(value: 'share', child: Text(context.l10n.share, maxLines: 1, overflow: TextOverflow.ellipsis)),
          ],
        ),
      ],
    );
  }

  Widget _buildBody() {
    return RefreshIndicator(
      onRefresh: () async => setState(() {}),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // بطاقة الإحصائيات السريعة (مطورة)
            _buildAdvancedStatsCard(),

            const SizedBox(height: 28),

            // قسم إجراءات التصدير السريعة (توليد التقارير)
            _buildQuickGenerationActions(),

            const SizedBox(height: 28),

            // أنواع التقارير (مع أيقونات وألوان)
            SectionHeader(title: context.l10n.availableReportTypes),
            const SizedBox(height: 16),
            _buildReportTypesGrid(),

            const SizedBox(height: 32),

            // آخر التقارير المولدة (سجل سريع)
            SectionHeader(title: context.l10n.lastGeneratedReports, actionLabel: context.l10n.viewAll),
            const SizedBox(height: 16),
            _buildRecentReportsList(),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickGenerationActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: context.l10n.quickActions),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _QuickActionBtn(
                label: context.l10n.exportPdf,
                icon: Icons.picture_as_pdf_rounded,
                color: Theme.of(context).colorScheme.error,
                onTap: () => _handleMenuAction('export_pdf'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _QuickActionBtn(
                label: context.l10n.exportExcel,
                icon: Icons.table_chart_rounded,
                color: Colors.green.shade600,
                onTap: () => _handleMenuAction('export_excel'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAdvancedStatsCard() {
    return FutureBuilder<Map<String, dynamic>>(
      future: _loadAdvancedStats(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final stats = snapshot.data!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SectionHeader(title: context.l10n.statistics),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(context.l10n.todayAttendance, style: AppTextStyles.caption.copyWith(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Main Overview Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(color: Theme.of(context).primaryColor.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8)),
                ],
                gradient: LinearGradient(
                  colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColor.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(context.l10n.attendanceRate, style: AppTextStyles.subtitle2.copyWith(color: Colors.white70)),
                        const SizedBox(height: 4),
                        Text("${stats['attendanceRate']}%", style: AppTextStyles.headline1.copyWith(color: Colors.white, fontSize: 42)),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                          child: Text("${context.l10n.presentToday}: ${stats['presentToday']}", style: AppTextStyles.caption.copyWith(color: Colors.white, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 90, height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.15),
                    ),
                    child: const Icon(Icons.insert_chart_outlined_rounded, size: 48, color: Colors.white),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),
            
            const SizedBox(height: 16),
            
            // Secondary Stats Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _MiniStatCard(title: context.l10n.totalStudents, value: '${stats['totalStudents']}', icon: Icons.group_rounded, color: Colors.blue),
                _MiniStatCard(title: context.l10n.absentToday, value: '${stats['absentToday']}', icon: Icons.person_off_rounded, color: Theme.of(context).colorScheme.error),
                _MiniStatCard(title: context.l10n.absenceRate, value: '${stats['absenceRate']}%', icon: Icons.trending_down_rounded, color: Colors.orange.shade600),
                _MiniStatCard(title: context.l10n.bestAttendanceMonth, value: stats['bestMonth'] ?? '—', icon: Icons.calendar_month_rounded, color: Colors.deepPurple.shade400),
              ],
            ).animate().fadeIn(duration: 400.ms, delay: 100.ms).slideY(begin: 0.1, end: 0),
          ],
        );
      },
    );
  }

  Future<Map<String, dynamic>> _loadAdvancedStats() async {
    final bestMonthStr = context.l10n.march2025;
    final db = ref.read(attendanceDatabaseProvider);
    final students = await db.select(db.attStudents).get();
    final total = students.length;

    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final todaySessions = await (db.select(db.attSessions)
          ..where((s) => s.date.isBetweenValues(startOfDay, endOfDay)))
        .get();

    int present = 0, absent = 0;
    for (final session in todaySessions) {
      final records = await (db.select(db.attRecords)..where((r) => r.sessionId.equals(session.id))).get();
      for (final r in records) {
        if (r.status == 'present') present++;
        if (r.status == 'absent') absent++;
      }
    }

    final attendanceRate = total > 0 ? ((present / total) * 100).toStringAsFixed(1) : '0';
    final absenceRate = total > 0 ? ((absent / total) * 100).toStringAsFixed(1) : '0';

    // أفضل شهر (مثال بسيط)
    final bestMonth = bestMonthStr;

    return {
      'totalStudents': total,
      'presentToday': present,
      'absentToday': absent,
      'attendanceRate': attendanceRate,
      'absenceRate': absenceRate,
      'bestMonth': bestMonth,
    };
  }

  Widget _buildReportTypesGrid() {
    final reports = [
      (context.l10n.daily, context.l10n.dailyReportDesc, Icons.today_rounded, Theme.of(context).primaryColor),
      (context.l10n.monthly, context.l10n.monthlyReportDesc, Icons.calendar_month_rounded, Theme.of(context).colorScheme.secondary),
      (context.l10n.yearly, context.l10n.yearlyReportLabel, Icons.calendar_today_rounded, Colors.orange.shade600),
      (context.l10n.period, context.l10n.studentReportDesc, Icons.person_search_rounded, Colors.blue.shade600),
      (context.l10n.comparisonResults, context.l10n.compareSections, Icons.compare_arrows_rounded, Colors.deepPurple.shade500),
      (context.l10n.detailedSectionReport, context.l10n.detailedSectionReportDesc, Icons.class_rounded, Colors.teal.shade600),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.15,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: reports.length,
      itemBuilder: (context, index) {
        final item = reports[index];
        return ReportTypeCard(
          icon: item.$3,
          title: item.$1,
          description: item.$2,
          color: item.$4,
          onTap: () => _navigateToReport(item.$1),
        ).animate().fadeIn(duration: 400.ms, delay: (index * 80).ms).scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1));
      },
    );
  }

  void _navigateToReport(String type) {
    if (type == context.l10n.daily) {
      AppNavigator.push(AppRoutes.dailyReport);
    } else if (type == context.l10n.monthly) {
      AppNavigator.push(AppRoutes.monthlyReport);
    } else if (type == context.l10n.yearly) {
      AppNavigator.push(AppRoutes.yearlyReport);
    } else if (type == context.l10n.period) {
      _showStudentSelectionDialog();
    } else if (type == context.l10n.comparisonResults) {
      _showComparativeReportDialog();
    } else if (type == context.l10n.detailedSectionReport) {
      _showClassDetailedReport();
    }
  }

  List<FileSystemEntity> _recentReports = [];

  @override
  void initState() {
    super.initState();
    _loadRecentReports();
  }

  Future<void> _loadRecentReports() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final reportsDir = Directory(p.join(dir.path, 'reports'));
      if (await reportsDir.exists()) {
        final files = await reportsDir.list().where((e) => e is File).toList();
        files.sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));
        if (context.mounted) {
          setState(() {
            _recentReports = files.take(5).toList();
          });
        }
      }
    } catch (e) {
      debugPrint('Error loading recent reports: $e');
    }
  }

  Widget _buildRecentReportsList() {
    if (_recentReports.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: Theme.of(context).hintColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.history_rounded, size: 48, color: Theme.of(context).hintColor.withOpacity(0.7)),
              ),
              const SizedBox(height: 16),
              Text(context.l10n.noReports, style: AppTextStyles.body2.copyWith(color: Theme.of(context).hintColor), maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      );
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _recentReports.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final file = _recentReports[index];
        final fileName = p.basename(file.path);
        final isPdf = fileName.endsWith('.pdf');
        
        return Card(
          elevation: 2,
          shadowColor: Colors.black12,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          margin: EdgeInsets.zero,
          child: InkWell(
            onTap: () => _previewReport(file.path, fileName),
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isPdf 
                          ? [Theme.of(context).colorScheme.errorContainer, Theme.of(context).colorScheme.errorContainer.withOpacity(0.5)]
                          : [Theme.of(context).primaryColor.withOpacity(0.1), Theme.of(context).primaryColor.withOpacity(0.05)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      isPdf ? Icons.picture_as_pdf_rounded : Icons.table_chart_rounded,
                      color: isPdf ? Theme.of(context).colorScheme.error : Theme.of(context).primaryColor,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(fileName, style: AppTextStyles.body2.copyWith(fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Text(
                          isPdf ? 'PDF Document' : 'Spreadsheet',
                          style: AppTextStyles.caption.copyWith(color: Theme.of(context).hintColor),
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.share_rounded, color: Theme.of(context).primaryColor, size: 22),
                      onPressed: () => Share.shareXFiles([XFile(file.path)], text: context.l10n.reportFileName),
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ).animate().fadeIn(duration: 400.ms, delay: (index * 100).ms).slideX(begin: 0.05, end: 0);
      },
    );
  }

  void _previewReport(String filePath, String fileName) {
    if (fileName.endsWith('.pdf')) {
      AppNavigator.push(
        AppRoutes.reportPreview,
        arguments: ReportPreviewScreenArgs(title: fileName, filePath: filePath),
      );
    } else {
      // Excel or HTML files
      OpenFile.open(filePath);
    }
  }

  void _showAdvancedFilterDialog() {
    showDialog(
      context: context,
      builder: (ctx) => const ReportFilterDialog(),
    );
  }

  void _printCurrentReport() async {
    try {
      final db = ref.read(attendanceDatabaseProvider);
      final today = DateTime.now();
      await AttendancePdfService.generateDailyReport(
        db: db,
        date: today,
        schoolName: context.l10n.schoolName,
        openAfter: false,
      ).then((path) async {
        if (path != null) {
          await Printing.layoutPdf(
            onLayout: (_) async => await _pdfBytesFromPath(path),
          );
        }
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.invalidToken, maxLines: 1, overflow: TextOverflow.ellipsis)));
    }
  }

  Future<Uint8List> _pdfBytesFromPath(String path) async {
    try {
      return await File(path).readAsBytes();
    } catch (_) {
      return Uint8List(0);
    }
  }

  void _handleMenuAction(String value) async {
    switch (value) {
      case 'export_pdf':
        await _exportWithOptions('pdf');
        break;
      case 'export_excel':
        await _exportWithOptions('excel');
        break;
      case 'export_csv':
        await _exportCSV();
        break;
      case 'export_html':
        await _exportHTML();
        break;
      case 'share':
        await _shareReport();
        break;
    }
  }

  Future<void> _exportWithOptions(String format) async {
    final filter = await showReportFilterDialog(context);
    if (!mounted) return;
    // We can proceed even if filter is null (default 30 days)
    
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.exportingFormat, maxLines: 1, overflow: TextOverflow.ellipsis)));

    try {
      final db = ref.read(attendanceDatabaseProvider);
      final data = await _collectReportData(db, filter);

      if (format == 'pdf') {
        await AttendancePdfService.generateAdvancedReport(data, filter);
      } else if (format == 'excel') {
        await AttendanceExcelService.generateAdvancedReport(data, filter);
      }
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.exportCompleted, maxLines: 1, overflow: TextOverflow.ellipsis)));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.exportFailed, maxLines: 1, overflow: TextOverflow.ellipsis)));
    }
  }

  Future<void> _exportCSV() async {
    // خدمة CSV
    final db = ref.read(attendanceDatabaseProvider);
    final students = await db.select(db.attStudents).get();
    final csvData = await CsvExportService.generateAttendanceCSV(students);
    await Share.shareXFiles([XFile.fromData(csvData, mimeType: 'text/csv', name: 'attendance.csv')]);
  }

  Future<void> _exportHTML() async {
    try {
      final db = ref.read(attendanceDatabaseProvider);
      final students = await db.select(db.attStudents).get();
      final htmlContent = await HtmlReportService.generateAttendanceHTML(students);
      // Save to file & open with system browser (works on all platforms)
      final path = await HtmlReportService.saveAndOpen(htmlContent, 'students_report_${DateTime.now().millisecondsSinceEpoch}');
      if (path == null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.htmlExportError, maxLines: 1, overflow: TextOverflow.ellipsis)));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.resetPassword, maxLines: 1, overflow: TextOverflow.ellipsis)));
    }
  }

  Future<void> _shareReport() async {
    // مثال مشاركة نص بسيط
    await Share.share(context.l10n.dailyAttendanceRate, subject: context.l10n.schoolReport);
  }

  Future<Map<String, dynamic>> _collectReportData(AttendanceDatabase db, ReportFilter? filter) async {
    final students = await (db.select(db.attStudents)..where((s) => s.isActive.equals(true))).get();
    
    // إذا كان هناك فلتر للصف أو الشعبة يمكننا تصفية الطلاب هنا
    var filteredStudents = students;
    if (filter != null) {
      if (filter.classId != null && filter.classId!.isNotEmpty) {
        filteredStudents = filteredStudents.where((s) => '${s.grade} - ${s.section}' == filter.classId).toList();
      }
    }

    final dateRange = filter?.dateRange;
    var start = DateTime.now().subtract(const Duration(days: 30));
    var end = DateTime.now();
    if (dateRange != null) {
      start = dateRange.start;
      end = dateRange.end;
    } else {
      start = DateTime(start.year, start.month, start.day);
      end = DateTime(end.year, end.month, end.day, 23, 59, 59);
    }

    // جلب الجلسات في هذا النطاق الزمني
    final sessions = await (db.select(db.attSessions)
          ..where((s) => s.date.isBetweenValues(start, end)))
        .get();

    final sessionIds = sessions.map((s) => s.id).toList();
    List<AttRecord> attendanceRecords = [];
    if (sessionIds.isNotEmpty) {
      attendanceRecords = await (db.select(db.attRecords)
            ..where((r) => r.sessionId.isIn(sessionIds)))
          .get();
    }

    return {
      'students': filteredStudents,
      'attendance': attendanceRecords,
      'sessions': sessions,
    };
  }

  /// 👤 اختيار طالب محدد وفتح تقريره
  void _showStudentSelectionDialog() async {
    final db = ref.read(attendanceDatabaseProvider);
    final students = await (db.select(db.attStudents)
          ..where((s) => s.isActive.equals(true))
          ..orderBy([(s) => OrderingTerm.asc(s.name)]))
        .get();

    if (!mounted) return;

    final result = await showSearch<AttStudent?>(
      context: context,
      delegate: StudentSearchDelegate(
        students: students,
        label: context.l10n.searchStudent,
      ),
    );

    if (result != null && mounted) {
      // انتقل مباشرة لشاشة تقرير الطالب المحدد
      AppNavigator.push(AppRoutes.studentReport, arguments: result);
    }
  }

  void _showComparativeReportDialog() {
    var grade = context.l10n.firstGrade;
    var sectionA = context.l10n.sectionA;
    var sectionB = context.l10n.sectionB;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateBuilder) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            title: Text(context.l10n.compareReport, maxLines: 1, overflow: TextOverflow.ellipsis),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(context.l10n.selectSections, maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: grade,
                  decoration: InputDecoration(labelText: context.l10n.grade, border: OutlineInputBorder()),
                  items: [context.l10n.firstGrade, context.l10n.secondGrade, context.l10n.thirdGrade, context.l10n.fourthGrade, context.l10n.fifthGrade, context.l10n.sixthGrade]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e, maxLines: 1, overflow: TextOverflow.ellipsis)))
                      .toList(),
                  onChanged: (v) => setStateBuilder(() => grade = v!),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: sectionA,
                        decoration: InputDecoration(labelText: context.l10n.section1, border: OutlineInputBorder()),
                        onChanged: (v) => sectionA = v,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        initialValue: sectionB,
                        decoration: InputDecoration(labelText: context.l10n.section2, border: OutlineInputBorder()),
                        onChanged: (v) => sectionB = v,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: Text(context.l10n.dismiss, maxLines: 1, overflow: TextOverflow.ellipsis)),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  _showSnackbar(context.l10n.analyzingData);
                  final db = ref.read(attendanceDatabaseProvider);
                  final service = ComparativeReportService(db);
                  
                  final results = await service.compareSections(
                    grade: grade,
                    sectionA: sectionA,
                    sectionB: sectionB,
                  );
                  
                  if (context.mounted) {
                    showDialog(
                      context: context,
                      builder: (ctx) => _ComparativeResultDialog(results: results),
                    );
                  }
                },
                child: Text(context.l10n.startAnalysis, maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
            ],
          );
        }
      ),
    );
  }

  void _showClassDetailedReport() {
    var grade = context.l10n.firstGrade;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateBuilder) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            title: Text(context.l10n.sectionsReport, maxLines: 1, overflow: TextOverflow.ellipsis),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(context.l10n.selectGrade, maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: grade,
                  decoration: InputDecoration(labelText: context.l10n.grade, border: OutlineInputBorder()),
                  items: [context.l10n.firstGrade, context.l10n.secondGrade, context.l10n.thirdGrade, context.l10n.fourthGrade, context.l10n.fifthGrade, context.l10n.sixthGrade]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e, maxLines: 1, overflow: TextOverflow.ellipsis)))
                      .toList(),
                  onChanged: (v) => setStateBuilder(() => grade = v!),
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: Text(context.l10n.dismiss, maxLines: 1, overflow: TextOverflow.ellipsis)),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  _showSnackbar(context.l10n.extractingDetails);
                  final db = ref.read(attendanceDatabaseProvider);
                  final service = ComparativeReportService(db);
                  
                  final results = await service.getClassBreakdown(grade);
                  
                  if (context.mounted) {
                    showDialog(
                      context: context,
                      builder: (ctx) => _ClassDetailedResultDialog(grade: grade, results: results),
                    );
                  }
                },
                child: Text(context.l10n.showDetails, maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
            ],
          );
        }
      ),
    );
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message, maxLines: 1, overflow: TextOverflow.ellipsis)));
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () => _showAdvancedFilterDialog(),
      icon: const Icon(Icons.tune),
      label: Text(context.l10n.advancedFilter, maxLines: 1, overflow: TextOverflow.ellipsis),
      backgroundColor: AppColors.primary,
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    );
  }
}

// ============================================================================
// حوار الفلترة المتقدم (ReportFilterDialog) — مربوط بقاعدة البيانات
// ============================================================================

/// حوار فلترة متقدم يجلب بيانات المعلمين والطلاب والصفوف من قاعدة البيانات تلقائياً
class ReportFilterDialog extends ConsumerStatefulWidget {
  const ReportFilterDialog({super.key});

  @override
  ConsumerState<ReportFilterDialog> createState() => _ReportFilterDialogState();
}

class _ReportFilterDialogState extends ConsumerState<ReportFilterDialog> {
  DateTimeRange? _dateRange;
  String? _selectedClass;
  String? _selectedSubject;
  String? _selectedTeacher;

  // بيانات من قاعدة البيانات
  List<String> _grades = [];
  List<String> _subjects = [];
  List<String> _teachers = [];
  bool _isLoadingData = true;

  @override
  void initState() {
    super.initState();
    _loadDatabaseOptions();
  }

  Future<void> _loadDatabaseOptions() async {
    final db = ref.read(attendanceDatabaseProvider);

    // جلب الصفوف الفريدة من جدول الطلاب
    final students = await (db.select(db.attStudents)
          ..where((s) => s.isActive.equals(true)))
        .get();
    final grades = students.map((s) => '${s.grade} - ${s.section}').toSet().toList()..sort();

    // جلب المواد من جدول المواد
    var subjects = <String>[];
    try {
      final subjectRows = await db.select(db.attSubjects).get();
      subjects = subjectRows.map((s) => s.name).toSet().toList()..sort();
    } catch (_) {}

    // جلب أسماء المعلمين من السجلات
    var teachers = <String>[];
    try {
      final sessionTeachers = await db.customSelect(
        'SELECT DISTINCT teacher_name FROM att_sessions WHERE teacher_name IS NOT NULL ORDER BY teacher_name',
      ).get();
      teachers = sessionTeachers.map((r) => r.read<String>('teacher_name')).toList();
    } catch (_) {}

    if (mounted) {
      setState(() {
        _grades = grades;
        _subjects = subjects;
        _teachers = teachers;
        _isLoadingData = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      title: Row(
        children: [
          const Icon(Icons.tune, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(context.l10n.advancedOptions, maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
      content: _isLoadingData
          ? const SizedBox(
              height: 120,
              child: Center(child: CircularProgressIndicator()),
            )
          : SizedBox(
              width: 400,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // الفترة الزمنية
                    ListTile(
                      leading: const Icon(Icons.date_range, color: AppColors.primary),
                      title: Text(context.l10n.timePeriod, maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: Text(
                        _dateRange == null
                            ? context.l10n.selectDates
                            : '${_formatDate(_dateRange!.start)} → ${_formatDate(_dateRange!.end)}',
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                      trailing: _dateRange != null
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 16),
                              onPressed: () => setState(() => _dateRange = null),
                            )
                          : null,
                      onTap: () async {
                        final picked = await showDateRangePicker(
                          context: context,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                          helpText: context.l10n.selectPeriod,
                        );
                        if (picked != null) setState(() => _dateRange = picked);
                      },
                    ),
                    const Divider(),

                    // الصف / الشعبة — من قاعدة البيانات
                    DropdownButtonFormField<String>(
                      value: _selectedClass,
                      decoration: InputDecoration(
                        labelText: context.l10n.gradeSection,
                        prefixIcon: Icon(Icons.class_),
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      items: [
                        DropdownMenuItem(value: null, child: Text(context.l10n.all, maxLines: 1, overflow: TextOverflow.ellipsis)),
                        ..._grades.map((g) => DropdownMenuItem(value: g, child: Text(g, maxLines: 1, overflow: TextOverflow.ellipsis))),
                      ],
                      onChanged: (v) => setState(() => _selectedClass = v),
                    ),
                    const SizedBox(height: 12),

                    // المادة الدراسية — من قاعدة البيانات
                    DropdownButtonFormField<String>(
                      value: _selectedSubject,
                      decoration: InputDecoration(
                        labelText: context.l10n.subject,
                        prefixIcon: Icon(Icons.book),
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      items: [
                        DropdownMenuItem(value: null, child: Text(context.l10n.all, maxLines: 1, overflow: TextOverflow.ellipsis)),
                        ..._subjects.map((s) => DropdownMenuItem(value: s, child: Text(s, maxLines: 1, overflow: TextOverflow.ellipsis))),
                      ],
                      onChanged: (v) => setState(() => _selectedSubject = v),
                    ),
                    const SizedBox(height: 12),

                    // المعلم — من رسائل الجلسات
                    if (_teachers.isNotEmpty)
                      DropdownButtonFormField<String>(
                        value: _selectedTeacher,
                        decoration: InputDecoration(
                          labelText: context.l10n.teacherLabel,
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        items: [
                          DropdownMenuItem(value: null, child: Text(context.l10n.all, maxLines: 1, overflow: TextOverflow.ellipsis)),
                          ..._teachers.map((t) => DropdownMenuItem(value: t, child: Text(t, maxLines: 1, overflow: TextOverflow.ellipsis))),
                        ],
                        onChanged: (v) => setState(() => _selectedTeacher = v),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.person, color: Colors.grey.shade400),
                            const SizedBox(width: 8),
                            Text(context.l10n.noTeachersFound, style: TextStyle(color: Colors.grey.shade500), maxLines: 1, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
      actions: [
        TextButton(
          onPressed: () {
            setState(() {
              _dateRange = null;
              _selectedClass = null;
              _selectedSubject = null;
              _selectedTeacher = null;
            });
          },
          child: Text(context.l10n.reset, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
        TextButton(onPressed: () => Navigator.pop(context), child: Text(context.l10n.cancel, maxLines: 1, overflow: TextOverflow.ellipsis)),
        ElevatedButton(
          onPressed: () => Navigator.pop(
            context,
            ReportFilter(
              dateRange: _dateRange,
              classId: _selectedClass,
              subjectId: _selectedSubject,
              teacherId: _selectedTeacher,
            ),
          ),
          child: Text(context.l10n.apply, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }

  String _formatDate(DateTime d) => '${d.day}/${d.month}/${d.year}';
}

// ============================================================================
// مكونات مساعدة محسنة (StatItem, ReportTypeCard, SectionHeader)
// ============================================================================

class _MiniStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _MiniStatCard({required this.title, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: color.withOpacity(0.15), shape: BoxShape.circle),
                child: Icon(icon, color: color, size: 20),
              ),
              Expanded(
                child: Text(
                  value,
                  style: AppTextStyles.headline4.copyWith(fontWeight: FontWeight.w900, fontSize: 22, color: Theme.of(context).textTheme.bodyLarge?.color),
                  textAlign: TextAlign.end,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(title, style: AppTextStyles.caption.copyWith(color: Theme.of(context).hintColor, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

class ReportTypeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;

  const ReportTypeCard({super.key, required this.icon, required this.title, required this.description, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: color.withOpacity(0.3),
      color: color.withOpacity(0.06),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
        side: BorderSide(color: color.withOpacity(0.25), width: 1.2),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        splashColor: color.withOpacity(0.15),
        highlightColor: color.withOpacity(0.05),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [color.withOpacity(0.85), color], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6))],
                ),
                child: Icon(icon, color: Colors.white, size: 28),
              ),
              const Spacer(),
              Text(title, style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w800, fontSize: 15), maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 8),
              Text(description, style: AppTextStyles.caption.copyWith(color: Theme.of(context).hintColor, height: 1.3), maxLines: 2, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SectionHeader({super.key, required this.title, this.actionLabel, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w700, fontSize: 18), maxLines: 1, overflow: TextOverflow.ellipsis),
        if (actionLabel != null)
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(foregroundColor: Theme.of(context).primaryColor),
            child: Text(actionLabel!, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
      ],
    );
  }
}

class _ComparativeResultDialog extends StatelessWidget {
  final Map<String, double> results;

  const _ComparativeResultDialog({required this.results});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      title: Text(context.l10n.comparisonResults, maxLines: 1, overflow: TextOverflow.ellipsis),
      content: SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: results.entries.map((e) {
            final rate = e.value.toStringAsFixed(1);
            return ListTile(
              leading: const Icon(Icons.bar_chart, color: AppColors.primary),
              title: Text(e.key, maxLines: 1, overflow: TextOverflow.ellipsis),
              trailing: Text('%$rate', style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(context.l10n.dismiss, maxLines: 1, overflow: TextOverflow.ellipsis)),
      ],
    );
  }
}

class _ClassDetailedResultDialog extends StatelessWidget {
  final String grade;
  final Map<String, double> results;

  const _ClassDetailedResultDialog({required this.grade, required this.results});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      title: Text(context.l10n.attendanceRateGrade, maxLines: 1, overflow: TextOverflow.ellipsis),
      content: SizedBox(
        width: 300,
        child: results.isEmpty
            ? Text(context.l10n.noDataGrade, maxLines: 1, overflow: TextOverflow.ellipsis)
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: results.entries.map((e) {
                  final rate = e.value.toStringAsFixed(1);
                  return ListTile(
                    leading: const Icon(Icons.class_, color: Colors.teal),
                    title: Text(context.l10n.sectionE, maxLines: 1, overflow: TextOverflow.ellipsis),
                    trailing: Text('%$rate', style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                  );
                }).toList(),
              ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(context.l10n.dismiss, maxLines: 1, overflow: TextOverflow.ellipsis)),
      ],
    );
  }
}

class _QuickActionBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionBtn({required this.label, required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [color.withOpacity(0.12), color.withOpacity(0.03)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: Border.all(color: color.withOpacity(0.35), width: 1.2),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          splashColor: color.withOpacity(0.15),
          highlightColor: color.withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: color.withOpacity(0.25), blurRadius: 12, offset: const Offset(0, 6))],
                  ),
                  child: Icon(icon, color: color, size: 30),
                ),
                const SizedBox(height: 14),
                Text(
                  label,
                  style: AppTextStyles.subtitle2.copyWith(fontWeight: FontWeight.w800, color: color),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}