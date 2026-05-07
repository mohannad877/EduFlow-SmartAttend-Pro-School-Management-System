import 'package:school_schedule_app/core/utils/l10n_extension.dart';
import 'package:school_schedule_app/core/widgets/premium_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:school_schedule_app/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';
import 'package:school_schedule_app/domain/entities/classroom.dart';
import 'package:school_schedule_app/domain/entities/enums.dart';
import 'package:school_schedule_app/presentation/bloc/classroom/classroom_bloc.dart';
import 'package:school_schedule_app/presentation/bloc/classroom/classroom_event.dart';
import 'package:school_schedule_app/presentation/bloc/classroom/classroom_state.dart';
import 'package:school_schedule_app/presentation/bloc/subject/subject_bloc.dart';
import 'package:school_schedule_app/presentation/bloc/subject/subject_event.dart';
import 'package:school_schedule_app/presentation/bloc/subject/subject_state.dart';
import 'package:school_schedule_app/domain/entities/subject.dart';

class ClassroomFormPage extends StatefulWidget {
  final Classroom? classroom;

  const ClassroomFormPage({super.key, this.classroom});

  @override
  State<ClassroomFormPage> createState() => _ClassroomFormPageState();
}

class _ClassroomFormPageState extends State<ClassroomFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _studentCountController;
  late TextEditingController _roomNumberController;
  ClassLevel _selectedLevel = ClassLevel.primary;
  String _selectedSection = 'A';
  List<Subject> _selectedSubjects = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.classroom?.name ?? '');
    _studentCountController = TextEditingController(
        text: widget.classroom?.studentCount.toString() ?? '');
    _roomNumberController =
        TextEditingController(text: widget.classroom?.roomNumber ?? '');

    _selectedLevel = widget.classroom?.level ?? ClassLevel.primary;
    if (widget.classroom?.section != null &&
        widget.classroom!.section.isNotEmpty) {
      // Ensure the section is one of A, B, C, D, otherwise default to A
      if (['A', 'B', 'C', 'D'].contains(widget.classroom!.section)) {
        _selectedSection = widget.classroom!.section;
      } else {
        _selectedSection = 'A';
      }
    }
    _selectedSubjects = List.from(widget.classroom?.subjects ?? []);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _studentCountController.dispose();
    _roomNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => GetIt.I<ClassroomBloc>()),
        BlocProvider(
            create: (context) => GetIt.I<SubjectBloc>()..add(LoadSubjects())),
      ],
      child: Scaffold(
        appBar: PremiumAppBar(
          title: Text(widget.classroom == null
              ? context.l10n.addClassroom
              : context.l10n.editClassroom, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
        body: BlocListener<ClassroomBloc, ClassroomState>(
          listener: (context, state) {
            if (state is ClassroomOperationSuccess) {
              AppSnackBars.showSuccess(context, context.l10n.saved_successfully);
              Navigator.pop(context);
            } else if (state is ClassroomError) {
              AppSnackBars.showError(context, state.message);
            }
          },
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, MediaQuery.of(context).padding.bottom + 80.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: context.l10n.classroomName,
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context.l10n.requiredField;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Section Dropdown (A-D)
                  DropdownButtonFormField<String>(
                    value: _selectedSection,
                    decoration: InputDecoration(
                      labelText: context.l10n.section,
                      border: const OutlineInputBorder(),
                    ),
                    items: ['A', 'B', 'C', 'D'].map((section) {
                      return DropdownMenuItem(
                        value: section,
                        child: Text(section, maxLines: 1, overflow: TextOverflow.ellipsis),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedSection = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  DropdownButtonFormField<ClassLevel>(
                    value: _selectedLevel,
                    decoration: InputDecoration(
                      labelText: context.l10n.classLevel,
                      border: const OutlineInputBorder(),
                    ),
                    items: ClassLevel.values.map((level) {
                      return DropdownMenuItem(
                        value: level,
                        child: Text(level.getLocalizedName(context), maxLines: 1, overflow: TextOverflow.ellipsis),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedLevel = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _studentCountController,
                    decoration: InputDecoration(
                      labelText: context.l10n.studentCount,
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context.l10n.requiredField;
                      }
                      if (int.tryParse(value) == null) {
                        return context.l10n.invalidNumber;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _roomNumberController,
                    decoration: InputDecoration(
                      labelText: context.l10n.roomNumber,
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context.l10n.requiredField;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<SubjectBloc, SubjectState>(
                    builder: (context, subjectState) {
                      if (subjectState is SubjectLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (subjectState is SubjectLoaded) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(context.l10n.subjectsLabel,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8.0,
                              runSpacing: 4.0,
                              children: subjectState.subjects.map((subject) {
                                final isSelected = _selectedSubjects
                                    .any((s) => s.id == subject.id);
                                return FilterChip(
                                  label: Text(subject.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    setState(() {
                                      if (selected) {
                                        _selectedSubjects.add(subject);
                                      } else {
                                        _selectedSubjects.removeWhere(
                                            (s) => s.id == subject.id);
                                      }
                                    });
                                  },
                                  backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                                  selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.15),
                                  checkmarkColor: Theme.of(context).colorScheme.primary,
                                );
                              }).toList(),
                            ),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  const SizedBox(height: 24),

                  // Save Button with Loader
                  BlocBuilder<ClassroomBloc, ClassroomState>(
                    builder: (context, state) {
                      if (state is ClassroomLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return ElevatedButton(
                        onPressed: () => _saveClassroom(context),
                        child: Text(context.l10n.save, maxLines: 1, overflow: TextOverflow.ellipsis),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _saveClassroom(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final classroom = Classroom(
        id: widget.classroom?.id ?? const Uuid().v4(),
        name: _nameController.text,
        section: _selectedSection,
        studentCount: int.parse(_studentCountController.text),
        roomNumber: _roomNumberController.text,
        level: _selectedLevel,
        supervisorId: widget.classroom?.supervisorId,
        subjects: _selectedSubjects,
      );

      if (widget.classroom == null) {
        context.read<ClassroomBloc>().add(AddClassroom(classroom));
      } else {
        context.read<ClassroomBloc>().add(UpdateClassroom(classroom));
      }
    }
  }
}
