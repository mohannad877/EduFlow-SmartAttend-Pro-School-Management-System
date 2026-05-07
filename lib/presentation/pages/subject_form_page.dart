import 'package:school_schedule_app/core/utils/l10n_extension.dart';
import 'package:school_schedule_app/core/widgets/premium_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:school_schedule_app/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';
import 'package:school_schedule_app/domain/entities/subject.dart';
import 'package:school_schedule_app/domain/entities/enums.dart';
import 'package:school_schedule_app/presentation/bloc/subject/subject_bloc.dart';
import 'package:school_schedule_app/presentation/bloc/subject/subject_event.dart';
import 'package:school_schedule_app/presentation/bloc/subject/subject_state.dart';
import 'package:school_schedule_app/presentation/bloc/classroom/classroom_bloc.dart';
import 'package:school_schedule_app/presentation/bloc/classroom/classroom_event.dart';
import 'package:school_schedule_app/presentation/bloc/classroom/classroom_state.dart';

class SubjectFormPage extends StatefulWidget {
  final Subject? subject;

  const SubjectFormPage({super.key, this.subject});

  @override
  State<SubjectFormPage> createState() => _SubjectFormPageState();
}

class _SubjectFormPageState extends State<SubjectFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _codeController;
  late TextEditingController _weeklyHoursController;
  SubjectPriority _selectedPriority = SubjectPriority.medium;
  Color _selectedColor = Colors.blue;
  bool _requiresLab = false;
  bool _requiresProjector = false;
  
  // Map classId to TextEditingController for periods
  final Map<String, TextEditingController> _classPeriodsControllers = {};
  
  final List<Color> _availableColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.pink,
    Colors.indigo,
    Colors.brown,
    Colors.cyan,
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.subject?.name ?? '');
    _codeController = TextEditingController(text: widget.subject?.code ?? '');
    _weeklyHoursController = TextEditingController(text: widget.subject?.weeklyHours.toString() ?? '0');
    
    if (widget.subject != null) {
      _selectedPriority = widget.subject!.priority;
      _selectedColor = widget.subject!.color;
      _requiresLab = widget.subject!.requiresLab;
      _requiresProjector = widget.subject!.requiresProjector;
      
      widget.subject!.classPeriods.forEach((classId, periods) {
        _classPeriodsControllers[classId] = TextEditingController(text: periods.toString());
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _weeklyHoursController.dispose();
    for (var controller in _classPeriodsControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => GetIt.I<SubjectBloc>()),
        BlocProvider(create: (context) => GetIt.I<ClassroomBloc>()..add(LoadClassrooms())),
      ],
      child: Scaffold(
        appBar: PremiumAppBar(
          title: Text(widget.subject == null ? context.l10n.addSubject : context.l10n.editSubject, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
        body: BlocListener<SubjectBloc, SubjectState>(
          listener: (context, state) {
            if (state is SubjectOperationSuccess) {
              AppSnackBars.showSuccess(context, context.l10n.saved_successfully);
              Navigator.pop(context);
            } else if (state is SubjectError) {
              AppSnackBars.showError(context, state.message);
            }
          },
          child: Builder(
            builder: (context) {
              return Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, MediaQuery.of(context).padding.bottom + 80.0),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: context.l10n.subjectName,
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
                      TextFormField(
                        controller: _codeController,
                        decoration: InputDecoration(
                          labelText: context.l10n.code,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<SubjectPriority>(
                        value: _selectedPriority,
                        decoration: InputDecoration(
                          labelText: context.l10n.priority,
                          border: const OutlineInputBorder(),
                        ),
                        items: SubjectPriority.values.map((p) {
                          return DropdownMenuItem(
                            value: p,
                            child: Text(
                              p == SubjectPriority.low
                                  ? context.l10n.priorityLow
                                  : p == SubjectPriority.high
                                      ? context.l10n.priorityHigh
                                      : context.l10n.priorityMedium,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (val) => setState(() => _selectedPriority = val!),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _weeklyHoursController,
                        decoration: InputDecoration(
                          labelText: context.l10n.weeklyHours,
                          border: const OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) return context.l10n.requiredField;
                          if (int.tryParse(value) == null) return context.l10n.invalidNumber;
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      
                      // Switches for Lab and Projector
                      SwitchListTile(
                        title: Text(context.l10n.requiresLab, maxLines: 1, overflow: TextOverflow.ellipsis),
                        value: _requiresLab,
                        onChanged: (val) => setState(() => _requiresLab = val),
                      ),
                      SwitchListTile(
                        title: Text(context.l10n.requiresProjector, maxLines: 1, overflow: TextOverflow.ellipsis),
                        value: _requiresProjector,
                        onChanged: (val) => setState(() => _requiresProjector = val),
                      ),
                      const SizedBox(height: 16),
                      
                      // Color Selection
                      Text(context.l10n.subjectColor, style: Theme.of(context).textTheme.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 50,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _availableColors.length,
                          itemBuilder: (context, index) {
                            final color = _availableColors[index];
                            final isSelected = _selectedColor.value == color.value;
                            return GestureDetector(
                              onTap: () => setState(() => _selectedColor = color),
                              child: Container(
                                width: 40,
                                height: 40,
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                  border: isSelected ? Border.all(color: Colors.black, width: 2) : null,
                                  boxShadow: isSelected ? [BoxShadow(color: color.withOpacity(0.5), blurRadius: 8)] : null,
                                ),
                                child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 20) : null,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      Text(
                        context.l10n.subjectPeriodsPerClass,
                        style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 16),
                      BlocBuilder<ClassroomBloc, ClassroomState>(
                        builder: (context, state) {
                          if (state is ClassroomLoading) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (state is ClassroomLoaded) {
                            if (state.classrooms.isEmpty) {
                              return Text(context.l10n.noClassroomsFound, maxLines: 1, overflow: TextOverflow.ellipsis);
                            }
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: state.classrooms.length,
                              itemBuilder: (context, index) {
                                final classroom = state.classrooms[index];
                                final isSelected = _classPeriodsControllers.containsKey(classroom.id);
                                
                                return Card(
                                  margin: const EdgeInsets.symmetric(vertical: 4),
                                  child: Column(
                                    children: [
                                      CheckboxListTile(
                                        title: Text('${classroom.name} - ${classroom.section}', maxLines: 1, overflow: TextOverflow.ellipsis),
                                        value: isSelected,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            if (value == true) {
                                              _classPeriodsControllers[classroom.id] = TextEditingController(text: '1');
                                            } else {
                                              var controller = _classPeriodsControllers.remove(classroom.id);
                                              controller?.dispose();
                                            }
                                          });
                                        },
                                      ),
                                      if (isSelected)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                          child: TextFormField(
                                            controller: _classPeriodsControllers[classroom.id],
                                            decoration: InputDecoration(
                                              labelText: context.l10n.weeklyHours,
                                              border: const OutlineInputBorder(),
                                            ),
                                            keyboardType: TextInputType.number,
                                            validator: (value) {
                                              if (value == null || value.isEmpty) return context.l10n.requiredField;
                                              if (int.tryParse(value) == null) return context.l10n.invalidNumber;
                                              return null;
                                            },
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              },
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => _saveSubject(context),
                        child: Text(context.l10n.save, maxLines: 1, overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _saveSubject(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      var finalClassPeriods = <String, int>{};
      _classPeriodsControllers.forEach((classId, controller) {
        finalClassPeriods[classId] = int.parse(controller.text);
      });

      final subject = Subject(
        id: widget.subject?.id ?? const Uuid().v4(),
        name: _nameController.text,
        code: _codeController.text,
        weeklyHours: int.parse(_weeklyHoursController.text),
        classPeriods: finalClassPeriods,
        color: _selectedColor,
        priority: _selectedPriority,
        requiresLab: _requiresLab,
        requiresProjector: _requiresProjector,
        qualifiedTeacherIds: widget.subject?.qualifiedTeacherIds ?? [],
      );

      if (widget.subject == null) {
        context.read<SubjectBloc>().add(AddSubject(subject));
      } else {
        context.read<SubjectBloc>().add(UpdateSubject(subject));
      }
    }
  }
}

