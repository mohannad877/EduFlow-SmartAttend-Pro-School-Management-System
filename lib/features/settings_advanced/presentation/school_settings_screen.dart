import 'package:school_schedule_app/core/utils/l10n_extension.dart';
import 'package:school_schedule_app/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:school_schedule_app/core/widgets/premium_app_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_schedule_app/core/theme/app_colors.dart';
import 'package:school_schedule_app/core/theme/app_text_styles.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:school_schedule_app/core/database/attendance_providers.dart';
import 'package:flutter/foundation.dart';
import 'package:school_schedule_app/core/utils/test_data_seeder.dart';

/// شاشة إعدادات المدرسة
class SchoolSettingsScreen extends ConsumerStatefulWidget {
  const SchoolSettingsScreen({super.key});

  @override
  ConsumerState<SchoolSettingsScreen> createState() => _SchoolSettingsScreenState();
}

class _SchoolSettingsScreenState extends ConsumerState<SchoolSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _schoolNameController = TextEditingController();
  final _schoolAddressController = TextEditingController();
  final _schoolPhoneController = TextEditingController();
  final _academicYearController = TextEditingController();
  final _periodsCountController = TextEditingController();

  bool _isLoading = true;
  bool _isSaving = false;

  bool _enableBarcodeScan = true;
  bool _notifyParents = true;
  bool _restrictAttendanceTime = false;
  final List<bool> _selectedWorkDays = [true, true, true, true, true, false, false];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final db = ref.read(attendanceDatabaseProvider);

    final schoolName = await _getSetting(db, 'school_name');
    final schoolAddress = await _getSetting(db, 'school_address');
    final schoolPhone = await _getSetting(db, 'school_phone');
    final academicYear = await _getSetting(db, 'academic_year');
    final periodsCount = await _getSetting(db, 'periods_per_day');

    setState(() {
      _schoolNameController.text = schoolName ?? context.l10n.from;
      _schoolAddressController.text = schoolAddress ?? '';
      _schoolPhoneController.text = schoolPhone ?? '';
      _academicYearController.text = academicYear ?? '2024-2025';
      _periodsCountController.text = periodsCount ?? '7';
      _isLoading = false;
    });
  }

  Future<String?> _getSetting(AttendanceDatabase db, String key) async {
    final result = await (db.select(db.attSettings)
          ..where((s) => s.key.equals(key)))
        .getSingleOrNull();
    return result?.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PremiumAppBar(
        title: Text(context.l10n.schoolSettingsLabel, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          TextButton.icon(
            onPressed: _isSaving ? null : _saveSettings,
            icon: _isSaving
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.save),
            label: Text(_isSaving ? context.l10n.saving : context.l10n.save, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // معلومات المدرسة
                    _buildSectionTitle(context.l10n.schoolInfo),
                    const SizedBox(height: 12),
                    _buildTextField(
                      controller: _schoolNameController,
                      label: context.l10n.schoolName,
                      icon: Icons.school,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return context.l10n.enterSchoolName;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      controller: _schoolAddressController,
                      label: context.l10n.schoolAddress,
                      icon: Icons.location_on,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      controller: _schoolPhoneController,
                      label: context.l10n.phone,
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                    ),

                    const SizedBox(height: 24),

                    // الإعدادات الأكاديمية
                    _buildSectionTitle(context.l10n.academicSettings),
                    const SizedBox(height: 12),
                    _buildTextField(
                      controller: _academicYearController,
                      label: context.l10n.view,
                      icon: Icons.calendar_today,
                      hint: '2024-2025',
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      controller: _periodsCountController,
                      label: context.l10n.dailySessions,
                      icon: Icons.schedule,
                      keyboardType: TextInputType.number,
                    ),

                    const SizedBox(height: 24),

                    // إعدادات التحضير
                    _buildSectionTitle(context.l10n.attendanceSettings),
                    const SizedBox(height: 12),
                    _buildSwitchTile(
                      title: context.l10n.enableBarcode,
                      subtitle: context.l10n.barcodeAttendance,
                      value: _enableBarcodeScan,
                      onChanged: (value) => setState(() => _enableBarcodeScan = value),
                    ),
                    _buildSwitchTile(
                      title: context.l10n.parentNotification,
                      subtitle: context.l10n.notifyAbsence,
                      value: _notifyParents,
                      onChanged: (value) => setState(() => _notifyParents = value),
                    ),
                    _buildSwitchTile(
                      title: context.l10n.setAttendanceTime,
                      subtitle: context.l10n.preventAfter15,
                      value: _restrictAttendanceTime,
                      onChanged: (value) => setState(() => _restrictAttendanceTime = value),
                    ),

                    const SizedBox(height: 24),

                    // أيام العمل
                    _buildSectionTitle(context.l10n.workingDays),
                    const SizedBox(height: 12),
                    _buildWorkDaysSelector(),

                    const SizedBox(height: 48),
                    _buildSectionTitle('أدوات المطور (Developer Tools)'),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () => _showSeedConfirmationDialog(context),
                        icon: const Icon(Icons.science_rounded),
                        label: const Text('توليد بيانات تجريبية (Seed Test Data)'),
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.titleMedium.copyWith(
        color: AppColors.primary,
        fontWeight: FontWeight.bold,
      ),
    maxLines: 1, overflow: TextOverflow.ellipsis);
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey.withOpacity(0.05),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SwitchListTile(
        title: Text(title, style: AppTextStyles.subtitle1, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(subtitle, style: AppTextStyles.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
      ),
    );
  }

  Widget _buildWorkDaysSelector() {
    final days = [context.l10n.sunday, context.l10n.monday, context.l10n.tuesday, context.l10n.wednesday, context.l10n.thursday, context.l10n.friday, context.l10n.saturday];

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.weeklyWorkDays, style: AppTextStyles.subtitle1, maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(7, (index) {
                final isSelected = _selectedWorkDays[index];
                return FilterChip(
                  label: Text(
                    days[index], 
                    maxLines: 1, 
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isSelected ? AppColors.primary : Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedWorkDays[index] = selected;
                    });
                  },
                  selectedColor: AppColors.primary.withOpacity(0.2),
                  checkmarkColor: AppColors.primary,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveSettings() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final db = ref.read(attendanceDatabaseProvider);

      await _updateSetting(db, 'school_name', _schoolNameController.text);
      await _updateSetting(db, 'school_address', _schoolAddressController.text);
      await _updateSetting(db, 'school_phone', _schoolPhoneController.text);
      await _updateSetting(db, 'academic_year', _academicYearController.text);
      await _updateSetting(db, 'periods_per_day', _periodsCountController.text);

      // Refresh school name provider
      ref.invalidate(attSchoolNameProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.settingsSaved, maxLines: 1, overflow: TextOverflow.ellipsis),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.resetPassword, maxLines: 1, overflow: TextOverflow.ellipsis),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _updateSetting(AttendanceDatabase db, String key, String value) async {
    await (db.update(db.attSettings)..where((s) => s.key.equals(key)))
        .write(AttSettingsCompanion(value: Value(value)));
  }

  Future<void> _showSeedConfirmationDialog(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تحذير خطير!'),
        content: const Text('هذه العملية ستقوم بمسح كافة البيانات الحالية بالكامل (جداول، حضور، معلمين...) واستبدالها ببيانات تجريبية. هل أنت متأكد؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
            child: const Text('نعم، امسح كل شيء وأنشئ بيانات تجريبية'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      setState(() => _isSaving = true);
      try {
        await TestDataSeeder.seedAll(ref);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم توليد البيانات بنجاح!'), backgroundColor: Colors.green),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('حدث خطأ: \$e'), backgroundColor: Colors.red),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isSaving = false);
        }
      }
    }
  }

  @override
  void dispose() {
    _schoolNameController.dispose();
    _schoolAddressController.dispose();
    _schoolPhoneController.dispose();
    _academicYearController.dispose();
    _periodsCountController.dispose();
    super.dispose();
  }
}


