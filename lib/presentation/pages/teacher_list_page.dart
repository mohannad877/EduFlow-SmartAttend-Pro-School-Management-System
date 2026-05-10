import 'package:flutter/material.dart';
import 'package:school_schedule_app/core/utils/l10n_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:school_schedule_app/domain/entities/enums.dart';
import 'package:school_schedule_app/presentation/bloc/teacher/teacher_bloc.dart';
import 'package:school_schedule_app/presentation/bloc/teacher/teacher_event.dart';
import 'package:school_schedule_app/presentation/bloc/teacher/teacher_state.dart';
import 'teacher_form_page.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:school_schedule_app/core/widgets/premium_app_bar.dart';
import 'package:school_schedule_app/core/widgets/premium_empty_state.dart';

import 'package:school_schedule_app/core/theme/app_spacing.dart';
import 'package:school_schedule_app/core/theme/app_colors.dart';

class TeacherListPage extends StatelessWidget {
  const TeacherListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<TeacherBloc>()..add(LoadTeachers()),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: PremiumAppBar(
              title: Text(context.l10n.teachers,
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              centerTitle: true,
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                final bloc = context.read<TeacherBloc>();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TeacherFormPage()),
                ).then((_) {
                  if (context.mounted) bloc.add(LoadTeachers());
                });
              },
              child: const Icon(Icons.add),
            ).animate().scale(),
            body: BlocConsumer<TeacherBloc, TeacherState>(
              listener: (context, state) {
                if (state is TeacherOperationSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(state.message,
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                      backgroundColor: AppColors.success));
                } else if (state is TeacherError) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(state.message,
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                      backgroundColor: Theme.of(context).colorScheme.error));
                }
              },
              builder: (context, state) {
                if (state is TeacherLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is TeacherError) {
                  return Center(
                      child: Text(state.message,
                          maxLines: 1, overflow: TextOverflow.ellipsis));
                }
                if (state is TeachersLoaded) {
                  if (state.teachers.isEmpty) {
                    return PremiumEmptyState(
                      title: context.l10n.noTeachersLabel,
                      description: context.l10n.addTeachersStartDesc,
                      icon: Icons.person_off_rounded,
                      actionLabel: context.l10n.addTeacherAction,
                      onAction: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const TeacherFormPage()))
                          .then((_) {
                        if (context.mounted) {
                          context.read<TeacherBloc>().add(LoadTeachers());
                        }
                      }),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsetsDirectional.only(
                      start: 16,
                      end: 16, // بدلاً من right
                      top: 16,
                      bottom: 90,
                    ),
                    itemCount: state.teachers.length,
                    itemBuilder: (context, index) {
                      final teacher = state.teachers[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                                color: Theme.of(context)
                                    .shadowColor
                                    .withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4))
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(AppSpacing.md),
                          leading: CircleAvatar(
                            radius: 28,
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.1),
                            child: Icon(Icons.person,
                                color: Theme.of(context).colorScheme.primary,
                                size: 28),
                          ),
                          title: Text(teacher.fullName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: AppSpacing.xs),
                              Text(teacher.specialization,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.color)),
                              const SizedBox(height: AppSpacing.xs),
                              Wrap(
                                spacing: 4,
                                children: teacher.workDays
                                    .map((d) => Chip(
                                          label: Text(d.getArabicName(context),
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimaryContainer),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis),
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .primaryContainer,
                                          padding: EdgeInsets.zero,
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                        ))
                                    .toList(),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit_rounded,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                                onPressed: () {
                                  final bloc = context.read<TeacherBloc>();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => TeacherFormPage(
                                              teacher: teacher))).then((_) {
                                    if (context.mounted) {
                                      bloc.add(LoadTeachers());
                                    }
                                  });
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete_rounded,
                                    color: Theme.of(context).colorScheme.error),
                                onPressed: () {
                                  _confirmDelete(
                                    context: context,
                                    name: teacher.fullName,
                                    onConfirm: () => context
                                        .read<TeacherBloc>()
                                        .add(DeleteTeacher(teacher.id)),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      )
                          .animate()
                          .fadeIn(delay: Duration(milliseconds: 50 * index))
                          .slideX();
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          );
        },
      ),
    );
  }

  void _confirmDelete(
      {required BuildContext context,
      required String name,
      required VoidCallback onConfirm}) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(context.l10n.confirmDelete,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.error),
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
        content: Text(context.l10n.confirmDeleteName(name),
            maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(context.l10n.cancel,
                  maxLines: 1, overflow: TextOverflow.ellipsis)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error),
            onPressed: () {
              Navigator.pop(dialogContext);
              onConfirm();
            },
            child: Text(context.l10n.delete,
                style: TextStyle(color: Theme.of(context).colorScheme.onError),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}
