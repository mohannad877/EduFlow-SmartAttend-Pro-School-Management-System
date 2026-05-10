import 'package:school_schedule_app/core/theme/app_spacing.dart';
import 'package:school_schedule_app/core/utils/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:get_it/get_it.dart';


import 'package:school_schedule_app/domain/entities/session.dart';
import 'package:school_schedule_app/domain/entities/schedule.dart';
import 'package:school_schedule_app/domain/entities/teacher.dart';
import 'package:school_schedule_app/domain/entities/subject.dart';
import 'package:school_schedule_app/domain/entities/classroom.dart';
import 'package:school_schedule_app/domain/entities/enums.dart';

import 'package:school_schedule_app/domain/usecases/algorithm/conflict_resolver.dart';

class SessionEditDialog extends StatefulWidget {
  final Session? currentSession;
  final WorkDay day;
  final int sessionNumber;
  final String classId;
  final List<Teacher> teachers;
  final List<Subject> subjects;
  final List<Classroom> classrooms;
  final Schedule schedule;
  final int dailySessions;
  final int workDays;

  const SessionEditDialog({
    super.key,
    this.currentSession,
    required this.day,
    required this.sessionNumber,
    required this.classId,
    required this.teachers,
    required this.subjects,
    required this.classrooms,
    required this.schedule,
    required this.dailySessions,
    required this.workDays,
  });

  @override
  State<SessionEditDialog> createState() => _SessionEditDialogState();
}

class _SessionEditDialogState extends State<SessionEditDialog> {
  String? selectedTeacherId;
  String? selectedSubjectId;
  String? selectedClassroomId;
  WorkDay? currentDay;
  int? currentSessionNum;
  SessionStatus status = SessionStatus.scheduled;
  final _formKey = GlobalKey<FormState>();

  bool hasConflict = false;

  @override
  void initState() {
    super.initState();
    currentDay = widget.day;
    currentSessionNum = widget.sessionNumber;
    selectedClassroomId = widget.classId;

    if (widget.currentSession != null) {
      selectedTeacherId = widget.currentSession!.teacherId;
      selectedSubjectId = widget.currentSession!.subjectId;
      selectedClassroomId = widget.currentSession!.roomId;
      status = widget.currentSession!.status;
      currentDay = widget.currentSession!.day;
      currentSessionNum = widget.currentSession!.sessionNumber;
    }
  }

  void _checkConflict() {
    if (selectedTeacherId == null) {
      setState(() => hasConflict = false);
      return;
    }

    final isTeacherBusy = widget.schedule.sessions.any((s) =>
        s.teacherId == selectedTeacherId &&
        s.day == currentDay &&
        s.sessionNumber == currentSessionNum &&
        s.id != (widget.currentSession?.id ?? ''));

    final isClassroomBusy = widget.schedule.sessions.any((s) =>
        s.classId == selectedClassroomId &&
        s.day == currentDay &&
        s.sessionNumber == currentSessionNum &&
        s.id != (widget.currentSession?.id ?? ''));

    setState(() {
      hasConflict = isTeacherBusy || isClassroomBusy;
    });
  }

