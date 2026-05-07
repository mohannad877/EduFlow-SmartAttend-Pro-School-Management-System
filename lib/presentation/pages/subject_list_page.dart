import 'package:flutter/material.dart';
import 'package:school_schedule_app/core/utils/l10n_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:school_schedule_app/presentation/bloc/subject/subject_bloc.dart';
import 'package:school_schedule_app/presentation/bloc/subject/subject_event.dart';
import 'package:school_schedule_app/presentation/bloc/subject/subject_state.dart';
import 'subject_form_page.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:school_schedule_app/core/widgets/premium_app_bar.dart';
import 'package:school_schedule_app/core/widgets/premium_empty_state.dart';
import 'package:school_schedule_app/core/theme/app_colors.dart';
import 'package:school_schedule_app/core/theme/app_spacing.dart';


class SubjectListPage extends StatelessWidget {
  const SubjectListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<SubjectBloc>()..add(LoadSubjects()),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: PremiumAppBar(
              title: Text(context.l10n.subjects, maxLines: 1, overflow: TextOverflow.ellipsis),
              centerTitle: true,
            ),
            floatingActionButton: FloatingActionButton.extended(
              backgroundColor: Theme.of(context).colorScheme.primary,
              onPressed: () {
                final bloc = context.read<SubjectBloc>();
                Navigator.push(context, MaterialPageRoute(builder: (_) => const SubjectFormPage())).then((_) {
                  if (context.mounted) bloc.add(LoadSubjects());
                });
              },
              icon: Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimary),
              label: Text(context.l10n.addSubject, style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
            ).animate().scale(),
            body: BlocConsumer<SubjectBloc, SubjectState>(
              listener: (context, state) {
                if (state is SubjectOperationSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message, maxLines: 1, overflow: TextOverflow.ellipsis), backgroundColor: AppColors.success));
                } else if (state is SubjectError) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message, maxLines: 1, overflow: TextOverflow.ellipsis), backgroundColor: Theme.of(context).colorScheme.error));
              },
              builder: (context, state) {
                if (state is SubjectLoading) return const Center(child: CircularProgressIndicator());
                if (state is SubjectError) return Center(child: Text(state.message, maxLines: 1, overflow: TextOverflow.ellipsis));
                if (state is SubjectLoaded) {
                  if (state.subjects.isEmpty) {
                    return PremiumEmptyState(
                      title: context.l10n.noSubjectsLabel,
                      description: context.l10n.addSubjectsStartDesc,
                      icon: Icons.menu_book_rounded,
                      actionLabel: context.l10n.addSubject,
                      onAction: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SubjectFormPage())).then((_) { if (context.mounted) context.read<SubjectBloc>().add(LoadSubjects()); }),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsetsDirectional.only(start: 16, end: 16, top: 16, bottom: 90),
                    itemCount: state.subjects.length,
                    itemBuilder: (context, index) {
                      final subject = state.subjects[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [BoxShadow(color: Theme.of(context).shadowColor.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(AppSpacing.md),
                          leading: CircleAvatar(
                            radius: 26,
                            backgroundColor: subject.requiresLab ? Theme.of(context).colorScheme.secondary.withOpacity(0.1) : Theme.of(context).colorScheme.primary.withOpacity(0.1),
                            child: Icon(subject.requiresLab ? Icons.science : Icons.book, color: subject.requiresLab ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.primary),
                          ),
                          title: Text(subject.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Row(
                              children: [
                                Icon(Icons.access_time, size: 16, color: Theme.of(context).colorScheme.outline),
                                const SizedBox(width: AppSpacing.xs),
                                Expanded(child: Text(context.l10n.totalPeriodsCount(subject.classPeriods.values.fold(0, (sum, val) => (sum) + val).toString()), maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color))),
                                if (subject.requiresLab) ...[
                                  const SizedBox(width: 8),
                                  Icon(Icons.warning_amber_rounded, size: 16, color: Theme.of(context).colorScheme.secondary),
                                  const SizedBox(width: 4),
                                  Text(context.l10n.requiresLab, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
                                ]
                              ],
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit_rounded, color: Theme.of(context).colorScheme.primary),
                                onPressed: () {
                                  final bloc = context.read<SubjectBloc>();
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => SubjectFormPage(subject: subject)))
                                      .then((_) { if (context.mounted) bloc.add(LoadSubjects()); });
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete_rounded, color: Theme.of(context).colorScheme.error),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                      title: Text(context.l10n.confirmDelete, style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.error), maxLines: 1, overflow: TextOverflow.ellipsis),
                                      content: Text(context.l10n.confirmDeleteName(subject.name), maxLines: 1, overflow: TextOverflow.ellipsis),
                                      actions: [
                                        TextButton(onPressed: () => Navigator.pop(ctx), child: Text(context.l10n.cancel, maxLines: 1, overflow: TextOverflow.ellipsis)),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
                                          onPressed: () { Navigator.pop(ctx); context.read<SubjectBloc>().add(DeleteSubject(subject.id)); },
                                          child: Text(context.l10n.delete, style: TextStyle(color: Theme.of(context).colorScheme.onError), maxLines: 1, overflow: TextOverflow.ellipsis),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ).animate().fadeIn(delay: Duration(milliseconds: 50 * index)).slideX();
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
}
