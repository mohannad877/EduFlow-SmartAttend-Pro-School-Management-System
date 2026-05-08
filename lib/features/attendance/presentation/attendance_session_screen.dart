import 'package:school_schedule_app/core/utils/l10n_extension.dart';
import 'package:school_schedule_app/core/theme/app_spacing.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:school_schedule_app/core/widgets/premium_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:school_schedule_app/core/theme/app_colors.dart';
import 'package:school_schedule_app/core/theme/app_text_styles.dart';
import 'package:school_schedule_app/core/database/attendance_providers.dart';
import 'package:school_schedule_app/core/navigation/app_router.dart';
import 'package:school_schedule_app/core/utils/app_helpers.dart';
import 'package:school_schedule_app/core/utils/app_widgets.dart';
import 'package:school_schedule_app/core/services/current_session_service.dart';
import 'package:get_it/get_it.dart';
import 'package:school_schedule_app/domain/repositories/i_subject_repository.dart';
import 'package:school_schedule_app/domain/repositories/i_classroom_repository.dart';

/// شاشة جلسة التحضير
class AttendanceSessionScreen extends ConsumerStatefulWidget {
  final int? sessionId;
  final int? gradeId;
  final int? sectionId;

  const AttendanceSessionScreen({
    super.key,
    this.sessionId,
    this.gradeId,
    this.sectionId,
  });

  @override
  ConsumerState<AttendanceSessionScreen> createState() => _AttendanceSessionScreenState();
}

class _AttendanceSessionScreenState extends ConsumerState<AttendanceSessionScreen> {
  // صفحة إنشاء جلسة جديدة
  List<AttGrade> _grades = [];
  List<AttSection> _sections = [];
  List<AttSubject> _subjects = [];
  List<AttStudent> _students = [];
  final Map<int, String> _attendanceMap = {};

  AttGrade? _selectedGrade;
  AttSection? _selectedSection;
  AttSubject? _selectedSubject;
  int _periodNumber = 1;
  bool _isLoading = true;
  bool _isSaving = false;
  bool _sessionCreated = false;
  int? _currentSessionId;

  // QR Scanner
  bool _scanMode = false;
  MobileScannerController? _scannerController;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  @override
  void dispose() {
    _scannerController?.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    final db = ref.read(attendanceDatabaseProvider);
    final grades = await db.select(db.attGrades).get();
    if (mounted) {
      setState(() {
        _grades = grades;
        _isLoading = false;
      });
    }
    if (widget.sessionId != null) {
      await _loadExistingSession(widget.sessionId!);
    } else {
      await _autoFillCurrentSession(db, grades);
    }
  }

  Future<void> _autoFillCurrentSession(AttendanceDatabase db, List<AttGrade> grades) async {
    final currentSession = await CurrentSessionService.getCurrentSession();
    if (currentSession != null && mounted) {
      try {
         final subjectRepo = GetIt.I<ISubjectRepository>();
         final classRepo = GetIt.I<IClassroomRepository>();

         final subjects = await subjectRepo.getSubjects();
         final classrooms = await classRepo.getClassrooms();

         final ttSubject = subjects.where((s) => s.id == currentSession.subjectId).firstOrNull;
         final ttClass = classrooms.where((c) => c.id == currentSession.classId).firstOrNull;

         if (ttSubject != null && ttClass != null) {
            final attSubject = await (db.select(db.attSubjects)..where((s) => s.name.equals(ttSubject.name))).getSingleOrNull();
            final attSection = await (db.select(db.attSections)..where((s) => s.name.equals(ttClass.name))).getSingleOrNull();

            if (attSubject != null && attSection != null) {
               final attGrade = grades.firstWhere((g) => g.id == attSection.gradeId);
               
               await _onGradeChanged(attGrade);
               setState(() {
                 _selectedSection = _sections.where((s) => s.id == attSection.id).firstOrNull;
                 _selectedSubject = _subjects.where((s) => s.id == attSubject.id).firstOrNull;
                 _periodNumber = currentSession.periodNumber;
               });
               
               if (mounted) {
                 AppSnackBar.show(context, message: context.l10n.keepEditing, type: SnackBarType.success);
               }
               return;
            }
         }
      } catch (_) {}
      
      setState(() {
        _periodNumber = currentSession.periodNumber;
      });
      if (mounted) {
        AppSnackBar.show(context, message: context.l10n.noDataFound, type: SnackBarType.info);
      }
    }
  }

