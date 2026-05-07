import 'package:school_schedule_app/core/utils/l10n_extension.dart';
import 'package:school_schedule_app/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:school_schedule_app/core/theme/app_colors.dart';
import 'package:school_schedule_app/core/theme/app_text_styles.dart';
import 'package:school_schedule_app/core/database/attendance_providers.dart';
import 'package:school_schedule_app/core/utils/app_widgets.dart';

/// شاشة إدارة الصفوف والمراحل
class GradesManagementScreen extends ConsumerStatefulWidget {
  const GradesManagementScreen({super.key});

  @override
  ConsumerState<GradesManagementScreen> createState() => _GradesManagementScreenState();
}

class _GradesManagementScreenState extends ConsumerState<GradesManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<AttStage> _stages = [];
  List<AttGrade> _grades = [];
  List<AttSection> _sections = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final db = ref.read(attendanceDatabaseProvider);
    final stages = await db.select(db.attStages).get();
    final grades = await db.select(db.attGrades).get();
    final sections = await db.select(db.attSections).get();
    if (mounted) {
      setState(() {
        _stages = stages;
        _grades = grades;
        _sections = sections;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.gradeName, maxLines: 1, overflow: TextOverflow.ellipsis),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelStyle: AppTextStyles.button.copyWith(color: Colors.white),
          unselectedLabelStyle: AppTextStyles.body2.copyWith(color: Colors.white70),
          indicatorColor: Colors.white,
          tabs: [
            Tab(text: context.l10n.gradeAdded),
            Tab(text: context.l10n.classLevel),
            Tab(text: context.l10n.sections),
          ],
        ),
      ),
      body: _isLoading
          ? LoadingIndicator(message: context.l10n.operationCancelled)
          : TabBarView(
              controller: _tabController,
              children: [
                _StagesTab(stages: _stages, onRefresh: _loadData),
                _GradesTab(stages: _stages, grades: _grades, onRefresh: _loadData),
                _SectionsTab(grades: _grades, sections: _sections, onRefresh: _loadData),
              ],
            ),
    );
  }
}

/// تبويب المراحل التعليمية
class _StagesTab extends ConsumerWidget {
  final List<AttStage> stages;
  final VoidCallback onRefresh;

