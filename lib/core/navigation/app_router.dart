import 'package:flutter/material.dart';
import 'package:school_schedule_app/core/utils/l10n_extension.dart';
import 'package:school_schedule_app/core/widgets/premium_app_bar.dart';
import 'package:school_schedule_app/features/splash/presentation/splash_screen.dart';
import 'package:school_schedule_app/features/auth/presentation/login_screen.dart';
import 'package:school_schedule_app/features/home/presentation/home_screen.dart';
import 'package:school_schedule_app/features/students/presentation/students_list_screen.dart';
import 'package:school_schedule_app/features/students/presentation/add_edit_student_screen.dart';
import 'package:school_schedule_app/features/students/presentation/import_students_screen.dart';
import 'package:school_schedule_app/features/students/presentation/grades_management_screen.dart';
import 'package:school_schedule_app/features/students/presentation/subjects_management_screen.dart';
import 'package:school_schedule_app/features/barcode/presentation/student_card_screen.dart';
import 'package:school_schedule_app/features/barcode/presentation/barcode_scanner_screen.dart';
import 'package:school_schedule_app/features/barcode/presentation/batch_cards_screen.dart';
import 'package:school_schedule_app/features/attendance/presentation/attendance_home_screen.dart';
import 'package:school_schedule_app/features/attendance/presentation/attendance_session_screen.dart';
import 'package:school_schedule_app/features/reports/presentation/reports_home_screen.dart';
import 'package:school_schedule_app/features/reports/presentation/daily_report_screen.dart';
import 'package:school_schedule_app/features/reports/presentation/monthly_report_screen.dart';
import 'package:school_schedule_app/features/reports/presentation/yearly_report_screen.dart';
import 'package:school_schedule_app/features/reports/presentation/student_report_screen.dart';
import 'package:school_schedule_app/features/reports/presentation/report_preview_screen.dart';
import 'package:school_schedule_app/features/settings_advanced/presentation/settings_home_screen.dart';
import 'package:school_schedule_app/features/settings_advanced/presentation/school_settings_screen.dart';
import 'package:school_schedule_app/features/settings_advanced/presentation/users_management_screen.dart';
import 'package:school_schedule_app/features/settings_advanced/presentation/backup_screen.dart';
import 'package:school_schedule_app/features/settings_advanced/presentation/audit_log_screen.dart';
import 'package:school_schedule_app/features/settings_advanced/presentation/language_and_theme_screen.dart';
import 'package:school_schedule_app/features/settings_advanced/presentation/notifications_settings_screen.dart';
import 'package:school_schedule_app/features/settings_advanced/presentation/notifications_screen.dart';
import 'package:school_schedule_app/core/database/attendance_database.dart';
// Timetable Module
import 'package:school_schedule_app/presentation/pages/dashboard_page.dart' as timetable_dashboard;
import 'package:school_schedule_app/presentation/pages/teacher_list_page.dart';
import 'package:school_schedule_app/presentation/pages/classroom_list_page.dart';
import '../../presentation/pages/subject_list_page.dart' as timetable_subjects;
import 'package:school_schedule_app/presentation/pages/schedule_grid_page.dart';
import '../../presentation/pages/settings_page.dart' as timetable_settings;

// ============================================================================
// ROUTE NAMES
// ============================================================================

class AppRoutes {
  AppRoutes._();

  // Main
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String notifications = '/notifications';

  // Students
  static const String students = '/students';
  static const String addStudent = '/students/add';
  static const String editStudent = '/students/edit';
  static const String importStudents = '/students/import';

  // Barcode
  static const String barcodes = '/barcodes';
  static const String generateBarcode = '/barcodes/generate';
  static const String printBarcodes = '/barcodes/print';
  static const String scanBarcode = '/attendance/scan';

  // Attendance
  static const String attendance = '/attendance';
  static const String attendanceSession = '/attendance/session';
  static const String manualAttendance = '/attendance/manual';

  // Reports
  static const String reports = '/reports';
  static const String dailyReport = '/reports/daily';
  static const String monthlyReport = '/reports/monthly';
  static const String yearlyReport = '/reports/yearly';
  static const String studentReport = '/reports/student';
  static const String reportPreview = '/reports/preview';

  // Settings (advanced — attendance module)
  static const String advancedSettings = '/settings-advanced';
  static const String schoolSettings = '/settings/school';
  static const String users = '/settings/users';
  static const String backup = '/settings/backup';
  static const String auditLog = '/settings/audit';
  static const String notificationsSettings = '/settings/notifications';
  static const String languageAndTheme = '/settings/language';

  // Academic structure (attendance module)
  static const String grades = '/grades';
  static const String subjects = '/subjects-att';

  // Timetable
  static const String timetableDashboard = '/timetable/dashboard';
  static const String teachers = '/timetable/teachers';
  static const String classrooms = '/timetable/classrooms';
  static const String timetableSubjects = '/timetable/subjects';
  static const String scheduleGenerator = '/timetable/schedule';
  static const String timetableSettings = '/timetable/settings';
}

// ============================================================================
// APP NAVIGATOR
// ============================================================================

class AppNavigator {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static NavigatorState? get _nav => navigatorKey.currentState;
  static BuildContext? get currentContext => navigatorKey.currentContext;

  static Future<T?> push<T>(String routeName, {Object? arguments}) {
    return _nav!.pushNamed<T>(routeName, arguments: arguments);
  }

  static Future<T?> pushReplacement<T>(String routeName, {Object? arguments}) {
    return _nav!.pushReplacementNamed<T, dynamic>(routeName, arguments: arguments);
  }

