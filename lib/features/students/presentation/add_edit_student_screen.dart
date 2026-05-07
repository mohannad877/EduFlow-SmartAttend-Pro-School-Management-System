import 'package:school_schedule_app/core/utils/l10n_extension.dart';
import 'package:school_schedule_app/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:school_schedule_app/core/widgets/premium_app_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:school_schedule_app/core/theme/app_colors.dart';
import 'package:school_schedule_app/core/theme/app_text_styles.dart';
import 'package:school_schedule_app/core/utils/app_helpers.dart';
import 'package:school_schedule_app/core/utils/app_widgets.dart';
import 'package:school_schedule_app/core/database/attendance_providers.dart';
import 'package:school_schedule_app/features/students/domain/student_repository.dart';

/// شاشة إضافة/تعديل طالب
class AddEditStudentScreen extends ConsumerStatefulWidget {
  final AttStudent? student;

  const AddEditStudentScreen({super.key, this.student});

  @override
  ConsumerState<AddEditStudentScreen> createState() => _AddEditStudentScreenState();
}

class _AddEditStudentScreenState extends ConsumerState<AddEditStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  String? _selectedStage;
  String? _selectedGrade;
  String? _selectedSection;
  bool _isLoading = false;

  bool get _isEditMode => widget.student != null;
  List<String> _stages = [];

  @override
  void initState() {
    super.initState();
    _stages = [context.l10n.primaryLevel, context.l10n.middleSchool, context.l10n.highSchool];
    if (_isEditMode) {
      _nameController.text = widget.student!.name;
      _selectedStage = widget.student!.stage;
      _selectedGrade = widget.student!.grade;
      _selectedSection = widget.student!.section;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  List<String> _getGradesForStage() {
    if (_selectedStage == context.l10n.primaryLevel) {
      return [context.l10n.firstGrade, context.l10n.secondGrade, context.l10n.thirdGrade, context.l10n.fourthGrade, context.l10n.fifthGrade, context.l10n.sixthGrade];
    } else if (_selectedStage == context.l10n.middleSchool) {
      return [context.l10n.primarySectionA, context.l10n.primarySectionB, context.l10n.primarySectionC];
    } else if (_selectedStage == context.l10n.highSchool) {
      return [context.l10n.middleSectionA, context.l10n.middleSectionB, context.l10n.middleSectionC];
    }
    return [];
  }

  Future<void> _saveStudent() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedStage == null || _selectedGrade == null || _selectedSection == null) {
      AppSnackBar.show(context, message: context.l10n.selectGradeFirst, type: SnackBarType.warning);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final repo = ref.read(studentRepositoryProvider);

      if (_isEditMode) {
        await repo.updateStudent(
          widget.student!.copyWith(
            name: _nameController.text.trim(),
            stage: _selectedStage!,
            grade: _selectedGrade!,
            section: _selectedSection!,
          )
        );
        if (mounted) AppSnackBar.show(context, message: context.l10n.studentSaved, type: SnackBarType.success);
      } else {
        await repo.addStudent(
          name: _nameController.text.trim(),
          stage: _selectedStage!,
          grade: _selectedGrade!,
          section: _selectedSection!,
        );
        if (mounted) AppSnackBar.show(context, message: context.l10n.studentUpdated2, type: SnackBarType.success);
      }

      ref.refresh(filteredStudentsProvider(null));
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) AppSnackBar.show(context, message: context.l10n.saveFailed(''), type: SnackBarType.error);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PremiumAppBar(
        title: Text(_isEditMode ? context.l10n.editStudent : context.l10n.systemSettings, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          if (_isEditMode)
            IconButton(
              icon: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.error),
              onPressed: _confirmDelete,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // البطاقة الرئيسية
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: AppColors.softShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // العنوان
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            _isEditMode ? Icons.edit : Icons.person_add,
                            color: AppColors.primary,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(_isEditMode ? context.l10n.addStudent : context.l10n.addNewStudent, style: AppTextStyles.headline5, maxLines: 1, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 24),

                    // الاسم
                    _buildLabel(context.l10n.fullName, Icons.badge_outlined),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _nameController,
                      decoration: _inputDecoration(context.l10n.studentNameField),
                      validator: ValidationUtils.validateName,
                    ),

                    const SizedBox(height: 28),

                    // المرحلة
                    _buildLabel(context.l10n.school, Icons.school_outlined),
                    const SizedBox(height: 12),
                    _buildStageSelector(),

                    const SizedBox(height: 28),

                    // الصف
                    _buildLabel(context.l10n.grade, Icons.class_outlined),
                    const SizedBox(height: 12),
                    _buildDropdown(
                      value: _selectedGrade,
                      hint: context.l10n.selectSchool,
                      items: _getGradesForStage(),
                      onChanged: _selectedStage == null ? null : (v) => setState(() => _selectedGrade = v),
                    ),

                    const SizedBox(height: 28),

                    // الشعبة
                    _buildLabel(context.l10n.section, Icons.groups_outlined),
                    const SizedBox(height: 12),
                    _buildSectionSelector(),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),

              const SizedBox(height: 24),

              // معلومات الباركود
              if (_isEditMode) _buildBarcodeCard(),

              const SizedBox(height: 32),

              // الأزرار
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(title, style: AppTextStyles.subtitle2, maxLines: 1, overflow: TextOverflow.ellipsis),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: AppColors.background,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Theme.of(context).colorScheme.error)),
    );
  }

  Widget _buildStageSelector() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _stages.map((stage) {
        final isSelected = _selectedStage == stage;
        return InkWell(
          onTap: () => setState(() {
            _selectedStage = stage;
            _selectedGrade = null;
          }),
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isSelected ? AppColors.primary : AppColors.divider),
            ),
            child: Text(
              stage,
              style: AppTextStyles.body1.copyWith(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String hint,
    required List<String> items,
    required ValueChanged<String?>? onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint, maxLines: 1, overflow: TextOverflow.ellipsis),
          isExpanded: true,
          items: items.map((item) => DropdownMenuItem(value: item, child: Text(item, maxLines: 1, overflow: TextOverflow.ellipsis))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildSectionSelector() {
    final sections = [context.l10n.sectionA, context.l10n.sectionB, context.l10n.primarySectionD, context.l10n.primarySectionE, context.l10n.primarySectionF, context.l10n.primarySectionG];
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: sections.map((section) {
        final isSelected = _selectedSection == section;
        return InkWell(
          onTap: () => setState(() => _selectedSection = section),
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isSelected ? AppColors.primary : AppColors.divider),
            ),
            child: Center(
              child: Text(
                section,
                style: AppTextStyles.headline5.copyWith(color: isSelected ? Colors.white : AppColors.textPrimary),
              maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBarcodeCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.cardShadow,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.info.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.qr_code_2, color: AppColors.info, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.l10n.enterDetails, style: AppTextStyles.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(widget.student!.barcode, style: AppTextStyles.headline6.copyWith(fontFamily: 'monospace', letterSpacing: 2), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: _regenerateBarcode,
            icon: const Icon(Icons.refresh, size: 18),
            label: Text(context.l10n.openSource, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _isLoading ? null : () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
            child: Text(context.l10n.cancel, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _saveStudent,
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
            child: _isLoading
                ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(_isEditMode ? Icons.save : Icons.add),
                      const SizedBox(width: 8),
                      Text(_isEditMode ? context.l10n.saveStudent : context.l10n.addStudent2, maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 300.ms, duration: 400.ms);
  }

  Future<void> _regenerateBarcode() async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: context.l10n.termsOfService,
      message: context.l10n.confirmDeleteStudent,
      confirmLabel: context.l10n.openSource,
      icon: Icons.qr_code_2,
    );

    if (confirmed == true) {
      final repo = ref.read(studentRepositoryProvider);
      final newBarcode = await repo.regenerateBarcode(widget.student!.id);
      if (mounted) AppSnackBar.show(context, message: context.l10n.studentDeleted2, type: SnackBarType.success);
    }
  }

  Future<void> _confirmDelete() async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: context.l10n.deleteStudentAction,
      message: 'هل أنت متأكد من حذف "${widget.student!.name}"؟',
      confirmLabel: context.l10n.delete,
      confirmColor: Theme.of(context).colorScheme.error,
      icon: Icons.delete_forever,
    );

    if (confirmed == true) {
      final repo = ref.read(studentRepositoryProvider);
      await repo.deleteStudent(widget.student!.id);
      ref.refresh(filteredStudentsProvider(null));
      if (mounted) {
        AppSnackBar.show(context, message: context.l10n.studentDeleted3, type: SnackBarType.success);
        Navigator.pop(context);
      }
    }
  }
}


