import 'package:school_schedule_app/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:school_schedule_app/core/widgets/premium_app_bar.dart';
import 'package:school_schedule_app/core/utils/l10n_extension.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:school_schedule_app/domain/entities/enums.dart';
import 'package:school_schedule_app/domain/entities/session.dart';
import 'package:school_schedule_app/presentation/bloc/schedule/schedule_bloc.dart';
import 'package:school_schedule_app/presentation/bloc/schedule/schedule_state.dart';
import 'package:school_schedule_app/presentation/bloc/schedule/schedule_event.dart';
import 'package:school_schedule_app/presentation/widgets/session_edit_dialog.dart';
import 'package:school_schedule_app/presentation/widgets/validation_summary_dialog.dart';
import 'package:school_schedule_app/domain/repositories/i_teacher_repository.dart';
import 'package:school_schedule_app/domain/repositories/i_subject_repository.dart';
import 'package:school_schedule_app/domain/repositories/i_classroom_repository.dart';
import 'package:school_schedule_app/domain/entities/teacher.dart';
import 'package:school_schedule_app/domain/entities/subject.dart';
import 'package:school_schedule_app/domain/entities/classroom.dart';
import 'package:school_schedule_app/core/theme/app_colors.dart';

// ============================================================================
// ScheduleGridPage — Professional Timetable Management UI
// ============================================================================
class ScheduleGridPage extends StatefulWidget {
  final bool autoOpenGenerate;
  final String? autoExport;

  const ScheduleGridPage({
    super.key,
    this.autoOpenGenerate = false,
    this.autoExport,
  });

  @override
  State<ScheduleGridPage> createState() => _ScheduleGridPageState();
}