  static void pop<T>([T? result]) => _nav?.pop<T>(result);

  static Future<T?> pushAndRemoveAll<T>(String routeName, {Object? arguments}) {
    return _nav!.pushNamedAndRemoveUntil<T>(routeName, (r) => false, arguments: arguments);
  }

  static bool canPop() => _nav?.canPop() ?? false;
}

// ============================================================================
// ROUTE GENERATOR — generates MaterialPageRoute for named routes
// ============================================================================

class AppRouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // --------- MAIN ---------
      case AppRoutes.splash:
        return _build(const SplashScreenPage(), settings);

      case AppRoutes.login:
        return _build(const LoginScreenPage(), settings);

      case AppRoutes.home:
        return _build(const HomeScreenPage(), settings);

      case AppRoutes.notifications:
        return _build(const NotificationsScreen(), settings);

      // --------- STUDENTS ---------
      case AppRoutes.students:
        return _build(const StudentsListScreen(), settings);

      case AppRoutes.addStudent:
        return _build(const AddEditStudentScreen(), settings);

      case AppRoutes.editStudent:
        final student = settings.arguments;
        return _build(
          AddEditStudentScreen(student: student is AttStudent ? student : null),
          settings,
        );

      case AppRoutes.importStudents:
        return _build(const ImportStudentsScreen(), settings);

      case AppRoutes.grades:
        return _build(const GradesManagementScreen(), settings);

      case AppRoutes.subjects:
        return _build(const SubjectsManagementScreen(), settings);

      // --------- TIMETABLE ---------
      case AppRoutes.timetableDashboard:
        return _build(const timetable_dashboard.DashboardPage(), settings);
      
      case AppRoutes.teachers:
        return _build(const TeacherListPage(), settings);
        
      case AppRoutes.classrooms:
        return _build(const ClassroomListPage(), settings);
        
      case AppRoutes.timetableSubjects:
        return _build(const timetable_subjects.SubjectListPage(), settings);
        
      case AppRoutes.scheduleGenerator:
        return _build(const ScheduleGridPage(), settings);
        
      case AppRoutes.timetableSettings:
        return _build(const timetable_settings.SettingsPage(), settings);

      // --------- BARCODE ---------
      case AppRoutes.barcodes:
      case AppRoutes.printBarcodes:
        final initialStudents = settings.arguments as List<AttStudent>?;
        return _build(BatchCardsScreen(initialSelectedStudents: initialStudents), settings);

      case AppRoutes.generateBarcode:
        final student = settings.arguments;
        return _build(
          student is AttStudent
              ? StudentCardScreen(student: student)
              : const BatchCardsScreen(),
          settings,
        );

      case AppRoutes.scanBarcode:
        return _build(const BarcodeScannerScreen(), settings);

      // --------- ATTENDANCE ---------
      case AppRoutes.attendance:
        return _build(const AttendanceHomeScreen(), settings);

      case AppRoutes.attendanceSession:
      case AppRoutes.manualAttendance:
        final session = settings.arguments;
        return _build(
          session is AttSession
              ? AttendanceSessionScreen(
                  sessionId: session.id,
                  gradeId: session.gradeId,
                  sectionId: session.sectionId,
                )
              : const AttendanceSessionScreen(),
          settings,
        );

      // --------- REPORTS ---------
      case AppRoutes.reports:
        return _build(const ReportsHomeScreen(), settings);

      case AppRoutes.dailyReport:
        return _build(const DailyReportScreen(), settings);

      case AppRoutes.monthlyReport:
        return _build(const MonthlyReportScreen(), settings);

      case AppRoutes.yearlyReport:
        return _build(const YearlyReportScreen(), settings);

      case AppRoutes.studentReport:
        final student = settings.arguments;
        return _build(
          StudentReportScreen(student: student is AttStudent ? student : null),
          settings,
        );
        
      case AppRoutes.reportPreview:
        final args = settings.arguments as ReportPreviewScreenArgs;
        return _build(ReportPreviewScreen(args: args), settings);

      // --------- SETTINGS (ADVANCED) ---------
      case AppRoutes.advancedSettings:
        return _build(const SettingsHomeScreen(), settings);

      case AppRoutes.schoolSettings:
        return _build(const SchoolSettingsScreen(), settings);

      case AppRoutes.languageAndTheme:
        return _build(const LanguageAndThemeScreen(), settings);

      case AppRoutes.notificationsSettings:
        return _build(const NotificationsSettingsScreen(), settings);

      case AppRoutes.users:
        return _build(const UsersManagementScreen(), settings);

      case AppRoutes.backup:
        return _build(const BackupScreen(), settings);

      case AppRoutes.auditLog:
        return _build(const AuditLogScreen(), settings);

      // --------- 404 ---------
      default:
        return _build(const _NotFoundPage(), settings);
    }
  }

  static MaterialPageRoute<T> _build<T>(Widget page, RouteSettings settings) {
    return MaterialPageRoute<T>(
      builder: (_) => page,
      settings: settings,
    );
  }
}

// ============================================================================
// 404 PAGE
// ============================================================================

class _NotFoundPage extends StatelessWidget {
  const _NotFoundPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PremiumAppBar(title: Text(context.l10n.pageNotFound, maxLines: 1, overflow: TextOverflow.ellipsis)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            Text(context.l10n.pageNotFound, style: const TextStyle(fontSize: 18, fontFamily: 'Cairo'), maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => AppNavigator.pushAndRemoveAll(AppRoutes.home),
              child: Text(context.l10n.backToHome, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}
