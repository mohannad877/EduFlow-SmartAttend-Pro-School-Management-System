import 'package:school_schedule_app/core/utils/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:school_schedule_app/presentation/bloc/classroom/classroom_bloc.dart';
import 'package:school_schedule_app/presentation/bloc/classroom/classroom_event.dart';
import 'package:school_schedule_app/presentation/bloc/classroom/classroom_state.dart';
import 'classroom_form_page.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:school_schedule_app/core/widgets/premium_app_bar.dart';
import 'package:school_schedule_app/core/widgets/premium_empty_state.dart';
import 'package:school_schedule_app/core/theme/app_colors.dart';
import 'package:school_schedule_app/core/theme/app_spacing.dart';


class ClassroomListPage extends StatelessWidget {
  const ClassroomListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<ClassroomBloc>()..add(LoadClassrooms()),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: PremiumAppBar(
              title: Text(context.l10n.classes, maxLines: 1, overflow: TextOverflow.ellipsis),
              centerTitle: true,
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                final bloc = context.read<ClassroomBloc>();
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ClassroomFormPage())).then((_) {
                  if (context.mounted) bloc.add(LoadClassrooms());
                });
              },
              child: const Icon(Icons.add),
            ).animate().scale(),
            body: BlocConsumer<ClassroomBloc, ClassroomState>(
              listener: (context, state) {
                if (state is ClassroomOperationSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message, maxLines: 1, overflow: TextOverflow.ellipsis), backgroundColor: AppColors.success));
                } else if (state is ClassroomError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message, maxLines: 1, overflow: TextOverflow.ellipsis), backgroundColor: Theme.of(context).colorScheme.error));
                }
              },
              builder: (context, state) {
                if (state is ClassroomLoading) return const Center(child: CircularProgressIndicator());
                if (state is ClassroomError) return Center(child: Text(state.message, maxLines: 1, overflow: TextOverflow.ellipsis));
                if (state is ClassroomLoaded) {
                  if (state.classrooms.isEmpty) {
                    return PremiumEmptyState(
                      title: context.l10n.noClassroomsLabel,
                      description: context.l10n.addClassroomsStartDesc,
                      icon: Icons.room_preferences_rounded,
                      actionLabel: context.l10n.addClassroomAction,
                      onAction: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ClassroomFormPage())).then((_) { if (context.mounted) context.read<ClassroomBloc>().add(LoadClassrooms()); }),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsetsDirectional.only(start: 16, end: 16, top: 16, bottom: 90),
                    itemCount: state.classrooms.length,
                    itemBuilder: (context, index) {
                      final classroom = state.classrooms[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(color: Theme.of(context).shadowColor.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(AppSpacing.md),
                          leading: CircleAvatar(
                            radius: 26,
                            backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                            child: Icon(Icons.room, color: Theme.of(context).colorScheme.primary),
                          ),
                          title: Text(classroom.name,
                              maxLines: 1, overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Row(
                              children: [
                                Icon(Icons.people, size: 16, color: Theme.of(context).colorScheme.outline),
                                const SizedBox(width: AppSpacing.xs),
                                Expanded(child: Text('${context.l10n.studentCount}: ${classroom.studentCount}',
                                    maxLines: 1, overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color))),
                                const SizedBox(width: 8),
                                Icon(Icons.tag, size: 16, color: Theme.of(context).colorScheme.outline),
                                const SizedBox(width: AppSpacing.xs),
                                Expanded(child: Text('${context.l10n.roomNumber} ${classroom.roomNumber}',
                                    maxLines: 1, overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color))),
                              ],
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit_rounded, color: Theme.of(context).colorScheme.primary),
                                onPressed: () {
                                  final bloc = context.read<ClassroomBloc>();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => ClassroomFormPage(classroom: classroom)),
                                  ).then((_) {
                                    if (context.mounted) bloc.add(LoadClassrooms());
                                  });
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete_rounded, color: Theme.of(context).colorScheme.error),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16)),
                                      title: Text(context.l10n.confirmDelete,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.error), maxLines: 1, overflow: TextOverflow.ellipsis),
                                      content: Text(context.l10n.confirmDeleteName(classroom.name), maxLines: 1, overflow: TextOverflow.ellipsis),
                                      actions: [
                                        TextButton(onPressed: () => Navigator.pop(ctx), child: Text(context.l10n.cancel, maxLines: 1, overflow: TextOverflow.ellipsis)),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Theme.of(context).colorScheme.error,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8))),
                                          onPressed: () {
                                            Navigator.pop(ctx);
                                            context.read<ClassroomBloc>().add(DeleteClassroom(classroom.id));
                                          },
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
