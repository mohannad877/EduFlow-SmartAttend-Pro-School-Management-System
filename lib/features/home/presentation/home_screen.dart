import 'package:school_schedule_app/core/utils/l10n_extension.dart';

import 'package:school_schedule_app/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:school_schedule_app/core/widgets/premium_app_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:school_schedule_app/core/theme/app_colors.dart';
import 'package:school_schedule_app/core/theme/app_text_styles.dart';
import 'package:school_schedule_app/core/navigation/app_router.dart';
import 'package:school_schedule_app/core/utils/app_helpers.dart';
import 'package:school_schedule_app/core/database/attendance_providers.dart';
import 'package:school_schedule_app/core/providers/notifications_provider.dart';
import 'package:school_schedule_app/features/reports/presentation/reports_home_screen.dart';
import 'package:school_schedule_app/features/settings_advanced/presentation/settings_home_screen.dart';
import 'package:school_schedule_app/presentation/pages/dashboard_page.dart' as timetable_dashboard;
import 'package:school_schedule_app/presentation/bloc/dashboard/dashboard_bloc.dart';
import 'package:school_schedule_app/presentation/bloc/dashboard/dashboard_event.dart';
import 'package:school_schedule_app/presentation/bloc/dashboard/dashboard_state.dart';

// ────────────────────────────────────────────────────────────────────────────
// ROOT HOST — يملك القائمة الجانبية والشريط السفلي والصفحات
// ────────────────────────────────────────────────────────────────────────────

class HomeScreenPage extends ConsumerStatefulWidget {
  const HomeScreenPage({super.key});

  @override
  ConsumerState<HomeScreenPage> createState() => _HomeScreenPageState();
}

class _HomeScreenPageState extends ConsumerState<HomeScreenPage> {
  int _currentIndex = 0;

