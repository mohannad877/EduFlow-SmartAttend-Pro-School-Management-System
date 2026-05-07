import 'package:school_schedule_app/core/utils/l10n_extension.dart';
import 'package:school_schedule_app/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:school_schedule_app/core/widgets/premium_app_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:school_schedule_app/core/theme/app_colors.dart';
import 'package:school_schedule_app/core/theme/app_text_styles.dart';
import 'package:school_schedule_app/core/utils/app_widgets.dart';
import 'package:school_schedule_app/core/database/attendance_providers.dart';
import 'package:school_schedule_app/core/navigation/app_router.dart';
import 'package:school_schedule_app/features/students/domain/student_repository.dart';
import 'package:school_schedule_app/core/services/attendance_excel_service.dart';
import 'package:school_schedule_app/core/services/attendance_pdf_service.dart';
import 'package:school_schedule_app/core/services/sync_service.dart';

/// شاشة قائمة الطلاب
class StudentsListScreen extends ConsumerStatefulWidget {
  const StudentsListScreen({super.key});

  @override
  ConsumerState<StudentsListScreen> createState() => _StudentsListScreenState();
}

class _StudentsListScreenState extends ConsumerState<StudentsListScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isSearching = false;
  Set<int> _selectedStudents = {};
  bool _isSelectionMode = false;

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleSelectionMode() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      if (!_isSelectionMode) {
        _selectedStudents.clear();
      }
    });
  }

  void _toggleStudentSelection(int studentId) {
    setState(() {
      if (_selectedStudents.contains(studentId)) {
        _selectedStudents.remove(studentId);
      } else {
        _selectedStudents.add(studentId);
      }

      if (_selectedStudents.isEmpty) {
        _isSelectionMode = false;
      }
    });
  }

  void _selectAllStudents(List<AttStudent> students) {
    setState(() {
      if (_selectedStudents.length == students.length) {
        _selectedStudents.clear();
      } else {
        _selectedStudents = students.map((s) => s.id).toSet();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(currentStudentFilterProvider);
    final studentsAsync = ref.watch(filteredStudentsProvider(filter));

    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // شريط البحث والفلتر
          _buildSearchAndFilterBar(),

          // شريط الفلتر النشط
          if (filter?.hasFilter ?? false)
            _buildActiveFiltersChips(filter!),

          // قائمة الطلاب
          Expanded(
            child: studentsAsync.when(
              data: (students) => _buildStudentsList(students),
              loading: () => LoadingIndicator(message: context.l10n.forbidden),
              error: (error, _) => _buildErrorState(error.toString()),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
      bottomNavigationBar: _isSelectionMode ? _buildSelectionBar() : null,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PremiumAppBar(
      title: _isSearching
          ? TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: context.l10n.searchStudent,
                border: InputBorder.none,
                hintStyle: TextStyle(color: AppColors.textHint),
              ),
              style: AppTextStyles.body1,
              onChanged: (value) {
                final currentFilter = ref.read(currentStudentFilterProvider);
                ref.read(currentStudentFilterProvider.notifier).state =
                    (currentFilter ?? const StudentFilterParams()).copyWith(searchQuery: value);
              },
            )
          : Text(context.l10n.auto_key_1776, maxLines: 1, overflow: TextOverflow.ellipsis),
      actions: [
        // زر البحث
        IconButton(
          icon: Icon(_isSearching ? Icons.close : Icons.search),
          onPressed: () {
            setState(() {
              _isSearching = !_isSearching;
              if (!_isSearching) {
                _searchController.clear();
                final currentFilter = ref.read(currentStudentFilterProvider);
                ref.read(currentStudentFilterProvider.notifier).state =
                    currentFilter?.copyWith(clearSearch: true);
              }
            });
          },
        ),
        // زر التحديد المتعدد
        IconButton(
          icon: Icon(_isSelectionMode ? Icons.close : Icons.checklist),
          onPressed: _toggleSelectionMode,
        ),
        // المزيد
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) {
            switch (value) {
              case 'import':
                AppNavigator.push(AppRoutes.importStudents);
                break;
              case 'export':
                _exportStudents();
                break;
              case 'sort':
                _showSortOptions();
                break;
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'import',
              child: ListTile(
                leading: const Icon(Icons.upload_file),
                title: Text(context.l10n.importStudentsLabel, maxLines: 1, overflow: TextOverflow.ellipsis),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            PopupMenuItem(
              value: 'export',
              child: ListTile(
                leading: const Icon(Icons.download),
                title: Text(context.l10n.auto_key_1777, maxLines: 1, overflow: TextOverflow.ellipsis),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            PopupMenuItem(
              value: 'sort',
              child: ListTile(
                leading: const Icon(Icons.sort),
                title: Text(context.l10n.auto_key_1778, maxLines: 1, overflow: TextOverflow.ellipsis),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchAndFilterBar() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          // زر الفلتر
          Expanded(
            child: InkWell(
              onTap: _showFilterBottomSheet,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: AppColors.cardShadow,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.filter_list, color: AppColors.primary, size: 22),
                    const SizedBox(width: 12),
                    Text(context.l10n.auto_key_1779, style: AppTextStyles.body2, maxLines: 1, overflow: TextOverflow.ellipsis),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Consumer(
                        builder: (context, ref, _) {
                          final count = ref.watch(studentsCountProvider);
                          return count.when(
                            data: (c) => Text(context.l10n.auto_key_1780, style: AppTextStyles.caption.copyWith(color: AppColors.primary), maxLines: 1, overflow: TextOverflow.ellipsis),
                            loading: () => const SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 2)),
                            error: (_, __) => const Text('--', maxLines: 1, overflow: TextOverflow.ellipsis),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFiltersChips(StudentFilterParams filter) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          if (filter.stage != null)
            _buildFilterChip(
              label: context.l10n.auto_key_1781,
              onRemove: () {
                ref.read(currentStudentFilterProvider.notifier).state =
                    filter.copyWith(clearStage: true);
              },
            ),
          if (filter.grade != null)
            _buildFilterChip(
              label: context.l10n.auto_key_1782,
              onRemove: () {
                ref.read(currentStudentFilterProvider.notifier).state =
                    filter.copyWith(clearGrade: true);
              },
            ),
          if (filter.section != null)
            _buildFilterChip(
              label: context.l10n.auto_key_1783,
              onRemove: () {
                ref.read(currentStudentFilterProvider.notifier).state =
                    filter.copyWith(clearSection: true);
              },
            ),
          if (filter.searchQuery?.isNotEmpty ?? false)
            _buildFilterChip(
              label: context.l10n.auto_key_1784,
              onRemove: () {
                _searchController.clear();
                ref.read(currentStudentFilterProvider.notifier).state =
                    filter.copyWith(clearSearch: true);
              },
            ),
          // زر مسح الكل
          TextButton.icon(
            onPressed: () {
              _searchController.clear();
              ref.read(currentStudentFilterProvider.notifier).state = null;
            },
            icon: const Icon(Icons.clear_all, size: 18),
            label: Text(context.l10n.verifyEmail, maxLines: 1, overflow: TextOverflow.ellipsis),
            style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({required String label, required VoidCallback onRemove}) {
    return Container(
      margin: const EdgeInsetsDirectional.only(start: 8),
      child: Chip(
        label: Text(label, style: AppTextStyles.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
        deleteIcon: const Icon(Icons.close, size: 16),
        onDeleted: onRemove,
        backgroundColor: AppColors.primaryLight.withOpacity(0.2),
        deleteIconColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  Widget _buildStudentsList(List<AttStudent> students) {
    if (students.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.people_outline,
        title: context.l10n.required,
        subtitle: context.l10n.auto_key_1785,
        actionLabel: context.l10n.addStudentLabel,
        onAction: () => AppNavigator.push(AppRoutes.addStudent),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: students.length,
      itemBuilder: (context, index) {
        final student = students[index];
        final isSelected = _selectedStudents.contains(student.id);

        return _StudentListItem(
          student: student,
          isSelectionMode: _isSelectionMode,
          isSelected: isSelected,
          onTap: () {
            if (_isSelectionMode) {
              _toggleStudentSelection(student.id);
            } else {
              _showStudentDetails(student);
            }
          },
          onLongPress: () {
            if (!_isSelectionMode) {
              _toggleSelectionMode();
              _toggleStudentSelection(student.id);
            }
          },
        ).animate(delay: Duration(milliseconds: index * 50))
            .fadeIn(duration: 300.ms)
            .slideX(begin: 0.1, end: 0);
      },
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Theme.of(context).colorScheme.error),
          const SizedBox(height: 16),
          Text(context.l10n.saveFailed(''), style: AppTextStyles.headline5, maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 8),
          Text(error, style: AppTextStyles.body2, maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => ref.refresh(filteredStudentsProvider(null)),
            icon: const Icon(Icons.refresh),
            label: Text(context.l10n.retry, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    final isAdmin = ref.watch(authStateProvider).isAdmin;
    if (!isAdmin) return const SizedBox.shrink();
    return FloatingActionButton.extended(
      onPressed: () => AppNavigator.push(AppRoutes.addStudent),
      icon: const Icon(Icons.person_add),
      label: Text(context.l10n.addStudentLabel, maxLines: 1, overflow: TextOverflow.ellipsis),
      backgroundColor: AppColors.primary,
    ).animate().scale(delay: 500.ms, duration: 300.ms);
  }

  Widget _buildSelectionBar() {
    final isAdmin = ref.watch(authStateProvider).isAdmin;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // عدد المحدد
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                context.l10n.auto_key_1786,
                style: AppTextStyles.subtitle2.copyWith(color: AppColors.primary),
              maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
            const Spacer(),
            // أزرار الإجراءات
            IconButton(
              icon: const Icon(Icons.qr_code_2, color: AppColors.info),
              onPressed: () => _generateBarcodesForSelected(),
              tooltip: context.l10n.auto_key_1787,
            ),
            IconButton(
              icon: Icon(Icons.print, color: Theme.of(context).colorScheme.secondary),
              onPressed: () => _printSelectedStudents(),
              tooltip: context.l10n.reportBug,
            ),
            // زر الحذف للمشرف فقط
            if (isAdmin)
              IconButton(
                icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
                onPressed: () => _deleteSelectedStudents(),
                tooltip: context.l10n.auto_key_1788,
              ),
          ],
        ),
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _FilterBottomSheet(),
    );
  }

  void _showStudentDetails(AttStudent student) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _StudentDetailsSheet(student: student),
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.sort_by_alpha),
            title: Text(context.l10n.auto_key_1789, maxLines: 1, overflow: TextOverflow.ellipsis),
            onTap: () {
              Navigator.pop(context);
              final currentFilter = ref.read(currentStudentFilterProvider);
              ref.read(currentStudentFilterProvider.notifier).state = 
                  (currentFilter ?? const StudentFilterParams()).copyWith(sortBy: 'name');
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: Text(context.l10n.auto_key_1790, maxLines: 1, overflow: TextOverflow.ellipsis),
            onTap: () {
              Navigator.pop(context);
              final currentFilter = ref.read(currentStudentFilterProvider);
              ref.read(currentStudentFilterProvider.notifier).state = 
                  (currentFilter ?? const StudentFilterParams()).copyWith(sortBy: 'date');
            },
          ),
          ListTile(
            leading: const Icon(Icons.qr_code),
            title: Text(context.l10n.auto_key_1791, maxLines: 1, overflow: TextOverflow.ellipsis),
            onTap: () {
              Navigator.pop(context);
              final currentFilter = ref.read(currentStudentFilterProvider);
              ref.read(currentStudentFilterProvider.notifier).state = 
                  (currentFilter ?? const StudentFilterParams()).copyWith(sortBy: 'barcode');
            },
          ),
        ],
      ),
    );
  }

  void _exportStudents() async {
    _showSnackbar(context.l10n.auto_key_1792);
    final filter = ref.read(currentStudentFilterProvider);
    final students = await ref.read(filteredStudentsProvider(filter).future);
    
    if (students.isEmpty) {
      _showSnackbar(context.l10n.auto_key_1793);
      return;
    }

    final path = await AttendanceExcelService.exportStudentsList(students);
    if (path != null) {
      _showSnackbar(context.l10n.auto_key_1794);
    } else {
      _showSnackbar(context.l10n.auto_key_1795);
    }
  }

  void _generateBarcodesForSelected() async {
    if (_selectedStudents.isEmpty) {
      _showSnackbar(context.l10n.auto_key_1796);
      return;
    }
    
    final filter = ref.read(currentStudentFilterProvider);
    final allList = await ref.read(filteredStudentsProvider(filter).future);
    final selectedStudentsList = allList.where((s) => _selectedStudents.contains(s.id)).toList();
    
    // تمرير قائمة الطلاب المحددين إلى شاشة طباعة البطاقات
    AppNavigator.push(AppRoutes.printBarcodes, arguments: selectedStudentsList);
  }

  void _printSelectedStudents() async {
    if (_selectedStudents.isEmpty) {
      _showSnackbar(context.l10n.auto_key_1796);
      return;
    }
    
    _showSnackbar(context.l10n.auto_key_1797);
    final l10n = context.l10n;
    final db = ref.read(attendanceDatabaseProvider);
    final settings = await db.select(db.attSettings).get();
    final schoolName = settings.where((s) => s.key == 'school_name').firstOrNull?.value ?? l10n.schoolName;
    
    final filter = ref.read(currentStudentFilterProvider);
    final allList = await ref.read(filteredStudentsProvider(filter).future);
    final selectedStudentsList = allList.where((s) => _selectedStudents.contains(s.id)).toList();

    await AttendancePdfService.printStudentsList(
      students: selectedStudentsList,
      schoolName: schoolName,
    );
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message, maxLines: 1, overflow: TextOverflow.ellipsis)));
  }

  Future<void> _deleteSelectedStudents() async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: context.l10n.auto_key_1798,
      message: context.l10n.auto_key_1799,
      confirmLabel: context.l10n.delete,
      confirmColor: Theme.of(context).colorScheme.error,
      icon: Icons.delete_forever,
    );

    if (confirmed == true) {
      final db = ref.read(attendanceDatabaseProvider);
      final syncService = SyncService(db);
      final repo = ref.read(studentRepositoryProvider);
      
      // جلب بيانات الطلاب قبل الحذف لتسجيلها في Audit Log
      final filter = ref.read(currentStudentFilterProvider);
      final allList = await ref.read(filteredStudentsProvider(filter).future);
      final toDelete = allList.where((s) => _selectedStudents.contains(s.id)).toList();

      // تسجيل كل طالب سيتم حذفه في Audit Log
      for (final student in toDelete) {
        await syncService.syncStudentDeletion(
          studentId: student.id,
          studentName: student.name,
          studentBarcode: student.barcode,
        );
      }
      
      await repo.deleteMultipleStudents(_selectedStudents.toList());
      ref.invalidate(filteredStudentsProvider);
      setState(() {
        _selectedStudents.clear();
        _isSelectionMode = false;
      });
      if (mounted) {
        AppSnackBar.show(context, message: context.l10n.auto_key_1800, type: SnackBarType.success);
      }
    }
  }
}

// ============ عنصر قائمة الطالب ============

class _StudentListItem extends StatelessWidget {
  final AttStudent student;
  final bool isSelectionMode;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _StudentListItem({
    required this.student,
    required this.isSelectionMode,
    required this.isSelected,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryLight.withOpacity(0.15) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isSelected ? Border.all(color: AppColors.primary, width: 2) : null,
        boxShadow: AppColors.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                // مربع الاختيار أو الصورة الرمزية
                if (isSelectionMode)
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : AppColors.background,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      isSelected ? Icons.check : Icons.check_box_outline_blank,
                      color: isSelected ? Colors.white : AppColors.textHint,
                    ),
                  )
                else
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withOpacity(0.7),
                          AppColors.primaryDark,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Text(
                        student.name.isNotEmpty ? student.name[0] : context.l10n.auto_key_1801,
                        style: AppTextStyles.headline4.copyWith(color: Colors.white),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                  ),
                const SizedBox(width: 16),
                // المعلومات
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student.name,
                        style: AppTextStyles.studentName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          _buildInfoChip(Icons.school_outlined, student.stage),
                          const SizedBox(width: 8),
                          _buildInfoChip(Icons.class_outlined, student.grade),
                          const SizedBox(width: 8),
                          _buildInfoChip(Icons.groups_outlined, student.section),
                        ],
                      ),
                    ],
                  ),
                ),
                // الباركود
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.qr_code_2, size: 20, color: AppColors.textHint),
                      const SizedBox(height: 2),
                      Text(
                        student.barcode.substring(0, 6),
                        style: AppTextStyles.caption.copyWith(
                          fontFamily: 'monospace',
                          fontSize: 10,
                        ),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textHint),
        const SizedBox(width: 4),
        Text(
          text,
          style: AppTextStyles.caption,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

// ============ ورقة الفلتر السفلية ============

class _FilterBottomSheet extends ConsumerStatefulWidget {
  const _FilterBottomSheet();

  @override
  ConsumerState<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends ConsumerState<_FilterBottomSheet> {
  String? _selectedStage;
  String? _selectedGrade;
  String? _selectedSection;
  List<String> _stages = [];

  @override
  void initState() {
    super.initState();
    _stages = [context.l10n.primaryLevel, context.l10n.middleSchool, context.l10n.highSchool];
    final filter = ref.read(currentStudentFilterProvider);
    _selectedStage = filter?.stage;
    _selectedGrade = filter?.grade;
    _selectedSection = filter?.section;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // المقبض
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // العنوان
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                const Icon(Icons.filter_list, color: AppColors.primary),
                const SizedBox(width: 12),
                Text(context.l10n.auto_key_1802, style: AppTextStyles.headline5, maxLines: 1, overflow: TextOverflow.ellipsis),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedStage = null;
                      _selectedGrade = null;
                      _selectedSection = null;
                    });
                  },
                  child: Text(context.l10n.clear, maxLines: 1, overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // المحتوى
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // المرحلة
                Text(context.l10n.school, style: AppTextStyles.subtitle2, maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: _stages.map((stage) {
                    final isSelected = _selectedStage == stage;
                    return ChoiceChip(
                      label: Text(stage, maxLines: 1, overflow: TextOverflow.ellipsis),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedStage = selected ? stage : null;
                          _selectedGrade = null;
                          _selectedSection = null;
                        });
                      },
                      selectedColor: AppColors.primaryLight,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                // الصف (قائمة ديناميكية)
                Text(context.l10n.grade, style: AppTextStyles.subtitle2, maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedGrade,
                      hint: Text(context.l10n.selectSchool, maxLines: 1, overflow: TextOverflow.ellipsis),
                      isExpanded: true,
                      items: _getGradesForStage().map((grade) {
                        return DropdownMenuItem(value: grade, child: Text(grade, maxLines: 1, overflow: TextOverflow.ellipsis));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedGrade = value;
                          _selectedSection = null;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // الشعبة
                Text(context.l10n.section, style: AppTextStyles.subtitle2, maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedSection,
                      hint: Text(context.l10n.auto_key_1803, maxLines: 1, overflow: TextOverflow.ellipsis),
                      isExpanded: true,
                      items: [context.l10n.sectionA, context.l10n.sectionB, context.l10n.primarySectionD, context.l10n.primarySectionE].map((section) {
                        return DropdownMenuItem(value: section, child: Text(section, maxLines: 1, overflow: TextOverflow.ellipsis));
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _selectedSection = value);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          // زر التطبيق
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _applyFilter,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(context.l10n.auto_key_1804, maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
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

  void _applyFilter() {
    ref.read(currentStudentFilterProvider.notifier).state = StudentFilterParams(
      stage: _selectedStage,
      grade: _selectedGrade,
      section: _selectedSection,
    );
    Navigator.pop(context);
  }
}

// ============ ورقة تفاصيل الطالب ============

class _StudentDetailsSheet extends ConsumerWidget {
  final AttStudent student;

  const _StudentDetailsSheet({required this.student});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAdmin = ref.watch(authStateProvider).isAdmin;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // المقبض
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          // الصورة الرمزية
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                student.name.isNotEmpty ? student.name[0] : context.l10n.auto_key_1801,
                style: AppTextStyles.headline2.copyWith(color: Colors.white),
              maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ),
          const SizedBox(height: 16),
          // الاسم
          Text(student.name, style: AppTextStyles.headline4, maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 8),
          // المعلومات
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildInfoChip(Icons.school, student.stage),
              const SizedBox(width: 12),
              _buildInfoChip(Icons.class_, student.grade),
              const SizedBox(width: 12),
              _buildInfoChip(Icons.groups, student.section),
            ],
          ),
          const SizedBox(height: 24),
          // الباركود
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.qr_code_2, size: 40, color: AppColors.primary),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(context.l10n.enterDetails, style: AppTextStyles.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
                      Text(
                        student.barcode,
                        style: AppTextStyles.headline6.copyWith(
                          fontFamily: 'monospace',
                          letterSpacing: 2,
                        ),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy, color: AppColors.primary),
                  onPressed: () {
                    // نسخ الباركود
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // الأزرار
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                if (isAdmin) ...
                  [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          AppNavigator.push(AppRoutes.editStudent, arguments: student);
                        },
                        icon: const Icon(Icons.edit),
                        label: Text(context.l10n.edit, maxLines: 1, overflow: TextOverflow.ellipsis),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      AppNavigator.push(AppRoutes.printBarcodes, arguments: [student]);
                    },
                    icon: const Icon(Icons.print),
                    label: Text(context.l10n.reportBug, maxLines: 1, overflow: TextOverflow.ellipsis),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(text, style: AppTextStyles.caption.copyWith(color: AppColors.primary), maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}