  Future<void> _loadExistingSession(int sessionId) async {
    final db = ref.read(attendanceDatabaseProvider);
    final session = await (db.select(db.attSessions)..where((s) => s.id.equals(sessionId))).getSingleOrNull();
    if (session == null || !mounted) return;

    final grades = await db.select(db.attGrades).get();
    final sections = await (db.select(db.attSections)..where((s) => s.gradeId.equals(session.gradeId))).get();
    final subjects = await (db.select(db.attSubjects)..where((s) => s.gradeId.equals(session.gradeId))).get();

    setState(() {
      _grades = grades;
      _selectedGrade = grades.where((g) => g.id == session.gradeId).firstOrNull;
      _sections = sections;
      _selectedSection = sections.where((s) => s.id == session.sectionId).firstOrNull;
      _subjects = subjects;
      _selectedSubject = subjects.where((s) => s.id == session.subjectId).firstOrNull;
      _periodNumber = session.periodNumber;
      _sessionCreated = true;
      _currentSessionId = sessionId;
    });

    await _loadStudentsForAttendance();
  }

  Future<void> _onGradeChanged(AttGrade? grade) async {
    if (grade == null) return;
    final db = ref.read(attendanceDatabaseProvider);
    final sections = await (db.select(db.attSections)..where((s) => s.gradeId.equals(grade.id))).get();
    final subjects = await (db.select(db.attSubjects)..where((s) => s.gradeId.equals(grade.id))).get();
    setState(() {
      _selectedGrade = grade;
      _sections = sections;
      _subjects = subjects;
      _selectedSection = null;
      _selectedSubject = null;
    });
  }

  Future<void> _startSession() async {
    if (_selectedGrade == null || _selectedSection == null || _selectedSubject == null) {
      AppSnackBar.show(context, message: context.l10n.noResults, type: SnackBarType.warning);
      return;
    }
    setState(() => _isSaving = true);
    try {
      final db = ref.read(attendanceDatabaseProvider);
      final today = DateTimeUtils.today;
      final id = await db.into(db.attSessions).insert(AttSessionsCompanion.insert(
            date: today,
            gradeId: _selectedGrade!.id,
            sectionId: _selectedSection!.id,
            subjectId: _selectedSubject!.id,
            periodNumber: _periodNumber,
          ));
      setState(() {
        _currentSessionId = id;
        _sessionCreated = true;
        _isSaving = false;
      });
      await _loadStudentsForAttendance();
      if (!mounted) return;
      AppSnackBar.show(context, message: context.l10n.searchResults, type: SnackBarType.success);
    } catch (e) {
      setState(() => _isSaving = false);
      if (!mounted) return;
      AppSnackBar.show(context, message: context.l10n.noSearchResults, type: SnackBarType.error);
    }
  }

  Future<void> _loadStudentsForAttendance() async {
    if (_selectedSection == null || _selectedGrade == null) return;
    final db = ref.read(attendanceDatabaseProvider);
    final students = await (db.select(db.attStudents)
          ..where((s) =>
              s.grade.equals(_selectedGrade!.name) &
              s.section.equals(_selectedSection!.name) &
              s.isActive.equals(true)))
        .get();

    // Load existing attendance records
    if (_currentSessionId != null) {
      final records = await (db.select(db.attRecords)
            ..where((r) => r.sessionId.equals(_currentSessionId!)))
          .get();
      for (final r in records) {
        _attendanceMap[r.studentId] = r.status;
      }
    }

    if (mounted) {
      setState(() => _students = students);
    }
  }