  List<_TabItem> _buildTabs(BuildContext context) => [
    _TabItem(Icons.dashboard_outlined, Icons.dashboard_rounded, context.l10n.dashboardTab),
    _TabItem(Icons.calendar_month_outlined, Icons.calendar_month_rounded, context.l10n.schedulesTab),
    _TabItem(Icons.analytics_outlined, Icons.analytics_rounded, context.l10n.reportsHeader),
    _TabItem(Icons.settings_outlined, Icons.settings_rounded, context.l10n.settings),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: _buildDrawer(context),
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          _MasterDashboard(),               // الرئيسية
          timetable_dashboard.DashboardPage(), // الجداول
          ReportsHomeScreen(),              // التقارير
          SettingsHomeScreen(),             // الإعدادات
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ── AppBar ──────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    final titles = [context.l10n.dashboardHeader, context.l10n.manageSchedulesHeader, context.l10n.reportsHeader, context.l10n.settingsHeader];
    return PremiumAppBar(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: Text(
        titles[_currentIndex],
        style: AppTextStyles.headline6.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
      maxLines: 1, overflow: TextOverflow.ellipsis),
      actions: [
        Consumer(
          builder: (context, ref, child) {
            final notifications = ref.watch(notificationsProvider);
            final unreadCount = notifications.where((n) => !n.isRead).length;

            return Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_none_rounded),
                  tooltip: context.l10n.notifications,
                  onPressed: () => AppNavigator.push(AppRoutes.notifications),
                ),
                if (unreadCount > 0)
                  PositionedDirectional(
                    end: 4,
                    top: 4,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.error,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$unreadCount',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  // ── Bottom Nav ───────────────────────────────────────────────────────────
  Widget _buildBottomNav() {
    final tabs = _buildTabs(context);
    return NavigationBar(
      selectedIndex: _currentIndex,
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 12,
      shadowColor: Colors.black26,
      indicatorColor: AppColors.primary.withOpacity(0.12),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      onDestinationSelected: (i) => setState(() => _currentIndex = i),
      destinations: tabs.map((t) => NavigationDestination(
        icon: Icon(t.icon),
        selectedIcon: Icon(t.selectedIcon, color: AppColors.primary),
        label: t.label,
      )).toList(),
    );
  }

  // ── Drawer ───────────────────────────────────────────────────────────────
  Widget _buildDrawer(BuildContext context) {
    final user = ref.watch(authStateProvider).user;
    final isAdmin = user?.role == 'admin';
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(left: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // رأس القائمة
          Container(
            width: double.infinity,
            padding: const EdgeInsetsDirectional.fromSTEB(20, 56, 20, 24),
            decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  child: const Icon(Icons.person_rounded, size: 36, color: Colors.white),
                ),
                const SizedBox(height: 12),
                Text(user?.name ?? context.l10n.systemUser, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(user?.role.toString().split('.').last ?? context.l10n.adminRole,
                    style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _drawerSection(context.l10n.studentsAttendanceSection),
                _drawerTile(context.l10n.studentList, Icons.people_rounded, AppColors.primary, () => AppNavigator.push(AppRoutes.students)),
                if (isAdmin) _drawerTile(context.l10n.addNewStudent, Icons.person_add_rounded, AppColors.present, () => AppNavigator.push(AppRoutes.addStudent)),
                if (isAdmin) _drawerTile(context.l10n.importStudentsData, Icons.upload_file, AppColors.info, () => AppNavigator.push(AppRoutes.importStudents)),
                _drawerTile(context.l10n.manualAttendance, Icons.fact_check_rounded, AppColors.present, () => AppNavigator.push(AppRoutes.manualAttendance)),
                _drawerTile(context.l10n.barcodeAttendance, Icons.qr_code_scanner_rounded, AppColors.primary, () => AppNavigator.push(AppRoutes.barcodes)),
                if (isAdmin) _drawerTile(context.l10n.educationalGrades, Icons.school_rounded, AppColors.secondary, () => AppNavigator.push(AppRoutes.grades)),

                const Divider(height: 24),
                _drawerSection(context.l10n.schoolSchedulesSection),
                _drawerTile(context.l10n.teachersLabel, Icons.person_rounded, AppColors.primary, () => AppNavigator.push(AppRoutes.teachers)),
                _drawerTile(context.l10n.classroomsLabel, Icons.business_rounded, AppColors.secondary, () => AppNavigator.push(AppRoutes.classrooms)),
                _drawerTile(context.l10n.subjectsLabel, Icons.library_books_rounded, AppColors.info, () => AppNavigator.push(AppRoutes.timetableSubjects)),
                _drawerTile(context.l10n.viewSchedulesLabel, Icons.auto_awesome_rounded, Theme.of(context).colorScheme.secondary, () => AppNavigator.push(AppRoutes.scheduleGenerator)),
                if (isAdmin) _drawerTile(context.l10n.scheduleGenerationSettings, Icons.settings_suggest_rounded, AppColors.textSecondary, () => AppNavigator.push(AppRoutes.timetableSettings)),

                const Divider(height: 24),
                _drawerSection(context.l10n.reportsSection),
                _drawerTile(context.l10n.dailyReportLabel, Icons.today_rounded, AppColors.info, () => AppNavigator.push(AppRoutes.dailyReport)),
                _drawerTile(context.l10n.monthlyReportLabel, Icons.calendar_view_month_rounded, AppColors.secondary, () => AppNavigator.push(AppRoutes.monthlyReport)),
                _drawerTile(context.l10n.yearlyReportLabel, Icons.bar_chart_rounded, AppColors.primary, () => AppNavigator.push(AppRoutes.yearlyReport)),

                const Divider(height: 24),
                _drawerSection(context.l10n.settingsSystemSection),
                _drawerTile(context.l10n.barcodePrinting, Icons.print_rounded, AppColors.textSecondary, () => AppNavigator.push(AppRoutes.generateBarcode)),
                if (isAdmin) _drawerTile(context.l10n.schoolSettingsLabel, Icons.domain_rounded, AppColors.primary, () => AppNavigator.push(AppRoutes.schoolSettings)),
                if (isAdmin) _drawerTile(context.l10n.usersPermissions, Icons.manage_accounts_rounded, AppColors.secondary, () => AppNavigator.push(AppRoutes.users)),
                if (isAdmin) _drawerTile(context.l10n.backupLabel, Icons.backup_rounded, AppColors.info, () => AppNavigator.push(AppRoutes.backup)),
                if (isAdmin) _drawerTile(context.l10n.auditLogLabel, Icons.history_rounded, AppColors.textSecondary, () => AppNavigator.push(AppRoutes.auditLog)),
              ],
            ),
          ),

          // زر الخروج
          const Divider(height: 1),
          ListTile(
            leading: Icon(Icons.logout_rounded, color: Theme.of(context).colorScheme.error),
            title: Text(context.l10n.logout, style: TextStyle(color: Theme.of(context).colorScheme.error, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
            onTap: () {
              ref.read(authStateProvider.notifier).logout();
              AppNavigator.pushReplacement(AppRoutes.login);
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _drawerSection(String label) => Padding(
    padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 4),
    child: Text(label, style: const TextStyle(
      fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Cairo',
    ), maxLines: 1, overflow: TextOverflow.ellipsis),
  );

  Widget _drawerTile(String title, IconData icon, Color color, VoidCallback onTap) {
    return ListTile(
      dense: true,
      leading: Container(
        width: 36, height: 36,
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(title, style: AppTextStyles.subtitle2.copyWith(fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
      onTap: () { Navigator.pop(context); onTap(); },
    );
  }
}

class _TabItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  const _TabItem(this.icon, this.selectedIcon, this.label);
}

// ════════════════════════════════════════════════════════════════════════════
// MASTER DASHBOARD — اللوحة الرئيسية الشاملة
// ════════════════════════════════════════════════════════════════════════════

class _MasterDashboard extends ConsumerWidget {
  const _MasterDashboard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAdmin = ref.watch(authStateProvider).isAdmin;
    return BlocProvider(
      create: (_) => GetIt.I<DashboardBloc>()..add(LoadDashboardStats(attendanceDb: ref.read(attendanceDatabaseProvider))),
      child: Builder(builder: (ctx) {
        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            ctx.read<DashboardBloc>().add(LoadDashboardStats(attendanceDb: ref.read(attendanceDatabaseProvider)));
            await Future.delayed(const Duration(milliseconds: 600));
          },
          child: CustomScrollView(
            slivers: [
              // ── بطاقة الترحيب ──────────────────────────────────────────
              SliverToBoxAdapter(child: _WelcomeCard(ref: ref)
                  .animate().fadeIn(duration: 400.ms).slideY(begin: -0.1, end: 0)),

              // ── الإحصائيات الفائقة ────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 20, 16, 0),
                sliver: SliverToBoxAdapter(
                  child: _SectionHeader(title: context.l10n.systemStatistics, onSeeAll: null)
                      .animate().fadeIn(delay: 100.ms),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                sliver: SliverToBoxAdapter(
                  child: BlocBuilder<DashboardBloc, DashboardState>(
                    builder: (_, state) {
                      int teachers = 0, classrooms = 0, subjects = 0;
                      var students = 0;
                      var attendanceRate = 0.0;
                      if (state is DashboardLoaded) {
                        teachers = state.teacherCount;
                        classrooms = state.classroomCount;
                        subjects = state.subjectCount;
                        students = state.totalStudents;
                        attendanceRate = state.todayAttendanceRate;
                      }
                      return _StatsGrid(
                        teachers: teachers,
                        classrooms: classrooms,
                        subjects: subjects,
                        students: students,
                        attendanceRate: attendanceRate,
                      ).animate().fadeIn(delay: 150.ms);
                    },
                  ),
                ),
              ),

              // ── المنظومة المدرسية ────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 24, 16, 8),
                sliver: SliverToBoxAdapter(
                  child: _SectionHeader(title: context.l10n.schoolSystemSection, onSeeAll: null)
                      .animate().fadeIn(delay: 200.ms),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverToBoxAdapter(
                  child: _FeatureGrid(items: [
                    _Feature(context.l10n.teachersLabel, Icons.person_rounded, Color(0xFF1565C0), AppRoutes.teachers, context.l10n.manageTeachersDesc),
                    _Feature(context.l10n.classes, Icons.business_rounded, Color(0xFF00897B), AppRoutes.classrooms, context.l10n.classroomsLabsDesc),
                    _Feature(context.l10n.subjects, Icons.library_books_rounded, Color(0xFF1976D2), AppRoutes.timetableSubjects, context.l10n.subjectsDesc),
                    _Feature(context.l10n.gradesLabel, Icons.school_rounded, Color(0xFF7B1FA2), AppRoutes.grades, context.l10n.academicClassesDesc),
                    _Feature(context.l10n.students, Icons.people_rounded, Color(0xFF0097A7), AppRoutes.students, context.l10n.studentsDatabaseDesc),
                    if (isAdmin)
                      _Feature(context.l10n.addStudentLabel, Icons.person_add_rounded, Color(0xFF2E7D32), AppRoutes.addStudent, context.l10n.registerNewStudentDesc),
                  ]).animate().fadeIn(delay: 250.ms),
                ),
              ),

              // ── الجداول الذكية ────────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 24, 16, 8),
                sliver: SliverToBoxAdapter(
                  child: _SectionHeader(title: context.l10n.smartSchedulesHeader, onSeeAll: () => AppNavigator.push(AppRoutes.scheduleGenerator))
                      .animate().fadeIn(delay: 300.ms),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverToBoxAdapter(
                  child: _FeatureGrid(items: [
                    _Feature(context.l10n.generateSchedule, Icons.auto_awesome_rounded, Color(0xFFF57C00), AppRoutes.scheduleGenerator, context.l10n.generateAutoScheduleDesc),
                    _Feature(context.l10n.viewSchedulesLabel, Icons.calendar_view_week_rounded, Color(0xFFE64A19), AppRoutes.scheduleGenerator, context.l10n.browseSchedulesDesc),
                    if (isAdmin)
                      _Feature(context.l10n.scheduleSettingsLabel, Icons.tune_rounded, Color(0xFF546E7A), AppRoutes.timetableSettings, context.l10n.customizeConstraintsDesc),
                  ]).animate().fadeIn(delay: 350.ms),
                ),
              ),

              // ── التحضير والمتابعة ────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 24, 16, 8),
                sliver: SliverToBoxAdapter(
                  child: _SectionHeader(title: context.l10n.attendanceTrackingHeader, onSeeAll: () => AppNavigator.push(AppRoutes.attendance))
                      .animate().fadeIn(delay: 400.ms),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverToBoxAdapter(
                  child: _FeatureGrid(items: [
                    _Feature(context.l10n.manualAttendance, Icons.fact_check_rounded, Color(0xFF388E3C), AppRoutes.manualAttendance, context.l10n.recordAttendanceDesc),
                    _Feature(context.l10n.barcodeAttendance, Icons.qr_code_scanner_rounded, Color(0xFF1565C0), AppRoutes.barcodes, context.l10n.scanCardsDesc),
                    _Feature(context.l10n.generateBarcodeDesc, Icons.badge_rounded, Color(0xFF00695C), AppRoutes.generateBarcode, context.l10n.createStudentCardsDesc),
                    _Feature(context.l10n.printBarcodeDesc, Icons.print_rounded, Color(0xFF4527A0), AppRoutes.printBarcodes, context.l10n.printCardsDesc),
                  ]).animate().fadeIn(delay: 450.ms),
                ),
              ),

              // ── التقارير ──────────────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 24, 16, 8),
                sliver: SliverToBoxAdapter(
                  child: _SectionHeader(title: context.l10n.reportsAnalyticsHeader, onSeeAll: () => AppNavigator.push(AppRoutes.reports))
                      .animate().fadeIn(delay: 500.ms),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverToBoxAdapter(
                  child: _FeatureGrid(items: [
                    _Feature(context.l10n.dailyReport, Icons.today_rounded, Color(0xFF1976D2), AppRoutes.dailyReport, context.l10n.todayAttendanceDesc),
                    _Feature(context.l10n.monthlyReport, Icons.calendar_view_month_rounded, Color(0xFF00838F), AppRoutes.monthlyReport, context.l10n.monthlySummaryDesc),
                    _Feature(context.l10n.yearlyReport, Icons.bar_chart_rounded, Color(0xFF6A1B9A), AppRoutes.yearlyReport, context.l10n.yearlyStatsDesc),
                    _Feature(context.l10n.studentAttendanceReport, Icons.person_search_rounded, Color(0xFFC6282A), AppRoutes.studentReport, context.l10n.studentHistoryDesc),
                  ]).animate().fadeIn(delay: 550.ms),
                ),
              ),

              // ── إعدادات النظام (للمشرفين فقط) ──────────────────────
              if (isAdmin) ...
                [
                  SliverPadding(
                    padding: const EdgeInsetsDirectional.fromSTEB(16, 24, 16, 8),
                    sliver: SliverToBoxAdapter(
                      child: _SectionHeader(title: context.l10n.adminSettingsHeader, onSeeAll: null)
                          .animate().fadeIn(delay: 600.ms),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 100),
                    sliver: SliverToBoxAdapter(
                      child: _FeatureGrid(items: [
                        _Feature(context.l10n.schoolSettings, Icons.domain_rounded, Color(0xFF0277BD), AppRoutes.schoolSettings, context.l10n.organizationDataDesc),
                        _Feature(context.l10n.users, Icons.manage_accounts_rounded, Color(0xFF00695C), AppRoutes.users, context.l10n.userPermissionsDesc),
                        _Feature(context.l10n.importStudents, Icons.upload_file_rounded, Color(0xFF558B2F), AppRoutes.importStudents, context.l10n.uploadExcelFileDesc),
                        _Feature(context.l10n.backup, Icons.backup_rounded, Color(0xFF4527A0), AppRoutes.backup, context.l10n.dataBackupDesc),
                        _Feature(context.l10n.auditLog, Icons.history_rounded, Color(0xFF5D4037), AppRoutes.auditLog, context.l10n.trackOperationsDesc),
                        _Feature(context.l10n.attendanceSubjectsLabel, Icons.book_outlined, Color(0xFF00838F), AppRoutes.subjects, context.l10n.attendanceSubjectsDesc),
                      ]).animate().fadeIn(delay: 650.ms),
                    ),
                  ),
                ],

              // Space at bottom when not admin
              if (!isAdmin)
                const SliverPadding(padding: EdgeInsetsDirectional.only()),
            ],
          ),
        );
      }),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// بطاقة الترحيب
// ────────────────────────────────────────────────────────────────────────────

class _WelcomeCard extends ConsumerWidget {
  const _WelcomeCard({required this.ref});
  final WidgetRef ref;

  @override
  Widget build(BuildContext context, WidgetRef r) {
    final authState = r.watch(authStateProvider);
    final now = DateTime.now();
    final greeting = _greeting(context, now.hour);

    return Container(
      margin: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: AppColors.premiumGradient,
        boxShadow: [BoxShadow(color: const Color(0xFF1565C0).withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: Stack(
        children: [
          // دوائر زخرفية
          PositionedDirectional(end: -20, top: -30, child: _circle(120, Colors.white.withOpacity(0.06))),
          PositionedDirectional(start: -10, bottom: -40, child: _circle(150, Colors.white.withOpacity(0.05))),
          PositionedDirectional(end: 60, bottom: -20, child: _circle(80, Colors.white.withOpacity(0.07))),
          // المحتوى
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.wb_sunny_rounded, color: Colors.amber, size: 20),
                    const SizedBox(width: 8),
                    Text(greeting, style: const TextStyle(color: Colors.white70, fontSize: 14, fontFamily: 'Cairo'), maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      authState.user?.name ?? context.l10n.systemUser,
                      style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Text(
                      DateTimeUtils.formatArabicDate(now),
                      style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 13, fontFamily: 'Cairo'),
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ],
            ),
          ),
          // أيقونة صغيرة في الزاوية
          PositionedDirectional(
            end: 20,
            bottom: 20,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.school_rounded, color: Colors.white, size: 24),
            ),
          ),
        ],
      ),
    );
  }

  Widget _circle(double size, Color color) =>
      Container(width: size, height: size, decoration: BoxDecoration(color: color, shape: BoxShape.circle));

  String _greeting(BuildContext context, int hour) {
    if (hour < 12) return context.l10n.goodMorning;
    if (hour < 17) return context.l10n.goodAfternoon;
    return context.l10n.goodEvening;
  }
}

// ────────────────────────────────────────────────────────────────────────────
// شبكة الإحصائيات
// ────────────────────────────────────────────────────────────────────────────

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.teachers, required this.classrooms, required this.subjects, required this.students, required this.attendanceRate});
  final int teachers, classrooms, subjects, students;
  final double attendanceRate;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _statChip(context.l10n.studentsLabel, '$students', Icons.people_rounded, const Color(0xFF1565C0)),
          _statChip(context.l10n.attendanceLabel, '${(attendanceRate * 100).toStringAsFixed(1)}%', Icons.trending_up_rounded, const Color(0xFF2E7D32)),
          _statChip(context.l10n.teachersLabel, '$teachers', Icons.person_rounded, const Color(0xFF6A1B9A)),
          _statChip(context.l10n.roomsLabel, '$classrooms', Icons.business_rounded, const Color(0xFF00695C)),
          _statChip(context.l10n.subjects, '$subjects', Icons.library_books_rounded, const Color(0xFFE65100)),
        ],
      ),
    );
  }

