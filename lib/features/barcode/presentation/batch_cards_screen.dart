import 'package:school_schedule_app/core/utils/l10n_extension.dart';
import 'package:school_schedule_app/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:school_schedule_app/core/widgets/premium_app_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:school_schedule_app/core/theme/app_colors.dart';
import 'package:school_schedule_app/core/theme/app_text_styles.dart';
import 'package:school_schedule_app/core/database/attendance_providers.dart';
import 'package:school_schedule_app/core/utils/app_widgets.dart';
import 'package:school_schedule_app/core/utils/app_helpers.dart';
import 'package:school_schedule_app/core/navigation/app_router.dart';
import 'package:drift/drift.dart' hide Column;

/// شاشة طباعة بطاقات متعددة للطلاب
class BatchCardsScreen extends ConsumerStatefulWidget {
  final List<AttStudent>? initialSelectedStudents;

  const BatchCardsScreen({super.key, this.initialSelectedStudents});

  @override
  ConsumerState<BatchCardsScreen> createState() => _BatchCardsScreenState();
}

class _BatchCardsScreenState extends ConsumerState<BatchCardsScreen> {
  List<AttStudent> _allStudents = [];
  List<AttStudent> _filteredStudents = [];
  Set<int> _selectedIds = {};
  bool _isLoading = true;
  bool _isPrinting = false;
  String? _selectedGrade;
  String? _selectedSection;
  List<String> _availableGrades = [];
  List<String> _availableSections = [];
  bool _selectAll = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialSelectedStudents != null) {
      _selectedIds = widget.initialSelectedStudents!.map((s) => s.id).toSet();
    }
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    final db = ref.read(attendanceDatabaseProvider);
    final students = await (db.select(db.attStudents)
          ..where((s) => s.isActive.equals(true))
          ..orderBy([(s) => OrderingTerm.asc(s.name)]))
        .get();

    final grades = students.map((s) => s.grade).toSet().toList()..sort();
    final sections = students.map((s) => s.section).toSet().toList()..sort();

    if (mounted) {
      setState(() {
        _allStudents = students;
        _filteredStudents = students;
        _availableGrades = grades;
        _availableSections = sections;
        _isLoading = false;
      });
    }
  }

  void _applyFilter() {
    setState(() {
      _filteredStudents = _allStudents.where((s) {
        if (_selectedGrade != null && s.grade != _selectedGrade) return false;
        if (_selectedSection != null && s.section != _selectedSection) return false;
        return true;
      }).toList();
      _selectedIds.clear();
      _selectAll = false;
    });
  }

  void _toggleSelectAll() {
    setState(() {
      _selectAll = !_selectAll;
      if (_selectAll) {
        _selectedIds = _filteredStudents.map((s) => s.id).toSet();
      } else {
        _selectedIds.clear();
      }
    });
  }

  Future<void> _printSelectedCards() async {
    if (_selectedIds.isEmpty) {
      AppSnackBar.show(context, message: context.l10n.verificationExpired, type: SnackBarType.warning);
      return;
    }

    setState(() => _isPrinting = true);

    try {
      final db = ref.read(attendanceDatabaseProvider);
      final settings = await db.select(db.attSettings).get();
      final schoolName = settings.where((s) => s.key == 'school_name').firstOrNull?.value ?? context.l10n.schoolName;

      final selected = _filteredStudents.where((s) => _selectedIds.contains(s.id)).toList();

      final pdf = pw.Document();

      // 4 cards per page
      for (var i = 0; i < selected.length; i += 4) {
        final batch = selected.skip(i).take(4).toList();
        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            margin: const pw.EdgeInsets.all(AppSpacing.md),
            build: (ctx) => pw.Wrap(
              spacing: 8,
              runSpacing: 8,
              children: batch.map((student) {
                final qrData = BarcodeUtils.generateQRData(
                  id: student.id,
                  name: student.name,
                  grade: student.grade,
                  section: student.section,
                );
                return pw.Container(
                  width: 180,
                  height: 250,
                  padding: const pw.EdgeInsets.all(AppSpacing.md),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey300),
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text(
                        schoolName,
                        style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
                        textAlign: pw.TextAlign.center,
                     ),
                      pw.SizedBox(height: 8),
                      pw.BarcodeWidget(
                        barcode: pw.Barcode.qrCode(),
                        data: qrData,
                        width: 100,
                        height: 100,
                      ),
                      pw.SizedBox(height: 8),
                      pw.Text(
                        student.name,
                        style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
                        textAlign: pw.TextAlign.center,
                     ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        '${student.grade} — ${student.section}',
                        style: const pw.TextStyle(fontSize: 9),
                     ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        student.barcode,
                        style: const pw.TextStyle(fontSize: 8, letterSpacing: 1.5),
                     ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        );
      }

      await Printing.layoutPdf(onLayout: (_) => pdf.save());
    } catch (e) {
      if (mounted) AppSnackBar.show(context, message: context.l10n.invalidToken, type: SnackBarType.error);
    } finally {
      if (mounted) setState(() => _isPrinting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PremiumAppBar(
        title: Text(context.l10n.sessionExpired),
        actions: [
          if (_selectedIds.isNotEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Chip(
                  label: Text(
                    context.l10n.loginRequired,
                    style: const TextStyle(color: Colors.white, fontFamily: 'Cairo', fontSize: 12),
                 ),
                  backgroundColor: AppColors.primary,
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.print_rounded),
            onPressed: _isPrinting ? null : _printSelectedCards,
            tooltip: context.l10n.unauthorized,
          ),
        ],
      ),
      body: _isLoading
          ? LoadingIndicator(message: context.l10n.forbidden)
          : Column(
              children: [
                // Filters
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String?>(
                              value: _selectedGrade,
                              hint: Text(context.l10n.notFound),
                              items: [
                                DropdownMenuItem(value: null, child: Text(context.l10n.notFound)),
                                ..._availableGrades.map((g) => DropdownMenuItem(value: g, child: Text(g))),
                              ],
                              onChanged: (v) {
                                setState(() => _selectedGrade = v);
                                _applyFilter();
                              },
                              decoration: InputDecoration(labelText: context.l10n.grade, isDense: true),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButtonFormField<String?>(
                              value: _selectedSection,
                              hint: Text(context.l10n.serverError),
                              items: [
                                DropdownMenuItem(value: null, child: Text(context.l10n.serverError)),
                                ..._availableSections.map((s) => DropdownMenuItem(value: s, child: Text(s))),
                              ],
                              onChanged: (v) {
                                setState(() => _selectedSection = v);
                                _applyFilter();
                              },
                              decoration: InputDecoration(labelText: context.l10n.section, isDense: true),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Checkbox(
                            value: _selectAll,
                            onChanged: (_) => _toggleSelectAll(),
                          ),
                          Text(
                            context.l10n.networkError,
                            style: AppTextStyles.body2,
                         ),
                          const Spacer(),
                          Text(
                            context.l10n.connectionError,
                            style: AppTextStyles.caption.copyWith(color: AppColors.primary),
                         ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Student grid
                Expanded(
                  child: _filteredStudents.isEmpty
                      ? EmptyStateWidget(
                          icon: Icons.people_outline,
                          title: context.l10n.required,
                          subtitle: context.l10n.timeoutError,
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.8,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemCount: _filteredStudents.length,
                          itemBuilder: (ctx, i) {
                            final student = _filteredStudents[i];
                            final isSelected = _selectedIds.contains(student.id);
                            final qrData = BarcodeUtils.generateQRData(
                              id: student.id,
                              name: student.name,
                              grade: student.grade,
                              section: student.section,
                            );
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    _selectedIds.remove(student.id);
                                  } else {
                                    _selectedIds.add(student.id);
                                  }
                                  _selectAll = _selectedIds.length == _filteredStudents.length;
                                });
                              },
                              onLongPress: () => AppNavigator.push(
                                AppRoutes.generateBarcode,
                                arguments: student,
                              ),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                decoration: BoxDecoration(
                                  color: isSelected ? AppColors.primary.withOpacity(0.08) : Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isSelected ? AppColors.primary : AppColors.divider,
                                    width: isSelected ? 2 : 1,
                                  ),
                                  boxShadow: isSelected ? [] : AppColors.cardShadow,
                                ),
                                padding: const EdgeInsets.all(AppSpacing.md),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Stack(
                                      alignment: AlignmentDirectional.topEnd,
                                      children: [
                                        QrImageView(
                                          data: qrData,
                                          version: QrVersions.auto,
                                          size: 90,
                                        ),
                                        if (isSelected)
                                          Container(
                                            decoration: const BoxDecoration(
                                              color: AppColors.primary,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(Icons.check, color: Colors.white, size: 16),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      student.name,
                                      style: AppTextStyles.caption.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: isSelected ? AppColors.primary : AppColors.textPrimary,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      '${student.grade} — ${student.section}',
                                      style: AppTextStyles.overline,
                                      textAlign: TextAlign.center,
                                   ),
                                  ],
                                ),
                              ).animate(delay: Duration(milliseconds: i * 20)).fadeIn(duration: 200.ms),
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: _selectedIds.isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: _isPrinting ? null : _printSelectedCards,
              icon: _isPrinting
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Icon(Icons.print_rounded),
              label: Text(context.l10n.unknownError),
              backgroundColor: AppColors.primary,
            ).animate().scale(duration: 200.ms),
    );
  }
}