class _ScheduleGridPageState extends State<ScheduleGridPage>
    with TickerProviderStateMixin {
  bool _hasInitialActionRun = false;

  // --- Controllers ---
  final TransformationController _transformationController =
      TransformationController();
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  // --- Constants ---
  static const double _cellWidth = 140.0;
  static const double _cellHeight = 88.0;
  static const double _dayColumnWidth = 110.0;
  static const double _headerHeight = 52.0;
  static const double _borderRadius = 14.0;
  static const Duration _animDuration = Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: _animDuration,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    _fadeController.forward();

    _handleAutoActions();
  }

  void _handleAutoActions() {
    if (!widget.autoOpenGenerate && widget.autoExport == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _hasInitialActionRun) return;
      _hasInitialActionRun = true;
      Future.microtask(() {
        if (!mounted) return;
        final bloc = GetIt.I<ScheduleBloc>();
        if (widget.autoOpenGenerate) {
          _openGenerateDialog(context, bloc);
        } else if (widget.autoExport == 'pdf') {
          bloc.add(const ExportSchedulePdf());
        } else if (widget.autoExport == 'excel') {
          bloc.add(const ExportScheduleExcel());
        }
      });
    });
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  // ==========================================================================
  // BUILD
  // ==========================================================================
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<ScheduleBloc>()..add(const LoadSchedule()),
      child: Builder(
        builder: (innerContext) {
          return Scaffold(
            appBar: _buildAppBar(innerContext),
            body: BlocConsumer<ScheduleBloc, ScheduleState>(
              listenWhen: _shouldListen,
              listener: _handleStateListener,
              builder: (context, state) {
                return AnimatedSwitcher(
                  duration: _animDuration,
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  child: _buildBody(context, state, innerContext),
                );
              },
            ),
          );
        },
      ),
    );
  }

  bool _shouldListen(ScheduleState previous, ScheduleState current) {
    if (current is ScheduleError && previous is! ScheduleError) return true;
    if (current is! ScheduleLoaded) return false;
    final prev = previous is ScheduleLoaded ? previous : null;
    return (current.validationResult != null &&
            current.validationResult != prev?.validationResult) ||
        (current.actionError != null &&
            current.actionError != prev?.actionError) ||
        (current.actionSuccess != null &&
            current.actionSuccess != prev?.actionSuccess);
  }

  Widget _buildBody(
      BuildContext context, ScheduleState state, BuildContext innerContext) {
    if (state is ScheduleLoading) {
      return _buildShimmerLoading();
    } else if (state is ScheduleError) {
      return _buildEmptyState(innerContext);
    } else if (state is ScheduleLoaded) {
      return FadeTransition(
        opacity: _fadeAnimation,
        child: _buildLoadedContent(context, state, innerContext),
      );
    }
    return const SizedBox.shrink();
  }

  // ==========================================================================
  // 1. APP BAR — Enhanced with quick actions & tooltips
  // ==========================================================================
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PremiumAppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.schedule, color: Colors.white),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              context.l10n.schedule,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      actions: [
        // --- Undo ---
        BlocBuilder<ScheduleBloc, ScheduleState>(
          builder: (context, state) {
            final canUndo = state is ScheduleLoaded && state.canUndo;
            return Tooltip(
              message: canUndo
                  ? context.l10n.undoLastAction
                  : context.l10n.nothingToUndo,
              preferBelow: true,
              child: IconButton(
                icon: const Icon(Icons.undo),
                onPressed: canUndo
                    ? () => context.read<ScheduleBloc>().add(UndoAction())
                    : null,
              ),
            );
          },
        ),
        // --- Quick Generate ---
        Tooltip(
          message: context.l10n.generateSchedule,
          preferBelow: true,
          child: IconButton(
            icon: const Icon(Icons.auto_awesome),
            onPressed: () {
              final bloc = context.read<ScheduleBloc>();
              _openGenerateDialog(context, bloc);
            },
          ),
        ),
        // --- Zoom Reset ---
        Tooltip(
          message: context.l10n.resetZoom,
          preferBelow: true,
          child: IconButton(
            icon: const Icon(Icons.fit_screen),
            onPressed: _resetZoom,
          ),
        ),
        // --- More Menu ---
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_borderRadius)),
          position: PopupMenuPosition.under,
          onSelected: (value) => _handleMenuAction(context, value),
          itemBuilder: (context) => [
            _buildPopupItem(
              value: 'validate',
              icon: Icons.check_circle_outline,
              color: Theme.of(context).colorScheme.secondary,
              label: context.l10n.validate,
            ),
            _buildPopupItem(
              value: 'stats',
              icon: Icons.bar_chart,
              color: Theme.of(context).colorScheme.secondary,
              label: context.l10n.scheduleStats,
            ),
            const PopupMenuDivider(height: 1),
            _buildPopupItem(
              value: 'clear',
              icon: Icons.delete_outline,
              color: Theme.of(context).colorScheme.error,
              label: context.l10n.clearSchedule,
            ),
            const PopupMenuDivider(height: 1),
            _buildPopupItem(
              value: 'pdf',
              icon: Icons.picture_as_pdf,
              color: Theme.of(context).colorScheme.primary,
              label: context.l10n.exportPdf,
            ),
            _buildPopupItem(
              value: 'excel',
              icon: Icons.table_chart,
              color: Colors.green,
              label: context.l10n.exportExcel,
            ),
          ],
        ),
      ],
    );
  }

  PopupMenuItem<String> _buildPopupItem({
    required String value,
    required IconData icon,
    required Color color,
    required String label,
  }) {
    return PopupMenuItem(
      value: value,
      height: 44,
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }

  void _handleMenuAction(BuildContext context, String value) {
    final bloc = context.read<ScheduleBloc>();
    switch (value) {
      case 'validate':
        bloc.add(ValidateSchedule());
        break;
      case 'stats':
        _showStatsDialog(context);
        break;
      case 'clear':
        _confirmClearSchedule(context, bloc);
        break;
      case 'pdf':
        bloc.add(const ExportSchedulePdf());
        break;
      case 'excel':
        bloc.add(const ExportScheduleExcel());
        break;
    }
  }

  void _resetZoom() {
    _transformationController.value = Matrix4.identity();
  }

  // ==========================================================================
  // 2. SHIMMER LOADING — Professional skeleton placeholder
  // ==========================================================================
  Widget _buildShimmerLoading() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey.shade800 : Colors.grey.shade200;
    final highlightColor = isDark ? Colors.grey.shade700 : Colors.grey.shade100;

    return ShimmerEffect(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            // Segmented button placeholder
            _shimmerBox(height: 48, width: double.infinity, radius: 24),
            const SizedBox(height: 12),
            // Dropdown placeholder
            _shimmerBox(height: 56, width: double.infinity, radius: 14),
            const SizedBox(height: 16),
            // Grid header
            Row(
              children: [
                _shimmerBox(height: 40, width: _dayColumnWidth, radius: 8),
                const SizedBox(width: 8),
                ...List.generate(
                  5,
                  (_) => Padding(
                    padding: const EdgeInsetsDirectional.only(end: 8),
                    child:
                        _shimmerBox(height: 40, width: _cellWidth, radius: 8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Grid rows
            ...List.generate(
              5,
              (_) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    _shimmerBox(
                        height: _cellHeight, width: _dayColumnWidth, radius: 12),
                    const SizedBox(width: 8),
                    ...List.generate(
                      5,
                      (_) => Padding(
                        padding: const EdgeInsetsDirectional.only(end: 8),
                        child: _shimmerBox(
                            height: _cellHeight,
                            width: _cellWidth,
                            radius: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _shimmerBox({
    required double height,
    required double width,
    required double radius,
  }) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  // ==========================================================================
  // 3. STATE LISTENER — Snackbars & dialogs
  // ==========================================================================
  void _handleStateListener(BuildContext context, ScheduleState state) {
    if (state is ScheduleError) {
      _showSnackbar(context, state.message, isError: true);
    } else if (state is ScheduleLoaded) {
      if (state.actionSuccess != null) {
        _showSnackbar(context, state.actionSuccess!, isError: false);
      } else if (state.actionError != null) {
        _showSnackbar(context, state.actionError!, isError: true);
      } else if (state.validationResult != null) {
        showDialog(
          context: context,
          builder: (_) =>
              ValidationSummaryDialog(result: state.validationResult!),
        );
      }
    }
  }

  void _showSnackbar(BuildContext context, String message,
      {required bool isError}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(message, maxLines: 1, overflow: TextOverflow.ellipsis)),
          ],
        ),
        backgroundColor:
            isError ? Theme.of(context).colorScheme.error : Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: Duration(seconds: isError ? 5 : 3),
        action: isError
            ? SnackBarAction(
                label: context.l10n.dismiss,
                textColor: Colors.white,
                onPressed: () =>
                    ScaffoldMessenger.of(context).hideCurrentSnackBar(),
              )
            : null,
      ),
    );
  }

  Future<void> _confirmClearSchedule(
      BuildContext context, ScheduleBloc bloc) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_borderRadius)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded,
                color: Theme.of(context).colorScheme.error, size: 28),
            const SizedBox(width: 10),
            Text(context.l10n.clearSchedule, maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
        content: Text(context.l10n.clearScheduleConfirm, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(context.l10n.cancel, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(context.l10n.clear, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
    if (confirmed == true) bloc.add(const ClearSchedule());
  }

  void _showStatsDialog(BuildContext context) {
    final state = context.read<ScheduleBloc>().state;
    if (state is! ScheduleLoaded) return;

    final schedule = state.schedule;
    final totalSessions = schedule.sessions.length;
    final filledSessions =
        schedule.sessions.where((s) => s.id.isNotEmpty).length;
    final emptySessions = totalSessions - filledSessions;
    final uniqueTeachers =
        schedule.sessions.map((s) => s.teacherId).toSet().length;
    final uniqueSubjects =
        schedule.sessions.map((s) => s.subjectId).toSet().length;
    final conflicts = _countConflicts(schedule.sessions);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_borderRadius)),
        title: Row(
          children: [
            const Icon(Icons.bar_chart, color: Colors.teal, size: 28),
            const SizedBox(width: 10),
            Text(context.l10n.scheduleStats, maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
        content: SizedBox(
          width: 360,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _statRow(Icons.event_available, Colors.blue,
                  context.l10n.totalSessions, '$totalSessions'),
              _statRow(Icons.check_circle, Colors.green,
                  context.l10n.filledSessions, '$filledSessions'),
              _statRow(Icons.circle_outlined, Colors.grey,
                  context.l10n.emptySlots, '$emptySessions'),
              _statRow(Icons.person, Colors.purple,
                  context.l10n.uniqueTeachers, '$uniqueTeachers'),
              _statRow(Icons.menu_book, Theme.of(context).colorScheme.secondary,
                  context.l10n.uniqueSubjects, '$uniqueSubjects'),
              _statRow(
                  Icons.warning,
                  conflicts > 0 ? Theme.of(context).colorScheme.error : Colors.green,
                  context.l10n.conflicts,
                  '$conflicts'),
            ],
          ),
        ),
        actions: [
          FilledButton(
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => Navigator.pop(ctx),
            child: Text(context.l10n.ok, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  Widget _statRow(
      IconData icon, Color color, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
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
            child: Text(label, style: const TextStyle(fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
          Text(value,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color), maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  int _countConflicts(List<Session> sessions) {
    var count = 0;
    final grouped = <String, int>{};
    for (final s in sessions) {
      if (s.teacherId.isEmpty) continue;
      final key = '${s.day.index}_${s.sessionNumber}_${s.teacherId}';
      grouped[key] = (grouped[key] ?? 0) + 1;
    }
    for (final v in grouped.values) {
      if (v > 1) count += v - 1;
    }
    return count;
  }

  // ==========================================================================
  // 4. EMPTY STATE — Professional & inviting
  // ==========================================================================
  Widget _buildEmptyState(BuildContext innerContext) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 600),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.scale(scale: value, child: child);
              },
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .primaryColor
                      .withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.calendar_today_outlined,
                  size: 80,
                  color: Theme.of(context).primaryColor.withOpacity(0.5),
                ),
              ),
            ),
            const SizedBox(height: 28),
            Text(
              context.l10n.noActiveSchedule,
              maxLines: 1, overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.noActiveScheduleDesc,
              maxLines: 2, overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              icon: const Icon(Icons.auto_awesome),
              label: Text(context.l10n.generateSchedule, maxLines: 1, overflow: TextOverflow.ellipsis),
              style: FilledButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                textStyle: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () {
                final bloc = innerContext.read<ScheduleBloc>();
                _openGenerateDialog(context, bloc);
              },
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================================
  // 5. LOADED CONTENT — Main layout with view toggle
  // ==========================================================================
  Widget _buildLoadedContent(BuildContext context, ScheduleLoaded state,
      BuildContext innerContext) {
    final classroomNames = state.classroomNames;
    if (classroomNames.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.class_outlined,
                size: 72, color: Theme.of(context).hintColor),
            const SizedBox(height: 16),
            Text(context.l10n.noClassroomsFound,
                style: const TextStyle(fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
      );
    }

    return Column(
      children: [
        // --- View Mode Toggle ---
        _buildViewToggle(context, state),
        // --- Entity Selector Card ---
        _buildEntitySelector(context, state),
        // --- Grid or Placeholder ---
        Expanded(
          child: AnimatedSwitcher(
            duration: _animDuration,
            child: _shouldShowGrid(state)
                ? _buildScheduleGrid(
                    context,
                    state,
                    state.viewMode == 'classroom'
                        ? state.selectedClassroomId!
                        : state.selectedTeacherId!,
                    state.viewMode == 'classroom',
                  )
                : _buildSelectPrompt(state),
          ),
        ),
      ],
    );
  }

  bool _shouldShowGrid(ScheduleLoaded state) {
    return (state.viewMode == 'classroom' &&
            state.selectedClassroomId != null) ||
        (state.viewMode == 'teacher' && state.selectedTeacherId != null);
  }

  Widget _buildSelectPrompt(ScheduleLoaded state) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.touch_app_outlined,
              size: 64, color: Theme.of(context).hintColor),
          const SizedBox(height: 16),
          Text(
            state.viewMode == 'classroom'
                ? context.l10n.pleaseSelectClassroom
                : context.l10n.pleaseSelectTeacher,
            style: const TextStyle(fontSize: 16),
          maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  // ==========================================================================
  // VIEW TOGGLE
  // ==========================================================================
  Widget _buildViewToggle(BuildContext context, ScheduleLoaded state) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: SegmentedButton<String>(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return Theme.of(context).primaryColor;
            }
            return Theme.of(context).colorScheme.surface;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return Colors.white;
            }
            return Theme.of(context).colorScheme.onSurface;
          }),
          shape: WidgetStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12))),
        ),
        segments: [
          ButtonSegment(
            value: 'classroom',
            icon: const Icon(Icons.class_, size: 18),
            label: Text(context.l10n.classroomsLabel, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
          ButtonSegment(
            value: 'teacher',
            icon: const Icon(Icons.person, size: 18),
            label: Text(context.l10n.teachersLabel, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ],
        selected: {state.viewMode},
        onSelectionChanged: (selection) {
          context
              .read<ScheduleBloc>()
              .add(ToggleViewMode(selection.first));
        },
      ),
    );
  }

  // ==========================================================================
  // ENTITY SELECTOR
  // ==========================================================================
  Widget _buildEntitySelector(BuildContext context, ScheduleLoaded state) {
    final isClassroom = state.viewMode == 'classroom';
    final items = isClassroom
        ? state.classroomNames.entries.toList()
        : state.teacherNames.entries.toList();
    final selectedValue =
        isClassroom ? state.selectedClassroomId : state.selectedTeacherId;

    // Safety: ensure selected value exists in items
    final validValue = items.any((e) => e.key == selectedValue)
        ? selectedValue
        : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_borderRadius)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .primaryColor
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isClassroom ? Icons.class_ : Icons.person,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: validValue,
                    isExpanded: true,
                    hint: Text(
                      isClassroom
                          ? context.l10n.appName
                          : context.l10n.appName,
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                    icon: const Icon(Icons.expand_more),
                    style: const TextStyle(fontSize: 15),
                    items: items
                        .map((e) => DropdownMenuItem(
                              value: e.key,
                              child: Text(e.value, maxLines: 1, overflow: TextOverflow.ellipsis),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      context.read<ScheduleBloc>().add(
                            isClassroom
                                ? SelectClassroom(value)
                                : SelectTeacher(value),
                          );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // 6. SCHEDULE GRID — InteractiveViewer with professional table
  // ==========================================================================
  Widget _buildScheduleGrid(BuildContext context, ScheduleLoaded state,
      String selectedId, bool isClassroomView) {
    final dailySessions = state.dailySessions;
    final workDays = state.workDays;
    final totalWidth = _dayColumnWidth + (dailySessions * _cellWidth) + 32;
    final totalHeight =
        _headerHeight + (workDays * _cellHeight) + 16;

    return InteractiveViewer(
      transformationController: _transformationController,
      minScale: 0.4,
      maxScale: 2.5,
      boundaryMargin: const EdgeInsets.all(AppSpacing.xl),
      child: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            constraints: BoxConstraints(
              minWidth: totalWidth,
              minHeight: totalHeight,
            ),
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Card(
              elevation: 3,
              shadowColor: Colors.black.withOpacity(0.08),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(_borderRadius)),
              clipBehavior: Clip.antiAlias,
              child: Table(
                defaultColumnWidth: const FixedColumnWidth(_cellWidth),
                border: TableBorder(
                  horizontalInside: BorderSide(
                      color: Theme.of(context).dividerColor, width: 0.5),
                  verticalInside: BorderSide(
                      color: Theme.of(context).dividerColor, width: 0.5),
                  borderRadius:
                      BorderRadius.circular(_borderRadius),
                ),
                columnWidths: const {
                  0: FixedColumnWidth(_dayColumnWidth),
                },
                children: [
                  // --- Header Row ---
                  TableRow(
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .primaryColor
                          .withOpacity(0.07),
                    ),
                    children: [
                      _buildHeaderCell(context.l10n.appName, isCorner: true),
                      ...List.generate(
                        dailySessions,
                        (i) => _buildHeaderCell(context.l10n.periodLabel('${i + 1}')),
                      ),
                    ],
                  ),
                  // --- Day Rows ---
                  ...List.generate(workDays, (dayIndex) {
                    final day = WorkDay.values[dayIndex];
                    final sessionsForDay = state.schedule.sessions
                        .where((s) => s.day == day)
                        .toList();
                    return TableRow(
                      decoration: BoxDecoration(
                      color: dayIndex.isEven
                          ? Theme.of(context).colorScheme.surfaceContainerLowest
                          : null,
                      ),
                      children: [
                        _buildDayCell(day),
                        ...List.generate(dailySessions, (sessionIdx) {
                          final session = _findSession(
                            sessionsForDay,
                            sessionIdx + 1,
                            selectedId,
                            isClassroomView,
                          );
                          return _buildSessionCell(
                            context,
                            session,
                            state,
                            day,
                            sessionIdx,
                            selectedId,
                            isClassroomView,
                          );
                        }),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Session? _findSession(List<Session> sessions, int sessionNumber,
      String selectedId, bool isClassroomView) {
    try {
      return sessions.firstWhere(
        (s) =>
            s.sessionNumber == sessionNumber &&
            (isClassroomView
                ? s.classId == selectedId
                : s.teacherId == selectedId),
      );
    } catch (_) {
      return null;
    }
  }

  // ==========================================================================
  // HEADER & DAY CELLS
  // ==========================================================================
  Widget _buildHeaderCell(String text, {bool isCorner = false}) {
    return Container(
      height: _headerHeight,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13,
          color: Theme.of(context).primaryColor,
        ),
        textAlign: TextAlign.center,
      maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }

  Widget _buildDayCell(WorkDay day) {
    return Container(
      height: _cellHeight,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Text(
        day.name,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 13,
          color: Theme.of(context).primaryColor.withOpacity(0.85),
        ),
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  // ==========================================================================
  // 7. SESSION CELL — With drag & drop, conflict detection, animations
  // ==========================================================================
  Widget _buildSessionCell(
    BuildContext context,
    Session? session,
    ScheduleLoaded state,
    WorkDay day,
    int sessionIdx,
    String selectedId,
    bool isClassroomView,
  ) {
    final isEmpty = session == null || session.id.isEmpty;
    final hasConflict = !isEmpty &&
        _checkForConflict(
            state.schedule.sessions, day, sessionIdx + 1, session.teacherId);
    final subjectName =
        isEmpty ? '' : (state.subjectNames[session.subjectId] ?? '???');
    final bottomLabel = isEmpty
        ? ''
        : (isClassroomView
            ? (state.teacherNames[session.teacherId] ?? '???')
            : (state.classroomNames[session.classId] ?? '???'));

    return DragTarget<Session>(
      onWillAcceptWithDetails: (details) => details.data.id != session?.id,
      onAcceptWithDetails: (details) {
        final source = details.data;
        if (session != null && session.id.isNotEmpty) {
          context
              .read<ScheduleBloc>()
              .add(SwapSessionsEvent(session1: source, session2: session));
        } else {
          context.read<ScheduleBloc>().add(MoveSessionEvent(
              session: source, newDay: day, newPeriod: sessionIdx + 1));
        }
      },
      builder: (context, candidateData, rejectedData) {
        final isHovered = candidateData.isNotEmpty;

        var cellContent = _buildCellContent(
          context: context,
          isEmpty: isEmpty,
          hasConflict: hasConflict,
          isHovered: isHovered,
          subjectName: subjectName,
          bottomLabel: bottomLabel,
          isClassroomView: isClassroomView,
        );

        if (!isEmpty) {
          return LongPressDraggable<Session>(
            key: ValueKey(session.id),
            data: session,
            hapticFeedbackOnStart: true,
            feedback: Material(
              elevation: 10,
              borderRadius: BorderRadius.circular(_borderRadius),
              child: Container(
                width: _cellWidth,
                height: _cellHeight,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(_borderRadius),
                  border: Border.all(color: AppColors.primary.withOpacity(0.6), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: cellContent,
              ),
            ),
            childWhenDragging: Opacity(
              opacity: 0.25,
              child: cellContent,
            ),
            child: InkWell(
              onTap: () => _showEditDialog(
                context, session, day, sessionIdx, state, selectedId, isClassroomView,
              ),
              borderRadius: BorderRadius.circular(_borderRadius),
              splashColor: Theme.of(context).primaryColor.withOpacity(0.1),
              child: cellContent,
            ),
          );
        }

        return InkWell(
          onTap: () => _showEditDialog(
            context, session, day, sessionIdx, state, selectedId, isClassroomView,
          ),
          borderRadius: BorderRadius.circular(_borderRadius),
          splashColor: Theme.of(context).primaryColor.withOpacity(0.08),
          child: cellContent,
        );
      },
    );
  }

  Widget _buildCellContent({
    required BuildContext context,
    required bool isEmpty,
    required bool hasConflict,
    required bool isHovered,
    required String subjectName,
    required String bottomLabel,
    required bool isClassroomView,
  }) {
    // --- Cell styling ---
    Color bgColor;
    Color borderColor;
    double borderWidth;

    if (isHovered) {
      bgColor = Colors.blue.withOpacity(0.15);
      borderColor = Colors.blue.shade400;
      borderWidth = 2.5;
    } else if (isEmpty) {
      bgColor = Colors.transparent;
      borderColor = Colors.grey.shade300;
      borderWidth = 1;
    } else if (hasConflict) {
      bgColor = Theme.of(context).colorScheme.error;
      borderColor = Theme.of(context).colorScheme.error;
      borderWidth = 2;
    } else {
      bgColor = Colors.blue.shade50.withOpacity(0.5);
      borderColor = Colors.blue.shade200;
      borderWidth = 1;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      width: _cellWidth,
      height: _cellHeight,
      margin: const EdgeInsets.all(AppSpacing.xs),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: borderWidth),
        boxShadow: !isEmpty && !isHovered
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: isEmpty
          ? _buildEmptyCellContent()
          : _buildFilledCellContent(
              context: context,
              subjectName: subjectName,
              bottomLabel: bottomLabel,
              isClassroomView: isClassroomView,
              hasConflict: hasConflict,
            ),
    );
  }

  Widget _buildEmptyCellContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add_circle_outline,
            size: 22, color: Colors.grey.shade400),
        const SizedBox(height: 4),
        Text(
          context.l10n.appName,
          style: TextStyle(fontSize: 9, color: Colors.grey.shade400),
        maxLines: 1, overflow: TextOverflow.ellipsis),
      ],
    );
  }

  Widget _buildFilledCellContent({
    required BuildContext context,
    required String subjectName,
    required String bottomLabel,
    required bool isClassroomView,
    required bool hasConflict,
  }) {
    final textColor =
        hasConflict ? Theme.of(context).colorScheme.error : Colors.blue.shade800;
    final subTextColor =
        hasConflict ? Theme.of(context).colorScheme.error : Colors.grey.shade700;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Conflict badge
        if (hasConflict)
          Container(
            margin: const EdgeInsets.only(bottom: 2),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.error,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.warning, size: 10, color: Theme.of(context).colorScheme.error),
                const SizedBox(width: 3),
                Text(context.l10n.appName,
                    style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.error), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        // Subject name
        Flexible(
          child: Text(
            subjectName,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: textColor,
              height: 1.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 4),
        // Teacher / Classroom
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isClassroomView ? Icons.person_outline : Icons.class_rounded,
              size: 11,
              color: subTextColor,
            ),
            const SizedBox(width: 3),
            Flexible(
              child: Text(
                bottomLabel,
                style: TextStyle(
                  fontSize: 9.5,
                  color: subTextColor,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  bool _checkForConflict(List<Session> sessions, WorkDay day,
      int sessionNumber, String teacherId) {
    if (teacherId.isEmpty) return false;
    return sessions
            .where((s) =>
                s.day == day &&
                s.sessionNumber == sessionNumber &&
                s.teacherId == teacherId)
            .length >
        1;
  }

  // ==========================================================================
  // 8. GENERATE DIALOG — Professional & organized
  // ==========================================================================
  void _openGenerateDialog(BuildContext context, ScheduleBloc bloc) async {
    final classroomRepo = GetIt.I<IClassroomRepository>();
    final allClassrooms = await classroomRepo.getClassrooms();
    if (!context.mounted) return;

    var selectedClasses = allClassrooms.map((c) => c.id).toList();
    var selectedMode = GenerationMode.balanced;
    var maxRetries = 3;
    int? maxTeacherDailySessions;
    var isGenerating = false;

    await showDialog(
      context: context,
      barrierDismissible: !isGenerating,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(_borderRadius)),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: Theme.of(ctx).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.auto_awesome,
                        color: Theme.of(ctx).primaryColor, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Text(context.l10n.appName, maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
              content: SizedBox(
                width: 520,
                child: ListView(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    // --- Classroom Selection ---
                    _dialogSectionTitle(
                        ctx, Icons.class_, context.l10n.appName),
                    CheckboxListTile(
                      contentPadding: const EdgeInsetsDirectional.only(start: 8),
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(context.l10n.appName, maxLines: 1, overflow: TextOverflow.ellipsis),
                      value: selectedClasses.length ==
                          allClassrooms.length,
                      onChanged: (val) {
                        setDialogState(() {
                          selectedClasses = val == true
                              ? allClassrooms.map((c) => c.id).toList()
                              : [];
                        });
                      },
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    ...allClassrooms.map(
                      (c) => CheckboxListTile(
                        contentPadding: const EdgeInsetsDirectional.only(start: 8),
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text('${c.name} - ${c.section}', maxLines: 1, overflow: TextOverflow.ellipsis),
                        value: selectedClasses.contains(c.id),
                        onChanged: (val) {
                          setDialogState(() {
                            if (val == true) {
                              selectedClasses.add(c.id);
                            } else {
                              selectedClasses.remove(c.id);
                            }
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    // --- Generation Mode ---
                    _dialogSectionTitle(
                        ctx, Icons.tune, context.l10n.appName),
                    ...GenerationMode.values.map(
                      (mode) => RadioListTile<GenerationMode>(
                        contentPadding: const EdgeInsetsDirectional.only(start: 8),
                        title: Text(mode.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                        subtitle: Text(mode.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                        value: mode,
                        groupValue: selectedMode,
                        onChanged: (val) {
                          setDialogState(() => selectedMode = val!);
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    // --- Advanced Settings ---
                    _dialogSectionTitle(
                        ctx, Icons.settings_outlined, context.l10n.appName),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: maxRetries.toString(),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              labelText: context.l10n.appName,
                              border: const OutlineInputBorder(),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 14),
                            ),
                            onChanged: (val) =>
                                maxRetries = int.tryParse(val) ?? 3,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              labelText: context.l10n.appName,
                              border: const OutlineInputBorder(),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 14),
                            ),
                            onChanged: (val) =>
                                maxTeacherDailySessions = int.tryParse(val),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isGenerating
                      ? null
                      : () => Navigator.pop(dialogContext),
                  child: Text(context.l10n.appName, maxLines: 1, overflow: TextOverflow.ellipsis),
                ),
                FilledButton.icon(
                  icon: isGenerating
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.auto_awesome, size: 20),
                  label: Text(isGenerating
                      ? context.l10n.appName
                      : context.l10n.appName, maxLines: 1, overflow: TextOverflow.ellipsis),
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                  onPressed: selectedClasses.isEmpty
                      ? null
                      : () {
                          setDialogState(() => isGenerating = true);
                          bloc.add(GenerateSchedule(
                            mode: selectedMode,
                            targetClassroomIds: selectedClasses,
                            maxRetries: maxRetries,
                            maxTeacherDailySessions:
                                maxTeacherDailySessions,
                          ));
                          Navigator.pop(dialogContext);
                        },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _dialogSectionTitle(
      BuildContext ctx, IconData icon, String title) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: Theme.of(ctx).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child:
              Icon(icon, size: 16, color: Theme.of(ctx).primaryColor),
        ),
        const SizedBox(width: 10),
        Text(title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Theme.of(ctx).primaryColor), maxLines: 1, overflow: TextOverflow.ellipsis),
      ],
    );
  }

  // ==========================================================================
  // 9. EDIT DIALOG — Delegated to SessionEditDialog widget
  // ==========================================================================
  Future<void> _showEditDialog(
    BuildContext context,
    Session? session,
    WorkDay day,
    int sessionIdx,
    ScheduleLoaded state,
    String selectedId,
    bool isClassroomView,
  ) async {
    final teacherRepo = GetIt.I<ITeacherRepository>();
    final subjectRepo = GetIt.I<ISubjectRepository>();
    final classroomRepo = GetIt.I<IClassroomRepository>();

    final results = await Future.wait([
      teacherRepo.getTeachers(),
      subjectRepo.getSubjects(),
      classroomRepo.getClassrooms(),
    ]);

    if (!context.mounted) return;

    final teachers = results[0] as List<Teacher>;
    final subjects = results[1] as List<Subject>;
    final classrooms = results[2] as List<Classroom>;

    final result = await showDialog(
      context: context,
      builder: (ctx) => SessionEditDialog(
        currentSession:
            session != null && session.id.isNotEmpty ? session : null,
        day: day,
        sessionNumber: sessionIdx + 1,
        classId: isClassroomView
            ? selectedId
            : (session != null && session.id.isNotEmpty
                ? session.classId
                : ''),
        teachers: teachers,
        subjects: subjects,
        classrooms: classrooms,
        schedule: state.schedule,
        dailySessions: state.dailySessions,
        workDays: state.workDays,
      ),
    );

    if (result != null && context.mounted) {
      if (result == 'delete' && session != null && session.id.isNotEmpty) {
        context
            .read<ScheduleBloc>()
            .add(DeleteSession(session.id, state.schedule.id));
      } else if (result is Session) {
        context
            .read<ScheduleBloc>()
            .add(UpdateSession(result, state.schedule.id));
      }
    }
  }
}

// ============================================================================
// SHIMMER EFFECT WIDGET — Professional loading skeleton
// ============================================================================
class ShimmerEffect extends StatefulWidget {
  final Widget child;
  final Color baseColor;
  final Color highlightColor;

  const ShimmerEffect({
    super.key,
    required this.child,
    required this.baseColor,
    required this.highlightColor,
  });

  @override
  State<ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _animation = Tween<double>(begin: -1, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
              ],
              stops: [
                _animation.value - 0.3,
                _animation.value,
                _animation.value + 0.3,
              ],
              begin: AlignmentDirectional.centerStart,
              end: AlignmentDirectional.centerEnd,
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