  Widget _statChip(String label, String value, IconData icon, Color color) {
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          width: 120,
          margin: const EdgeInsetsDirectional.only(start: 12),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black26 : color.withOpacity(0.12),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: color.withOpacity(isDark ? 0.3 : 0.15)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 32, height: 32,
                decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, color: color, size: 18),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value,
                      style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  Text(label,
                      style: TextStyle(
                          fontSize: 11,
                          fontFamily: 'Cairo',
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// رأس القسم
// ────────────────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.onSeeAll});
  final String title;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Cairo'), maxLines: 1, overflow: TextOverflow.ellipsis),
        if (onSeeAll != null)
          TextButton(
            onPressed: onSeeAll,
            child: Text(context.l10n.viewAll, style: TextStyle(color: AppColors.primary, fontFamily: 'Cairo'), maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
      ],
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// شبكة الميزات
// ────────────────────────────────────────────────────────────────────────────

class _FeatureGrid extends StatelessWidget {
  const _FeatureGrid({required this.items});
  final List<_Feature> items;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: items.length,
      itemBuilder: (_, i) => _FeatureCard(feature: items[i])
          .animate(delay: Duration(milliseconds: 40 * i))
          .fadeIn()
          .scale(begin: const Offset(0.9, 0.9)),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({required this.feature});
  final _Feature feature;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      shadowColor: feature.color.withOpacity(0.2),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => AppNavigator.push(feature.route),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [feature.color.withOpacity(0.8), feature.color],
                    begin: AlignmentDirectional.topStart,
                    end: AlignmentDirectional.bottomEnd,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [BoxShadow(color: feature.color.withOpacity(0.35), blurRadius: 8, offset: const Offset(0, 4))],
                ),
                child: Icon(feature.icon, color: Colors.white, size: 24),
              ),
              const SizedBox(height: 10),
              Text(
                feature.label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12, fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo', height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// نموذج بيانات الميزة
// ────────────────────────────────────────────────────────────────────────────

class _Feature {
  final String label;
  final IconData icon;
  final Color color;
  final String route;
  final String subtitle;
  const _Feature(this.label, this.icon, this.color, this.route, this.subtitle);
}
