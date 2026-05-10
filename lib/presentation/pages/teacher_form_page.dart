import 'package:school_schedule_app/core/utils/l10n_extension.dart';
import 'package:school_schedule_app/core/theme/app_colors.dart';
import 'package:school_schedule_app/core/widgets/premium_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';
import 'package:school_schedule_app/domain/entities/teacher.dart';
import 'package:school_schedule_app/domain/entities/enums.dart';
import 'package:school_schedule_app/presentation/bloc/teacher/teacher_bloc.dart';
import 'package:school_schedule_app/presentation/bloc/teacher/teacher_event.dart';
import 'package:school_schedule_app/presentation/bloc/teacher/teacher_state.dart';
import 'package:school_schedule_app/presentation/bloc/subject/subject_bloc.dart';
import 'package:school_schedule_app/presentation/bloc/subject/subject_event.dart';
import 'package:school_schedule_app/presentation/bloc/subject/subject_state.dart';
import 'package:school_schedule_app/presentation/bloc/classroom/classroom_bloc.dart';
import 'package:school_schedule_app/presentation/bloc/classroom/classroom_event.dart';
import 'package:school_schedule_app/presentation/bloc/classroom/classroom_state.dart';


class TeacherFormPage extends StatefulWidget {
  final Teacher? teacher;

  const TeacherFormPage({super.key, this.teacher});

  @override
  State<TeacherFormPage> createState() => _TeacherFormPageState();
}