  const _StagesTab({required this.stages, required this.onRefresh});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: ElevatedButton.icon(
            onPressed: () => _showAddStageDialog(context, ref),
            icon: const Icon(Icons.add_rounded),
            label: Text(context.l10n.gradeUpdated, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ),
        Expanded(
          child: stages.isEmpty
              ? EmptyStateWidget(
                  icon: Icons.school_outlined,
                  title: context.l10n.gradeDeleted,
                  subtitle: context.l10n.selectGradeDelete,
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: stages.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (ctx, i) {
                    final stage = stages[i];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                          child: Text(
                            '${i + 1}',
                            style: AppTextStyles.subtitle1.copyWith(color: AppColors.primary),
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                        ),
                        title: Text(stage.name, style: AppTextStyles.subtitle1, maxLines: 1, overflow: TextOverflow.ellipsis),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit_outlined, size: 20),
                              color: AppColors.primary,
                              onPressed: () => _showEditStageDialog(context, ref, stage),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, size: 20),
                              color: Theme.of(context).colorScheme.error,
                              onPressed: () => _deleteStage(context, ref, stage),
                            ),
                          ],
                        ),
                      ),
                    ).animate(delay: Duration(milliseconds: i * 50)).fadeIn(duration: 200.ms);
                  },
                ),
        ),
      ],
    );
  }

  void _showAddStageDialog(BuildContext context, WidgetRef ref) {
    _showStageDialog(context, ref, null);
  }

  void _showEditStageDialog(BuildContext context, WidgetRef ref, AttStage stage) {
    _showStageDialog(context, ref, stage);
  }

  void _showStageDialog(BuildContext context, WidgetRef ref, AttStage? stage) {
    final ctrl = TextEditingController(text: stage?.name ?? '');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(stage == null ? context.l10n.confirmDeleteGrade : context.l10n.addGrade, style: AppTextStyles.headline6, maxLines: 1, overflow: TextOverflow.ellipsis),
        content: TextField(
          controller: ctrl,
          decoration: InputDecoration(labelText: context.l10n.editGrade),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(context.l10n.cancel, maxLines: 1, overflow: TextOverflow.ellipsis)),
          ElevatedButton(
            onPressed: () async {
              if (ctrl.text.trim().isEmpty) return;
              final db = ref.read(attendanceDatabaseProvider);
              if (stage == null) {
                await db.into(db.attStages).insert(AttStagesCompanion.insert(name: ctrl.text.trim()));
              } else {
                await db.update(db.attStages).replace(stage.copyWith(name: ctrl.text.trim()));
              }
              if (ctx.mounted) Navigator.pop(ctx);
              onRefresh();
            },
            child: Text(context.l10n.save, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteStage(BuildContext context, WidgetRef ref, AttStage stage) async {
    final ok = await ConfirmDialog.show(
      context,
      title: context.l10n.deleteGrade,
      message: 'هل تريد حذف مرحلة "${stage.name}"؟',
      confirmLabel: context.l10n.delete,
      confirmColor: Theme.of(context).colorScheme.error,
      icon: Icons.delete_outline,
    );
    if (ok == true) {
      final db = ref.read(attendanceDatabaseProvider);
      await (db.delete(db.attStages)..where((s) => s.id.equals(stage.id))).go();
      onRefresh();
    }
  }
}

/// تبويب الصفوف
class _GradesTab extends ConsumerWidget {
  final List<AttStage> stages;
  final List<AttGrade> grades;
  final VoidCallback onRefresh;

  const _GradesTab({required this.stages, required this.grades, required this.onRefresh});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: ElevatedButton.icon(
            onPressed: stages.isEmpty
                ? null
                : () => _showAddGradeDialog(context, ref),
            icon: const Icon(Icons.add_rounded),
            label: Text(context.l10n.enterGradeName, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ),
        if (stages.isEmpty)
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Text(
              context.l10n.sectionName,
              style: const TextStyle(fontFamily: 'Cairo'),
            maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        Expanded(
          child: grades.isEmpty
              ? EmptyStateWidget(icon: Icons.class_outlined, title: context.l10n.sectionAdded)
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: grades.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (ctx, i) {
                    final grade = grades[i];
                    final stageName = stages.where((s) => s.id == grade.stageId).firstOrNull?.name ?? '—';
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.secondary.withOpacity(0.1),
                          child: const Icon(Icons.class_outlined, color: AppColors.secondary),
                        ),
                        title: Text(grade.name, style: AppTextStyles.subtitle1, maxLines: 1, overflow: TextOverflow.ellipsis),
                        subtitle: Text(stageName, style: AppTextStyles.body2, maxLines: 1, overflow: TextOverflow.ellipsis),
                        trailing: IconButton(
                          icon: Icon(Icons.delete_outline, size: 20, color: Theme.of(context).colorScheme.error),
                          onPressed: () async {
                            final ok = await ConfirmDialog.show(context, title: context.l10n.sectionUpdated, message: 'حذف "${grade.name}"؟', confirmColor: Theme.of(context).colorScheme.error);
                            if (ok == true) {
                              final db = ref.read(attendanceDatabaseProvider);
                              await (db.delete(db.attGrades)..where((g) => g.id.equals(grade.id))).go();
                              onRefresh();
                            }
                          },
                        ),
                      ),
                    ).animate(delay: Duration(milliseconds: i * 50)).fadeIn(duration: 200.ms);
                  },
                ),
        ),
      ],
    );
  }

  void _showAddGradeDialog(BuildContext context, WidgetRef ref) {
    final ctrl = TextEditingController();
    AttStage? selectedStage;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setStateDialog) => AlertDialog(
          title: Text(context.l10n.enterGradeName, style: AppTextStyles.headline6, maxLines: 1, overflow: TextOverflow.ellipsis),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<AttStage>(
                hint: Text(context.l10n.sectionDeleted, maxLines: 1, overflow: TextOverflow.ellipsis),
                value: selectedStage,
                items: stages.map((s) => DropdownMenuItem(value: s, child: Text(s.name, maxLines: 1, overflow: TextOverflow.ellipsis))).toList(),
                onChanged: (v) => setStateDialog(() => selectedStage = v),
                decoration: InputDecoration(labelText: context.l10n.school),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: ctrl,
                decoration: InputDecoration(labelText: context.l10n.classroomName),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: Text(context.l10n.cancel, maxLines: 1, overflow: TextOverflow.ellipsis)),
            ElevatedButton(
              onPressed: () async {
                if (ctrl.text.trim().isEmpty || selectedStage == null) return;
                final db = ref.read(attendanceDatabaseProvider);
                await db.into(db.attGrades).insert(AttGradesCompanion.insert(
                  name: ctrl.text.trim(),
                  stageId: selectedStage!.id,
                ));
                if (ctx.mounted) Navigator.pop(ctx);
                onRefresh();
              },
              child: Text(context.l10n.add, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}

/// تبويب الشعب
class _SectionsTab extends ConsumerWidget {
  final List<AttGrade> grades;
  final List<AttSection> sections;
  final VoidCallback onRefresh;

  const _SectionsTab({required this.grades, required this.sections, required this.onRefresh});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: ElevatedButton.icon(
            onPressed: grades.isEmpty ? null : () => _showAddSectionDialog(context, ref),
            icon: const Icon(Icons.add_rounded),
            label: Text(context.l10n.deleteSection, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ),
        Expanded(
          child: sections.isEmpty
              ? EmptyStateWidget(icon: Icons.groups_outlined, title: context.l10n.confirmDeleteSection)
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: sections.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (ctx, i) {
                    final section = sections[i];
                    final gradeName = grades.where((g) => g.id == section.gradeId).firstOrNull?.name ?? '—';
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                          child: Text(section.name, style: AppTextStyles.subtitle1.copyWith(color: Theme.of(context).colorScheme.secondary), maxLines: 1, overflow: TextOverflow.ellipsis),
                        ),
                        title: Text(context.l10n.addSection, style: AppTextStyles.subtitle1, maxLines: 1, overflow: TextOverflow.ellipsis),
                        subtitle: Text(gradeName, style: AppTextStyles.body2, maxLines: 1, overflow: TextOverflow.ellipsis),
                        trailing: IconButton(
                          icon: Icon(Icons.delete_outline, size: 20, color: Theme.of(context).colorScheme.error),
                          onPressed: () async {
                            final ok = await ConfirmDialog.show(context, title: context.l10n.deleteSection2, message: 'حذف شعبة "${section.name}"؟', confirmColor: Theme.of(context).colorScheme.error);
                            if (ok == true) {
                              final db = ref.read(attendanceDatabaseProvider);
                              await (db.delete(db.attSections)..where((s) => s.id.equals(section.id))).go();
                              onRefresh();
                            }
                          },
                        ),
                      ),
                    ).animate(delay: Duration(milliseconds: i * 50)).fadeIn(duration: 200.ms);
                  },
                ),
        ),
      ],
    );
  }

  void _showAddSectionDialog(BuildContext context, WidgetRef ref) {
    final ctrl = TextEditingController();
    AttGrade? selectedGrade;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setStateDialog) => AlertDialog(
          title: Text(context.l10n.deleteSection, style: AppTextStyles.headline6, maxLines: 1, overflow: TextOverflow.ellipsis),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<AttGrade>(
                hint: Text(context.l10n.selectSchool, maxLines: 1, overflow: TextOverflow.ellipsis),
                value: selectedGrade,
                items: grades.map((g) => DropdownMenuItem(value: g, child: Text(g.name, maxLines: 1, overflow: TextOverflow.ellipsis))).toList(),
                onChanged: (v) => setStateDialog(() => selectedGrade = v),
                decoration: InputDecoration(labelText: context.l10n.grade),
              ),
              const SizedBox(height: 12),
              TextField(controller: ctrl, decoration: InputDecoration(labelText: context.l10n.sectionNameField)),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: Text(context.l10n.cancel, maxLines: 1, overflow: TextOverflow.ellipsis)),
            ElevatedButton(
              onPressed: () async {
                if (ctrl.text.trim().isEmpty || selectedGrade == null) return;
                final db = ref.read(attendanceDatabaseProvider);
                await db.into(db.attSections).insert(AttSectionsCompanion.insert(
                  name: ctrl.text.trim(),
                  gradeId: selectedGrade!.id,
                ));
                if (ctx.mounted) Navigator.pop(ctx);
                onRefresh();
              },
              child: Text(context.l10n.add, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}
