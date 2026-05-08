import 'package:school_schedule_app/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:school_schedule_app/core/utils/l10n_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:school_schedule_app/presentation/widgets/quick_action_button.dart';
import 'package:school_schedule_app/presentation/pages/teacher_list_page.dart';
import 'package:school_schedule_app/presentation/pages/schedule_grid_page.dart';
import 'package:school_schedule_app/presentation/pages/classroom_list_page.dart';
import 'package:school_schedule_app/presentation/pages/subject_list_page.dart';
import 'package:school_schedule_app/core/theme/app_colors.dart';

import 'package:school_schedule_app/presentation/bloc/dashboard/dashboard_bloc.dart';
import 'package:school_schedule_app/presentation/bloc/dashboard/dashboard_event.dart';
import 'package:school_schedule_app/presentation/bloc/dashboard/dashboard_state.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  String _getGreeting(BuildContext context) {
    final hour = DateTime.now().hour;
    if (hour < 12) return context.l10n.goodMorning;
    return context.l10n.goodEvening;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<DashboardBloc>()..add(const LoadDashboardStats()),
      child: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is DashboardError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Theme.of(context).colorScheme.error),
                  const SizedBox(height: 16),
                  Text(
                    context.l10n.errorLoadingData,
                    style: TextStyle(color: Colors.grey.shade600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<DashboardBloc>().add(const LoadDashboardStats());
                    },
                    child: Text(context.l10n.retry, maxLines: 1, overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            );
          }

          var teacherCount = 0;
          var classroomCount = 0;
          var subjectCount = 0;
          var todaySessions = 0;
          var schoolName = context.l10n.appName;
          var academicYear = '${DateTime.now().year}/${DateTime.now().year + 1}';

          if (state is DashboardLoaded) {
            teacherCount = state.teacherCount;
            classroomCount = state.classroomCount;
            subjectCount = state.subjectCount;
            todaySessions = state.todaySessions ?? 0;
            if (state.schoolName != null && state.schoolName!.isNotEmpty) {
              schoolName = state.schoolName!;
            }
            if (state.academicYear != null && state.academicYear!.isNotEmpty) {
              academicYear = state.academicYear!;
            }
          }

          // final greeting = _getGreeting(context);

          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).colorScheme.primary.withOpacity(0.04),
                    Theme.of(context).colorScheme.surface,
                  ],
                ),
              ),
              child: SafeArea(
                child: RefreshIndicator(
                  onRefresh: () async {
                    context.read<DashboardBloc>().add(const LoadDashboardStats());
                    await Future.delayed(const Duration(milliseconds: 500));
                  },
                  child: ListView(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    children: [
                      _buildPremiumHeader(context, schoolName, academicYear),
                      const SizedBox(height: 24),
                      Text(
                        context.l10n.quickActions,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.5,
                        children: [
                          QuickActionButton(
                            label: context.l10n.manageTeachers,
                            icon: Icons.people_outline,
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const TeacherListPage(),
                                ),
                              );
                              if (context.mounted) {
                                context.read<DashboardBloc>().add(const LoadDashboardStats());
                              }
                            },
                          ),
                          QuickActionButton(
                            label: context.l10n.classes,
                            icon: Icons.class_,
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ClassroomListPage(),
                                ),
                              );
                              if (context.mounted) {
                                context.read<DashboardBloc>().add(const LoadDashboardStats());
                              }
                            },
                            color: Colors.green,
                          ),
                          QuickActionButton(
                            label: context.l10n.subjectsLabel,
                            icon: Icons.book,
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SubjectListPage(),
                                ),
                              );
                              if (context.mounted) {
                                context.read<DashboardBloc>().add(const LoadDashboardStats());
                              }
                            },
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          QuickActionButton(
                            label: context.l10n.schedule,
                            icon: Icons.calendar_today,
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ScheduleGridPage(),
                                ),
                              );
                              if (context.mounted) {
                                context.read<DashboardBloc>().add(const LoadDashboardStats());
                              }
                            },
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                          QuickActionButton(
                            label: context.l10n.generateSchedule,
                            icon: Icons.autorenew,
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ScheduleGridPage(
                                    autoOpenGenerate: true,
                                  ),
                                ),
                              );
                              if (context.mounted) {
                                context.read<DashboardBloc>().add(const LoadDashboardStats());
                              }
                            },
                            color: Theme.of(context).colorScheme.error,
                          ),
                          QuickActionButton(
                            label: context.l10n.exportLabel,
                            icon: Icons.upload_file,
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
                                builder: (sheetContext) => Padding(
                                  padding: const EdgeInsets.all(AppSpacing.lg),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        context.l10n.exportScheduleLabel,
                                        style: Theme.of(sheetContext)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(fontWeight: FontWeight.bold),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 16),
                                      ListTile(
                                        leading: Icon(
                                          Icons.picture_as_pdf,
                                          color: Theme.of(context).colorScheme.error,
                                          size: 32,
                                        ),
                                        title: Text(
                                          context.l10n.exportPdf,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        subtitle: Text(context.l10n.pdfReadyToPrint, maxLines: 1, overflow: TextOverflow.ellipsis),
                                        onTap: () {
                                          Navigator.pop(sheetContext);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const ScheduleGridPage(
                                                autoExport: 'pdf',
                                              ),
                                            ),
                                          ).then((_) {
                                            if (context.mounted) {
                                              context
                                                  .read<DashboardBloc>()
                                                  .add(const LoadDashboardStats());
                                            }
                                          });
                                        },
                                      ),
                                      const Divider(),
                                      ListTile(
                                        leading: const Icon(
                                          Icons.table_chart,
                                          color: Colors.green,
                                          size: 32,
                                        ),
                                        title: Text(
                                          context.l10n.exportExcel,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        subtitle: Text(context.l10n.excelEditableSheet, maxLines: 1, overflow: TextOverflow.ellipsis),
                                        onTap: () {
                                          Navigator.pop(sheetContext);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const ScheduleGridPage(
                                                autoExport: 'excel',
                                              ),
                                            ),
                                          ).then((_) {
                                            if (context.mounted) {
                                              context
                                                  .read<DashboardBloc>()
                                                  .add(const LoadDashboardStats());
                                            }
                                          });
                                        },
                                      ),
                                      const SizedBox(height: 8),
                                    ],
                                  ),
                                ),
                              );
                            },
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  Widget _buildPremiumHeader(BuildContext context, String schoolName, String academicYear) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: AppColors.premiumGradient,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          PositionedDirectional(end: -20, top: -30, child: _circle(120, Colors.white.withOpacity(0.06))),
          PositionedDirectional(start: -10, bottom: -40, child: _circle(150, Colors.white.withOpacity(0.05))),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today_rounded, color: Colors.amber, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      context.l10n.manageSchedulesHeader,
                      style: const TextStyle(color: Colors.white70, fontSize: 13, fontFamily: 'Cairo'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  schoolName,
                  style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  academicYear,
                  style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 14, fontFamily: 'Cairo'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _circle(double size, Color color) =>
      Container(width: size, height: size, decoration: BoxDecoration(color: color, shape: BoxShape.circle));
}
