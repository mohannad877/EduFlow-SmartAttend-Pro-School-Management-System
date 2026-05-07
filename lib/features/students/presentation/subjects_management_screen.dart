import 'package:school_schedule_app/core/utils/l10n_extension.dart';
import 'package:school_schedule_app/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:school_schedule_app/core/widgets/premium_app_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:school_schedule_app/core/theme/app_colors.dart';
import 'package:school_schedule_app/core/theme/app_text_styles.dart';
import 'package:school_schedule_app/core/database/attendance_providers.dart';
import 'package:school_schedule_app/core/utils/app_widgets.dart';

/// شاشة إدارة المواد الدراسية (للحضور)
class SubjectsManagementScreen extends ConsumerStatefulWidget {
  const SubjectsManagementScreen({super.key});

  @override
  ConsumerState<SubjectsManagementScreen> createState() =>
      _SubjectsManagementScreenState();
}

class _SubjectsManagementScreenState
    extends ConsumerState<SubjectsManagementScreen> {
  List<AttGrade> _grades = [];
  List<AttSubject> _subjects = [];
  int? _selectedGradeId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final db = ref.read(attendanceDatabaseProvider);
    final grades = await db.select(db.attGrades).get();
    var subjects = <AttSubject>[];
    if (_selectedGradeId != null) {
      subjects = await (db.select(db.attSubjects)
            ..where((s) => s.gradeId.equals(_selectedGradeId!)))
          .get();
    } else {
      subjects = await db.select(db.attSubjects).get();
    }
    if (mounted) {
      setState(() {
        _grades = grades;
        _subjects = subjects;
        _isLoading = false;
      });
    }
  }

  Future<void> _showAddSubjectDialog() async {
    final ctrl = TextEditingController();
    var selected = _grades.where((g) => g.id == _selectedGradeId).firstOrNull;

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlg) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(context.l10n.auto_key_1805, style: AppTextStyles.headline6, maxLines: 1, overflow: TextOverflow.ellipsis),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<AttGrade>(
                value: selected,
                hint: Text(context.l10n.selectSchool, maxLines: 1, overflow: TextOverflow.ellipsis),
                items: _grades
                    .map((g) => DropdownMenuItem(value: g, child: Text(g.name, maxLines: 1, overflow: TextOverflow.ellipsis)))
                    .toList(),
                onChanged: (v) => setDlg(() => selected = v),
                decoration: InputDecoration(labelText: context.l10n.grade),
                isExpanded: true,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: ctrl,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: context.l10n.subjectName,
                  hintText: context.l10n.auto_key_1806,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(context.l10n.cancel, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
            ElevatedButton(
              onPressed: () async {
                if (ctrl.text.trim().isEmpty || selected == null) return;
                final db = ref.read(attendanceDatabaseProvider);
                await db.into(db.attSubjects).insert(
                      AttSubjectsCompanion.insert(
                        name: ctrl.text.trim(),
                        gradeId: selected!.id,
                      ),
                    );
                if (ctx.mounted) Navigator.pop(ctx);
                _loadData();
              },
              child: Text(context.l10n.add, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _editSubject(AttSubject subject) async {
    final ctrl = TextEditingController(text: subject.name);
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(context.l10n.auto_key_1807, style: AppTextStyles.headline6, maxLines: 1, overflow: TextOverflow.ellipsis),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: InputDecoration(labelText: context.l10n.subjectName),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(context.l10n.cancel, maxLines: 1, overflow: TextOverflow.ellipsis)),
          ElevatedButton(
            onPressed: () async {
              if (ctrl.text.trim().isEmpty) return;
              final db = ref.read(attendanceDatabaseProvider);
              await db.update(db.attSubjects).replace(
                    subject.copyWith(name: ctrl.text.trim()),
                  );
              if (ctx.mounted) Navigator.pop(ctx);
              _loadData();
            },
            child: Text(context.l10n.save, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteSubject(AttSubject subject) async {
    final ok = await ConfirmDialog.show(
      context,
      title: context.l10n.auto_key_1808,
      message: 'هل تريد حذف مادة "${subject.name}"؟',
      confirmLabel: context.l10n.delete,
      confirmColor: Theme.of(context).colorScheme.error,
      icon: Icons.delete_outline,
    );
    if (ok == true) {
      final db = ref.read(attendanceDatabaseProvider);
      await (db.delete(db.attSubjects)
            ..where((s) => s.id.equals(subject.id)))
          .go();
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PremiumAppBar(
        title: Text(context.l10n.auto_key_1809, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: _grades.isEmpty ? null : _showAddSubjectDialog,
            tooltip: context.l10n.addSubject,
          ),
        ],
      ),
      body: Column(
        children: [
          // Grade filter
          if (_grades.isNotEmpty)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    FilterChip(
                      label: Text(context.l10n.invalidEmail, maxLines: 1, overflow: TextOverflow.ellipsis),
                      selected: _selectedGradeId == null,
                      onSelected: (_) {
                        setState(() => _selectedGradeId = null);
                        _loadData();
                      },
                      selectedColor: AppColors.primary.withOpacity(0.15),
                      checkmarkColor: AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    ..._grades.map((g) => Padding(
                          padding: const EdgeInsetsDirectional.only(end: 8),
                          child: FilterChip(
                            label: Text(g.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                            selected: _selectedGradeId == g.id,
                            onSelected: (_) {
                              setState(() => _selectedGradeId = g.id);
                              _loadData();
                            },
                            selectedColor: AppColors.primary.withOpacity(0.15),
                            checkmarkColor: AppColors.primary,
                          ),
                        )),
                  ],
                ),
              ),
            ),

          // List
          Expanded(
            child: _isLoading
                ? LoadingIndicator(message: context.l10n.auto_key_1810)
                : _subjects.isEmpty
                    ? EmptyStateWidget(
                        icon: Icons.book_outlined,
                        title: context.l10n.noSubjectsFound,
                        subtitle: context.l10n.auto_key_1811,
                        actionLabel: context.l10n.addSubject,
                        onAction: _grades.isEmpty ? null : _showAddSubjectDialog,
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        itemCount: _subjects.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (ctx, i) {
                          final sub = _subjects[i];
                          final gradeName = _grades
                              .where((g) => g.id == sub.gradeId)
                              .firstOrNull
                              ?.name ??
                              '—';
                          return Card(
                            child: ListTile(
                              leading: Container(
                                padding: const EdgeInsets.all(AppSpacing.sm),
                                decoration: BoxDecoration(
                                  color: AppColors.secondary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.menu_book_rounded,
                                  color: AppColors.secondary,
                                  size: 22,
                                ),
                              ),
                              title: Text(sub.name, style: AppTextStyles.subtitle1, maxLines: 1, overflow: TextOverflow.ellipsis),
                              subtitle: Text(gradeName, style: AppTextStyles.body2, maxLines: 1, overflow: TextOverflow.ellipsis),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit_outlined,
                                      size: 20,
                                      color: AppColors.primary,
                                    ),
                                    onPressed: () => _editSubject(sub),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete_outline,
                                      size: 20,
                                      color: Theme.of(context).colorScheme.error,
                                    ),
                                    onPressed: () => _deleteSubject(sub),
                                  ),
                                ],
                              ),
                            ),
                          ).animate(delay: Duration(milliseconds: i * 40)).fadeIn(duration: 200.ms);
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _grades.isEmpty ? null : _showAddSubjectDialog,
        backgroundColor: _grades.isEmpty ? Colors.grey : AppColors.primary,
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}