class _TeacherFormPageState extends State<TeacherFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _specializationController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _maxWeeklyHoursController;
  late TextEditingController _maxDailyHoursController;
  late TextEditingController _qualificationController;
  List<String> _selectedSubjectIds = [];
  List<String> _selectedClassIds = [];
  List<WorkDay> _selectedWorkDays = []; // أيام العمل المختارة
  Map<WorkDay, List<int>> _unavailablePeriods = {}; // فترات عدم التوفر

  // TODO: Add complex fields like Unavailable Periods

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.teacher?.fullName ?? '');
    _specializationController =
        TextEditingController(text: widget.teacher?.specialization ?? '');
    _phoneController = TextEditingController(text: widget.teacher?.phone ?? '');
    _emailController = TextEditingController(text: widget.teacher?.email ?? '');
    _maxWeeklyHoursController = TextEditingController(
        text: widget.teacher?.maxWeeklyHours.toString() ?? '24');
    _maxDailyHoursController = TextEditingController(
        text: widget.teacher?.maxDailyHours.toString() ?? '6');
    _qualificationController = TextEditingController(text: widget.teacher?.qualification ?? '');

    if (widget.teacher != null) {
      _selectedSubjectIds = List.from(widget.teacher!.subjectIds);
      _selectedClassIds = List.from(widget.teacher!.classIds);
      _selectedWorkDays = List.from(widget.teacher!.workDays);
      _unavailablePeriods = Map.from(widget.teacher!.unavailablePeriods);
    } else {
      // القيمة الافتراضية: جميع أيام الأسبوع
      _selectedWorkDays = [
        WorkDay.saturday,
        WorkDay.sunday,
        WorkDay.monday,
        WorkDay.tuesday,
        WorkDay.wednesday,
        WorkDay.thursday,
      ];
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _specializationController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _maxWeeklyHoursController.dispose();
    _maxDailyHoursController.dispose();
    _qualificationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => GetIt.I<TeacherBloc>()),
        BlocProvider(
            create: (context) => GetIt.I<SubjectBloc>()..add(LoadSubjects())),
        BlocProvider(
            create: (context) =>
                GetIt.I<ClassroomBloc>()..add(LoadClassrooms())),
      ],
      child: BlocConsumer<TeacherBloc, TeacherState>(
        listener: (context, state) {
          if (state is TeacherOperationSuccess) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message, maxLines: 1, overflow: TextOverflow.ellipsis)));
            Navigator.pop(context);
          } else if (state is TeacherError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message, maxLines: 1, overflow: TextOverflow.ellipsis)));
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: PremiumAppBar(
              title: Text(widget.teacher == null
                  ? context.l10n.addTeacher
                  : context.l10n.editTeacher, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
            body: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, MediaQuery.of(context).padding.bottom + 80.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: context.l10n.fullName),
                      validator: (value) =>
                          value!.isEmpty ? context.l10n.requiredField : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _specializationController,
                      decoration:
                          InputDecoration(labelText: context.l10n.specialization),
                      validator: (value) =>
                          value!.isEmpty ? context.l10n.requiredField : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _qualificationController,
                      decoration:
                          InputDecoration(labelText: context.l10n.qualification),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(labelText: context.l10n.phone),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: context.l10n.email),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _maxWeeklyHoursController,
                            decoration: InputDecoration(
                                labelText: context.l10n.maxWeeklyHours),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _maxDailyHoursController,
                            decoration: InputDecoration(
                                labelText: context.l10n.maxDailyHours),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    BlocBuilder<SubjectBloc, SubjectState>(
                      builder: (context, subjectState) {
                        if (subjectState is SubjectLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (subjectState is SubjectLoaded) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(context.l10n.subjects,
                                  style:
                                      Theme.of(context).textTheme.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8.0,
                                runSpacing: 4.0,
                                children: subjectState.subjects.map((subject) {
                                  final isSelected =
                                      _selectedSubjectIds.contains(subject.id);
                                  return FilterChip(
                                    label: Text(subject.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                                    selected: isSelected,
                                    onSelected: (selected) {
                                      setState(() {
                                        if (selected) {
                                          _selectedSubjectIds.add(subject.id);
                                        } else {
                                          _selectedSubjectIds
                                              .remove(subject.id);
                                        }
                                      });
                                    },
                                  );
                                }).toList(),
                              ),
                              if (subjectState.subjects.isEmpty)
                                Text(context.l10n.noSubjectsFound,
                                    style: const TextStyle(fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                            ],
                          );
                        } else if (subjectState is SubjectError) {
                           return Text(context.l10n.subjects, maxLines: 1, overflow: TextOverflow.ellipsis);
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    const SizedBox(height: 24),
                    // Classrooms Selection
                    BlocBuilder<ClassroomBloc, ClassroomState>(
                      builder: (context, classState) {
                        if (classState is ClassroomLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (classState is ClassroomLoaded) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(context.l10n.classes,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8.0,
                                runSpacing: 4.0,
                                children:
                                    classState.classrooms.map((classroom) {
                                  final isSelected =
                                      _selectedClassIds.contains(classroom.id);
                                    return FilterChip(
                                      label: Text(classroom.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                                      selected: isSelected,
                                      onSelected: (selected) {
                                        setState(() {
                                          if (selected) {
                                            _selectedClassIds.add(classroom.id);
                                          } else {
                                            _selectedClassIds
                                                .remove(classroom.id);
                                          }
                                        });
                                      },
                                    );
                                }).toList(),
                              ),
                              const SizedBox(height: 8),
                               Text(
                                context.l10n.allGradesTeachingHint,
                                style: const TextStyle(fontSize: 12),
                              maxLines: 1, overflow: TextOverflow.ellipsis),
                            ],
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    const SizedBox(height: 24),
                    // قسم أيام العمل
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(context.l10n.workingDays,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: [
                            _buildWorkDayChip(WorkDay.saturday, context.l10n.saturday),
                            _buildWorkDayChip(WorkDay.sunday, context.l10n.sunday),
                            _buildWorkDayChip(WorkDay.monday, context.l10n.monday),
                            _buildWorkDayChip(WorkDay.tuesday, context.l10n.tuesday),
                            _buildWorkDayChip(WorkDay.wednesday, context.l10n.wednesday),
                            _buildWorkDayChip(WorkDay.thursday, context.l10n.thursday),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          context.l10n.selectWorkingDaysDesc,
                          style:
                              TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodySmall?.color),
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // قسم جدول التوفر
                    _buildAvailabilityGrid(),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: state is TeacherLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                final teacher = Teacher(
                                  id: widget.teacher?.id ?? const Uuid().v4(),
                                  fullName: _nameController.text,
                                  specialization:
                                      _specializationController.text,
                                  phone: _phoneController.text,
                                  email: _emailController.text,
                                  maxWeeklyHours: int.tryParse(
                                          _maxWeeklyHoursController.text) ??
                                      24,
                                  maxDailyHours: int.tryParse(
                                          _maxDailyHoursController.text) ??
                                      6,
                                  qualification:
                                      _qualificationController.text,
                                  type: widget.teacher?.type ??
                                      TeacherType.primary,
                                  unavailablePeriods: _unavailablePeriods,
                                  subjectIds: _selectedSubjectIds,
                                  classIds: _selectedClassIds,
                                  workDays: _selectedWorkDays,
                                );

                                if (widget.teacher == null) {
                                  context
                                      .read<TeacherBloc>()
                                      .add(AddTeacher(teacher));
                                } else {
                                  context
                                      .read<TeacherBloc>()
                                      .add(UpdateTeacher(teacher));
                                }
                              }
                            },
                      child: state is TeacherLoading
                          ? const CircularProgressIndicator()
                          : Text(context.l10n.save, maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWorkDayChip(WorkDay day, String label) {
    final isSelected = _selectedWorkDays.contains(day);
    return FilterChip(
      label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          if (selected) {
            _selectedWorkDays.add(day);
          } else {
            _selectedWorkDays.remove(day);
            _unavailablePeriods.remove(day); // إزالة فترات الاعتذار لليوم الذي لا يعمل فيه
          }
        });
      },
    );
  }

  Widget _buildAvailabilityGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.l10n.unavailabilitySchedule,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 8),
        Text(context.l10n.unavailabilityScheduleDesc,
            style: const TextStyle(fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 12),
        if (_selectedWorkDays.isEmpty)
          Text(context.l10n.selectWorkingDaysFirst,
              style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis)
        else
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Table(
              defaultColumnWidth: const FixedColumnWidth(80),
              border: TableBorder.all(color: Theme.of(context).dividerColor),
              children: [
                TableRow(
                  children: [
                    TableCell(child: Center(child: Text(context.l10n.day, maxLines: 1, overflow: TextOverflow.ellipsis))),
                    ...List.generate(7, (i) => TableCell(child: Center(child: Text(context.l10n.periodLabel((i + 1).toString()), maxLines: 1, overflow: TextOverflow.ellipsis)))),
                  ],
                ),
                ..._selectedWorkDays.map((day) {
                  return TableRow(
                    children: [
                      TableCell(child: Center(child: Text(_getDayName(day), maxLines: 1, overflow: TextOverflow.ellipsis))),
                      ...List.generate(7, (sessionIndex) {
                        final isUnavailable = _unavailablePeriods[day]?.contains(sessionIndex) ?? false;
                        return TableCell(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                final periods = _unavailablePeriods[day] ?? [];
                                if (isUnavailable) {
                                  periods.remove(sessionIndex);
                                } else {
                                  periods.add(sessionIndex);
                                }
                                _unavailablePeriods[day] = List.from(periods);
                              });
                            },
                            child: Container(
                              height: 40,
                              color: isUnavailable
                                  ? Theme.of(context).colorScheme.errorContainer
                                  : Colors.transparent,
                              child: isUnavailable
                                  ? Icon(Icons.block, color: Theme.of(context).colorScheme.error, size: 16)
                                  : null,
                            ),
                          ),
                        );
                      }),
                    ],
                  );
                }),
              ],
            ),
          ),
      ],
    );
  }

  String _getDayName(WorkDay day) {
    switch (day) {
      case WorkDay.saturday: return context.l10n.saturday;
      case WorkDay.sunday: return context.l10n.sunday;
      case WorkDay.monday: return context.l10n.monday;
      case WorkDay.tuesday: return context.l10n.tuesday;
      case WorkDay.wednesday: return context.l10n.wednesday;
      case WorkDay.thursday: return context.l10n.thursday;
      case WorkDay.friday: return context.l10n.friday;
    }
  }
}