  Future<void> _resolveConflict() async {
    final resolver = GetIt.I<ConflictResolver>();

    // Create a temporary session object representing current selection
    final tempSession = Session(
      id: widget.currentSession?.id ?? 'temp',
      day: currentDay!,
      sessionNumber: currentSessionNum!,
      classId: widget.classId, // The session belongs to this class context
      teacherId: selectedTeacherId!,
      subjectId: selectedSubjectId ?? '',
      roomId: selectedClassroomId!,
      status: status,
    );

    final alternative = resolver.findAlternativeSlot(
      session: tempSession,
      schedule: widget.schedule,
      dailySessions: widget.dailySessions,
      workDays: widget.workDays,
    );

    if (alternative != null) {
      setState(() {
        currentDay = alternative.day;
        currentSessionNum = alternative.sessionNumber;
        _checkConflict(); // Should be false now
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                '${context.l10n.foundSlot}: ${alternative.day.getLocalizedName(context)} - ${context.l10n.sessionNumberLabel(alternative.sessionNumber.toString())}', maxLines: 1, overflow: TextOverflow.ellipsis)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.noAlternativeSlot, maxLines: 1, overflow: TextOverflow.ellipsis)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _checkConflict(); // Re-check on build or state change

    return AlertDialog(
      title: Text(widget.currentSession == null
          ? context.l10n.addSession
          : context.l10n.editSession, maxLines: 1, overflow: TextOverflow.ellipsis),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Session Info
               Text(
                 '${context.l10n.day}: ${currentDay?.getLocalizedName(context)}',
                 style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                       color: Theme.of(context).colorScheme.onSurface,
                     ),
               maxLines: 1, overflow: TextOverflow.ellipsis),
               Text(
                 '${context.l10n.session}: $currentSessionNum',
                 style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                       color: Theme.of(context).colorScheme.onSurface,
                     ),
               maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 16),

              if (hasConflict)
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Theme.of(context).colorScheme.error.withOpacity(0.4)),
                    ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.warning, color: Theme.of(context).colorScheme.error),
                          const SizedBox(width: 8),
                          Expanded(
                              child: Text(context.l10n.conflict,
                                  style: TextStyle(color: Theme.of(context).colorScheme.error), maxLines: 1, overflow: TextOverflow.ellipsis)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: _resolveConflict,
                        icon: const Icon(Icons.auto_fix_high),
                        label: Text(context.l10n.autoFix, maxLines: 1, overflow: TextOverflow.ellipsis),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.secondary,
                          foregroundColor: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              const SizedBox(height: 16),

              // Teacher Dropdown
              DropdownButtonFormField<String>(
                value: selectedTeacherId,
                decoration: InputDecoration(
                  labelText: context.l10n.teacher,
                  border: const OutlineInputBorder(),
                ),
                items: widget.teachers.map((teacher) {
                  return DropdownMenuItem(
                    value: teacher.id,
                    child: Text(teacher.fullName, maxLines: 1, overflow: TextOverflow.ellipsis),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedTeacherId = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return context.l10n.requiredField;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Subject Dropdown
              DropdownButtonFormField<String>(
                value: selectedSubjectId,
                decoration: InputDecoration(
                  labelText: context.l10n.subject,
                  border: const OutlineInputBorder(),
                ),
                items: widget.subjects.map((subject) {
                  return DropdownMenuItem(
                    value: subject.id,
                    child: Text(subject.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedSubjectId = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return context.l10n.requiredField;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Classroom Dropdown
              DropdownButtonFormField<String>(
                value: selectedClassroomId,
                decoration: InputDecoration(
                  labelText: context.l10n.classroom,
                  border: const OutlineInputBorder(),
                ),
                items: widget.classrooms.map((classroom) {
                  return DropdownMenuItem(
                    value: classroom.id,
                    child: Text(classroom.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedClassroomId = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return context.l10n.requiredField;
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        if (widget.currentSession != null)
          TextButton.icon(
            onPressed: () {
              Navigator.of(context).pop('delete');
            },
            icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
            label:
                Text(context.l10n.delete, style: TextStyle(color: Theme.of(context).colorScheme.error), maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(context.l10n.cancel, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final session = widget.currentSession?.copyWith(
                    day: currentDay!,
                    sessionNumber: currentSessionNum!,
                    teacherId: selectedTeacherId!,
                    subjectId: selectedSubjectId!,
                    roomId: selectedClassroomId!,
                    status: status,
                  ) ??
                  Session(
                    id: const Uuid().v4(),
                    day: currentDay!,
                    sessionNumber: currentSessionNum!,
                    classId: widget.classId,
                    teacherId: selectedTeacherId!,
                    subjectId: selectedSubjectId!,
                    roomId: selectedClassroomId!,
                    status: status,
                  );
              Navigator.of(context).pop(session);
            }
          },
          child: Text(context.l10n.save, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}
