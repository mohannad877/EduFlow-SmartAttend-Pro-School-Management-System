import 'package:school_schedule_app/core/theme/app_spacing.dart';
import 'package:school_schedule_app/core/app_snack_bars.dart';
import 'package:school_schedule_app/core/utils/l10n_extension.dart';
import 'package:school_schedule_app/core/widgets/premium_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:school_schedule_app/domain/entities/enums.dart'; // Import WorkDay enum
import 'package:school_schedule_app/domain/entities/school.dart';
import 'package:school_schedule_app/core/providers/language_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:school_schedule_app/presentation/bloc/school/school_bloc.dart';
import 'package:school_schedule_app/presentation/bloc/school/school_event.dart';
import 'package:school_schedule_app/presentation/bloc/school/school_state.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _sessionDurationController;
  int _dailySessions = 8;
  List<WorkDay> _selectedWorkDays = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _sessionDurationController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _sessionDurationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<SchoolBloc>()..add(LoadSchool()),
      child: Scaffold(
        appBar: PremiumAppBar(
          title: Text(context.l10n.appName, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
        body: BlocConsumer<SchoolBloc, SchoolState>(
          listener: (context, state) {
            if (state is SchoolLoaded) {
              _nameController.text = state.school.name;
              _sessionDurationController.text =
                  state.school.sessionDuration.toString();
              _dailySessions = state.school.dailySessions;
              _selectedWorkDays = List.from(state.school.workDays);
            } else if (state is SchoolError) {
              AppSnackBars.showError(context, state.message);
            }
          },
          builder: (context, state) {
            if (state is SchoolLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is SchoolLoaded) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.schoolSettings,
                        style: Theme.of(context).textTheme.titleLarge,
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: context.l10n.schoolName,
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
                      DropdownButtonFormField<int>(
                        value: _dailySessions,
                        decoration: InputDecoration(
                          labelText: context.l10n.dailySessions,
                          border: const OutlineInputBorder(),
                        ),
                        items: List.generate(5, (index) => index + 6)
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e.toString(), maxLines: 1, overflow: TextOverflow.ellipsis),
                                ))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _dailySessions = value;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _sessionDurationController,
                        decoration: InputDecoration(
                          labelText: context.l10n.sessionDurationMinutes,
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
                      const SizedBox(height: 24),
                      Text(
                        context.l10n.workDays,
                        style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8.0,
                        children: WorkDay.values.map((day) {
                          final isSelected = _selectedWorkDays.contains(day);
                          return FilterChip(
                            label: Text(day.getLocalizedName(context), maxLines: 1, overflow: TextOverflow.ellipsis),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _selectedWorkDays.add(day);
                                } else {
                                  _selectedWorkDays.remove(day);
                                }
                                // Sort by index to keep order
                                _selectedWorkDays
                                    .sort((a, b) => a.index.compareTo(b.index));
                              });
                            },
                          );
                        }).toList(),
                      ),
                                            const SizedBox(height: 32),
                      Text(
                        context.l10n.languageAndDisplay,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      riverpod.Consumer(
                        builder: (context, ref, child) {
                          final currentLocale = ref.watch(languageProvider);
                          return ToggleButtons(
                            borderRadius: BorderRadius.circular(8),
                            isSelected: [
                              currentLocale.languageCode == 'en',
                              currentLocale.languageCode == 'ar',
                            ],
                            onPressed: (index) {
                              final newLang = index == 0 ? 'en' : 'ar';
                              ref.read(languageProvider.notifier).changeLanguage(newLang);
                            },
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Text('English'),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(context.l10n.arabic),
                              ),
                            ],
                          );
                        },
                      ),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              if (_selectedWorkDays.isEmpty) {
                                AppSnackBars.showWarning(
                                    context, 'select_at_least_one_day');
                                return;
                              }

                              final updatedSchool = School(
                                id: state.school.id,
                                name: _nameController.text,
                                address: state.school.address,
                                phone: state.school.phone,
                                email: state.school.email,
                                dailySessions: _dailySessions,
                                workDays: _selectedWorkDays,
                                firstSessionTime: state.school.firstSessionTime,
                                sessionDuration:
                                    int.parse(_sessionDurationController.text),
                                academicYear: state.school.academicYear,
                              );

                              context
                                  .read<SchoolBloc>()
                                  .add(UpdateSchool(updatedSchool));

                              AppSnackBars.showSuccess(
                                  context, context.l10n.savedSuccessfully);
                            }
                          },
                          child: Text(context.l10n.save, maxLines: 1, overflow: TextOverflow.ellipsis),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