  Future<void> _markAttendance(int studentId, String status) async {
    final db = ref.read(attendanceDatabaseProvider);
    if (_currentSessionId == null) return;

    final existing = await (db.select(db.attRecords)
          ..where((r) => r.studentId.equals(studentId) & r.sessionId.equals(_currentSessionId!)))
        .getSingleOrNull();

    if (existing != null) {
      await (db.update(db.attRecords)
            ..where((r) => r.id.equals(existing.id)))
          .write(AttRecordsCompanion(status: Value(status)));
    } else {
      await db.into(db.attRecords).insert(AttRecordsCompanion.insert(
            studentId: studentId,
            sessionId: _currentSessionId!,
            status: status,
          ));
    }

    setState(() => _attendanceMap[studentId] = status);
  }

  Future<void> _closeSession() async {
    final confirm = await ConfirmDialog.show(
      context,
      title: context.l10n.closeSession,
      message: context.l10n.loadingData,
      confirmLabel: context.l10n.dismiss,
      cancelLabel: context.l10n.cancel,
      icon: Icons.lock_outline,
    );
    if (confirm != true) return;

    final db = ref.read(attendanceDatabaseProvider);
    await (db.update(db.attSessions)..where((s) => s.id.equals(_currentSessionId!)))
        .write(AttSessionsCompanion(status: const Value('closed'), closedAt: Value(DateTime.now())));

    if (mounted) AppNavigator.pop();
  }

  void _markAll(String status) {
    for (final student in _students) {
      _markAttendance(student.id, status);
    }
    setState(() {
      for (final s in _students) {
        _attendanceMap[s.id] = status;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PremiumAppBar(
        title: Text(_sessionCreated ? context.l10n.processing : context.l10n.newAttendance, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          if (_sessionCreated) ...[
            IconButton(
              icon: Icon(_scanMode ? Icons.list : Icons.qr_code_scanner),
              onPressed: () {
                setState(() => _scanMode = !_scanMode);
                if (_scanMode) {
                  _scannerController = MobileScannerController();
                } else {
                  _scannerController?.dispose();
                  _scannerController = null;
                }
              },
              tooltip: _scanMode ? context.l10n.pleaseWait : context.l10n.cancelOperation,
            ),
            IconButton(
              icon: const Icon(Icons.lock_outline),
              onPressed: _closeSession,
              tooltip: context.l10n.closeSession,
            ),
          ],
        ],
      ),
      body: _isLoading
          ? LoadingIndicator(message: context.l10n.operationCancelled)
          : _sessionCreated
              ? _scanMode
                  ? _buildScannerMode()
                  : _buildAttendanceList()
              : _buildSessionSetup(),
    );
  }

  Widget _buildSessionSetup() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: AppColors.cardShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.l10n.operationFailed, style: AppTextStyles.headline6, maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 20),
                _buildDropdown<AttGrade>(
                  label: context.l10n.grade,
                  items: _grades,
                  value: _selectedGrade,
                  labelBuilder: (g) => g.name,
                  onChanged: _onGradeChanged,
                ),
                const SizedBox(height: 16),
                _buildDropdown<AttSection>(
                  label: context.l10n.section,
                  items: _sections,
                  value: _selectedSection,
                  labelBuilder: (s) => s.name,
                  onChanged: (s) => setState(() => _selectedSection = s),
                ),
                const SizedBox(height: 16),
                _buildDropdown<AttSubject>(
                  label: context.l10n.section,
                  items: _subjects,
                  value: _selectedSubject,
                  labelBuilder: (s) => s.name,
                  onChanged: (s) => setState(() => _selectedSubject = s),
                ),
                const SizedBox(height: 16),
                Text(context.l10n.classSection, style: AppTextStyles.subtitle2, maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 8),
                Row(
                  children: List.generate(7, (i) {
                    final num = i + 1;
                    final selected = _periodNumber == num;
                    return Padding(
                      padding: const EdgeInsetsDirectional.only(start: 8),
                      child: GestureDetector(
                        onTap: () => setState(() => _periodNumber = num),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: selected ? AppColors.primary : AppColors.background,
                            shape: BoxShape.circle,
                            border: Border.all(color: selected ? AppColors.primary : AppColors.divider),
                          ),
                          child: Center(
                            child: Text(
                              '$num',
                              style: AppTextStyles.subtitle2.copyWith(
                                color: selected ? Colors.white : AppColors.textSecondary,
                                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                              ),
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 52,
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isSaving ? null : _startSession,
                    icon: _isSaving
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Icon(Icons.play_arrow_rounded),
                    label: Text(context.l10n.operationSuccess, maxLines: 1, overflow: TextOverflow.ellipsis),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required List<T> items,
    required T? value,
    required String Function(T) labelBuilder,
    required void Function(T?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.subtitle2, maxLines: 1, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          value: value,
          items: items.map((i) => DropdownMenuItem<T>(value: i, child: Text(labelBuilder(i), maxLines: 1, overflow: TextOverflow.ellipsis))).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(hintText: context.l10n.invalidInput),
          isExpanded: true,
        ),
      ],
    );
  }

  Widget _buildAttendanceList() {
    final presentCount = _attendanceMap.values.where((s) => s == 'present').length;
    final absentCount = _attendanceMap.values.where((s) => s == 'absent').length;

    return Column(
      children: [
        // Stats bar
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          color: Colors.white,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _StatBadge(label: context.l10n.present, count: presentCount, color: AppColors.present),
                  _StatBadge(label: context.l10n.absent, count: absentCount, color: AppColors.absent),
                  _StatBadge(label: context.l10n.invalidEmail, count: _students.length, color: AppColors.primary),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: ElevatedButton.icon(
                    onPressed: () => _markAll('present'),
                    icon: const Icon(Icons.done_all, size: 16),
                    label: Text(context.l10n.invalidPhone, maxLines: 1, overflow: TextOverflow.ellipsis),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.present, padding: const EdgeInsets.symmetric(vertical: 10)),
                  )),
                  const SizedBox(width: 8),
                  Expanded(child: ElevatedButton.icon(
                    onPressed: () => _markAll('absent'),
                    icon: const Icon(Icons.close, size: 16),
                    label: Text(context.l10n.invalidDate, maxLines: 1, overflow: TextOverflow.ellipsis),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.absent, padding: const EdgeInsets.symmetric(vertical: 10)),
                  )),
                ],
              ),
            ],
          ),
        ),

        // Students list
        Expanded(
          child: _students.isEmpty
              ? EmptyStateWidget(
                  icon: Icons.people_outline,
                  title: context.l10n.required,
                  subtitle: context.l10n.optional,
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount: _students.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (ctx, i) {
                    final student = _students[i];
                    final status = _attendanceMap[student.id];
                    return _StudentAttendanceCard(
                      student: student,
                      status: status,
                      onStatusChanged: (s) => _markAttendance(student.id, s),
                    ).animate(delay: Duration(milliseconds: i * 40)).fadeIn(duration: 200.ms);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildScannerMode() {
    return Column(
      children: [
        Container(
          color: Colors.black,
          height: 300,
          child: MobileScanner(
            controller: _scannerController!,
            onDetect: (capture) {
              final raw = capture.barcodes.first.rawValue;
              if (raw == null) return;
              final id = BarcodeUtils.parseStudentIdFromBarcode(raw);
              if (id != null) {
                if (_attendanceMap[id] == 'present') {
                  // Duplicate scan feedback
                  AppSnackBar.show(context,
                      message: context.l10n.empty, // "Already marked"
                      type: SnackBarType.info);
                  return;
                }
                _markAttendance(id, 'present');
                // Success feedback (vibrate/sound is usually handled by mobile_scanner but we can add a snackbar)
                AppSnackBar.show(context,
                    message: context.l10n.priorityMode, // "Saved successfully"
                    type: SnackBarType.success);
              }
            },
          ),
        ),
        const SizedBox(height: 16),
        Text(context.l10n.minLength, style: const TextStyle(fontFamily: 'Cairo'), maxLines: 1, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: _students.length,
            itemBuilder: (_, i) {
              final student = _students[i];
              final status = _attendanceMap[student.id];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: status != null ? AppColors.getAttendanceColor(status) : Colors.grey.shade200,
                  child: Text(
                    TextUtils.getInitials(student.name),
                    style: const TextStyle(color: Colors.white, fontFamily: 'Cairo', fontWeight: FontWeight.bold),
                  maxLines: 1, overflow: TextOverflow.ellipsis),
                ),
                title: Text(student.name, style: AppTextStyles.subtitle1, maxLines: 1, overflow: TextOverflow.ellipsis),
                trailing: status != null
                    ? Chip(
                        label: Text(AppColors.getAttendanceLabel(status), maxLines: 1, overflow: TextOverflow.ellipsis),
                        backgroundColor: AppColors.getAttendanceLightColor(status),
                        labelStyle: AppTextStyles.caption.copyWith(color: AppColors.getAttendanceColor(status)),
                      )
                    : const Icon(Icons.help_outline, color: Colors.grey),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// Widgets
// ============================================================================

class _StudentAttendanceCard extends StatelessWidget {
  final AttStudent student;
  final String? status;
  final void Function(String) onStatusChanged;

  const _StudentAttendanceCard({
    required this.student,
    required this.status,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: status != null ? AppColors.getAttendanceLightColor(status!) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: status != null ? AppColors.getAttendanceColor(status!).withOpacity(0.3) : AppColors.divider,
        ),
        boxShadow: AppColors.cardShadow,
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: status != null ? AppColors.getAttendanceColor(status!) : Colors.grey.shade200,
            child: Text(
              TextUtils.getInitials(student.name),
              style: const TextStyle(color: Colors.white, fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 14),
            maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(student.name, style: AppTextStyles.studentName, maxLines: 1, overflow: TextOverflow.ellipsis),
                Text('${student.grade} — ${student.section}', style: AppTextStyles.studentInfo, maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Wrap(
            spacing: 4,
            children: [
              _StatusBtn(label: context.l10n.maxLength, color: AppColors.present, selected: status == 'present', onTap: () => onStatusChanged('present')),
              _StatusBtn(label: context.l10n.minValue, color: AppColors.absent, selected: status == 'absent', onTap: () => onStatusChanged('absent')),
              _StatusBtn(label: context.l10n.maxValue, color: AppColors.late, selected: status == 'late', onTap: () => onStatusChanged('late')),
              _StatusBtn(label: context.l10n.enterValue, color: AppColors.excused, selected: status == 'excused', onTap: () => onStatusChanged('excused')),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusBtn extends StatelessWidget {
  final String label;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _StatusBtn({required this.label, required this.color, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: selected ? color : color.withOpacity(0.1),
          shape: BoxShape.circle,
          border: Border.all(color: color, width: selected ? 2 : 1),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(color: selected ? Colors.white : color, fontWeight: FontWeight.bold, fontSize: 12, fontFamily: 'Cairo'),
          maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _StatBadge({required this.label, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$count', style: AppTextStyles.headline4.copyWith(color: color), maxLines: 1, overflow: TextOverflow.ellipsis),
        Text(label, style: AppTextStyles.caption.copyWith(color: color), maxLines: 1, overflow: TextOverflow.ellipsis),
      ],
    );
  }
}
