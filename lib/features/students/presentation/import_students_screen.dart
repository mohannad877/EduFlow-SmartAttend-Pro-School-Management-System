import 'package:school_schedule_app/core/utils/l10n_extension.dart';

import 'package:school_schedule_app/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:school_schedule_app/core/widgets/premium_app_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:school_schedule_app/core/theme/app_colors.dart';
import 'package:school_schedule_app/core/theme/app_text_styles.dart';
import 'package:school_schedule_app/core/database/attendance_providers.dart';
import 'package:school_schedule_app/core/utils/app_widgets.dart';
import 'package:school_schedule_app/features/students/domain/student_repository.dart';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart' as xl;

/// شاشة استيراد الطلاب من ملف CSV/Excel
class ImportStudentsScreen extends ConsumerStatefulWidget {
  const ImportStudentsScreen({super.key});

  @override
  ConsumerState<ImportStudentsScreen> createState() =>
      _ImportStudentsScreenState();
}

class _ImportStudentsScreenState extends ConsumerState<ImportStudentsScreen> {
  bool _isLoading = false;
  bool _isImporting = false;
  List<Map<String, String>> _previewData = [];
  String? _fileName;
  int _importedCount = 0;
  int _failedCount = 0;
  ImportStatus _status = ImportStatus.idle;

  // الأعمدة المتوقعة
  static const List<String> _expectedColumns = [
    'name',
    'stage',
    'grade',
    'section',
  ];



  Future<void> _pickFile() async {
    setState(() => _isLoading = true);
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv', 'txt', 'xlsx'],
        allowMultiple: false,
      );

      if (!mounted) return;

      if (result == null || result.files.isEmpty) {
        setState(() => _isLoading = false);
        return;
      }

      final file = result.files.first;
      setState(() => _fileName = file.name);

      if (file.path == null) {
        AppSnackBar.show(context, message: context.l10n.subjectName, type: SnackBarType.error);
        setState(() => _isLoading = false);
        return;
      }

      List<Map<String, String>> parsed;
      if (file.extension?.toLowerCase() == 'xlsx') {
        final bytes = await File(file.path!).readAsBytes();
        parsed = _parseExcel(bytes);
      } else {
        final content = await File(file.path!).readAsString();
        parsed = _parseCSV(content);
      }

      if (mounted) {
        setState(() {
          _previewData = parsed;
          _isLoading = false;
          _status = ImportStatus.preview;
        });
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.show(context, message: context.l10n.subjectAdded, type: SnackBarType.error);
        setState(() => _isLoading = false);
      }
    }
  }

  List<Map<String, String>> _parseExcel(List<int> bytes) {
    var excel = xl.Excel.decodeBytes(bytes);
    final result = <Map<String, String>>[];
    
    for (var table in excel.tables.keys) {
      final rows = excel.tables[table]?.rows ?? [];
      if (rows.isEmpty) continue;
      
      final header = rows.first.map((cell) => cell?.value?.toString().trim().toLowerCase() ?? '').toList();
      
      for (var i = 1; i < rows.length; i++) {
        final rowData = rows[i];
        final rowMap = <String, String>{};
        
        for (var j = 0; j < header.length && j < rowData.length; j++) {
          final key = header[j];
          final val = rowData[j]?.value?.toString().trim() ?? '';
          
          if (key == context.l10n.attendanceLabel || key == 'name') {
            rowMap['name'] = val;
          } else if (key == context.l10n.date || key == 'stage') {
            rowMap['stage'] = val;
          } else if (key == context.l10n.grade || key == 'grade') {
            rowMap['grade'] = val;
          } else if (key == context.l10n.section || key == 'section') {
            rowMap['section'] = val;
          } else {
            rowMap[key] = val;
          }
        }
        
        if (rowMap['name']?.isNotEmpty == true) {
          result.add(rowMap);
        }
      }
      break; // Only parse the first sheet
    }
    return result;
  }

  List<Map<String, String>> _parseCSV(String content) {
    if (content.isEmpty) return [];

    // Parse the CSV robustly using csv package
    final rowsAsListOfValues = const CsvToListConverter().convert(content);
    if (rowsAsListOfValues.isEmpty) return [];

    final header = rowsAsListOfValues.first
        .map((h) => h.toString().trim().toLowerCase())
        .toList();

    final result = <Map<String, String>>[];

    for (var i = 1; i < rowsAsListOfValues.length; i++) {
      final values = rowsAsListOfValues[i];
      if (values.length < 2) continue;

      final row = <String, String>{};
      for (var j = 0; j < header.length && j < values.length; j++) {
        final key = header[j];
        final val = values[j].toString().trim();
        
        if (key == context.l10n.attendanceLabel || key == 'name') {
          row['name'] = val;
        } else if (key == context.l10n.date || key == 'stage') {
          row['stage'] = val;
        } else if (key == context.l10n.grade || key == 'grade') {
          row['grade'] = val;
        } else if (key == context.l10n.section || key == 'section') {
          row['section'] = val;
        } else {
          row[key] = val;
        }
      }

      if (row['name']?.isNotEmpty == true) result.add(row);
    }

    return result;
  }

  Future<void> _startImport() async {
    if (_previewData.isEmpty) return;

    final ok = await ConfirmDialog.show(
      context,
      title: context.l10n.subjectUpdated,
      message: context.l10n.subjectDeleted,
      confirmLabel: context.l10n.selectSubjectDelete,
      icon: Icons.upload_file_rounded,
    );
    if (ok != true) return;

    setState(() {
      _isImporting = true;
      _importedCount = 0;
      _failedCount = 0;
      _status = ImportStatus.importing;
    });

    final repo = ref.read(studentRepositoryProvider);
    int imported = 0, failed = 0;

    for (final data in _previewData) {
      try {
        if (data['name']?.isEmpty ?? true) {
          failed++;
          continue;
        }
        await repo.addStudent(
          name: data['name']!,
          stage: data['stage'] ?? '',
          grade: data['grade'] ?? '',
          section: data['section'] ?? '',
        );
        imported++;
      } catch (_) {
        failed++;
      }
    }

    ref.invalidate(filteredStudentsProvider);

    if (mounted) {
      setState(() {
        _importedCount = imported;
        _failedCount = failed;
        _isImporting = false;
        _status = ImportStatus.done;
      });
    }
  }

  void _reset() {
    setState(() {
      _previewData = [];
      _fileName = null;
      _importedCount = 0;
      _failedCount = 0;
      _status = ImportStatus.idle;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PremiumAppBar(
        title: Text(context.l10n.level, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          if (_status != ImportStatus.idle)
            TextButton(
              onPressed: _reset,
              child: Text(context.l10n.confirmDeleteSubject, style: TextStyle(color: Colors.white), maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
        ],
      ),
      body: _isImporting
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: AppColors.primary),
                  const SizedBox(height: 16),
                  Text(context.l10n.addSubject, style: const TextStyle(fontFamily: 'Cairo'), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // المساعدة
                  _buildInstructionsCard(),
                  const SizedBox(height: 20),

                  // زر اختيار الملف
                  if (_status == ImportStatus.idle || _status == ImportStatus.preview)
                    _buildPickFileButton(),

                  // معاينة البيانات
                  if (_status == ImportStatus.preview && _previewData.isNotEmpty)
                    ..._buildPreview(),

                  // نتيجة الاستيراد
                  if (_status == ImportStatus.done)
                    _buildResultCard(),
                ],
              ),
            ),
    );
  }

  Widget _buildInstructionsCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.info.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.info.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, color: AppColors.info),
              const SizedBox(width: 8),
              Text(context.l10n.editSubject, style: AppTextStyles.subtitle1.copyWith(color: AppColors.info), maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${context.l10n.deleteSubject}\n${context.l10n.enterSubjectName}\n${context.l10n.auto_key_1762}\n${context.l10n.auto_key_1763}\n${context.l10n.auto_key_1764}',
            style: AppTextStyles.body2,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              context.l10n.auto_key_1765,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
              ),
            maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildPickFileButton() {
    return Column(
      children: [
        if (_fileName != null)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.presentLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: AppColors.present),
                const SizedBox(width: 8),
                Expanded(child: Text(_fileName!, style: AppTextStyles.body2.copyWith(color: AppColors.present), maxLines: 1, overflow: TextOverflow.ellipsis)),
              ],
            ),
          ),
        SizedBox(
          height: 52,
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _isLoading ? null : _pickFile,
            icon: _isLoading
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Icon(Icons.folder_open_rounded),
            label: Text(_fileName == null ? context.l10n.auto_key_1766 : context.l10n.auto_key_1767, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildPreview() {
    return [
      const SizedBox(height: 20),
      Row(
        children: [
          Text(
            context.l10n.auto_key_1768,
            style: AppTextStyles.headline6,
          maxLines: 1, overflow: TextOverflow.ellipsis),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_previewData.length}',
              style: AppTextStyles.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
            maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
      const SizedBox(height: 12),
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppColors.cardShadow,
        ),
        child: Column(
          children: [
            // Table Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  const Expanded(flex: 3, child: Text('#', style: TextStyle(color: Colors.white, fontFamily: 'Cairo', fontSize: 12, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis)),
                  Expanded(flex: 10, child: Text(context.l10n.attendanceLabel, style: TextStyle(color: Colors.white, fontFamily: 'Cairo', fontSize: 12, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis)),
                  Expanded(flex: 6, child: Text(context.l10n.date, style: TextStyle(color: Colors.white, fontFamily: 'Cairo', fontSize: 12, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis)),
                  Expanded(flex: 6, child: Text(context.l10n.grade, style: TextStyle(color: Colors.white, fontFamily: 'Cairo', fontSize: 12, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis)),
                  Expanded(flex: 4, child: Text(context.l10n.section, style: const TextStyle(color: Colors.white, fontFamily: 'Cairo', fontSize: 12, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis)),
                ],
              ),
            ),
            // Rows (show max 10 for preview)
            ...(_previewData.take(10).toList().asMap().entries.map((e) {
              final i = e.key;
              final row = e.value;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: i.isOdd ? AppColors.background : Colors.white,
                  border: const Border(bottom: BorderSide(color: AppColors.divider)),
                ),
                child: Row(
                  children: [
                    Expanded(flex: 3, child: Text('${i + 1}', style: AppTextStyles.caption, maxLines: 1, overflow: TextOverflow.ellipsis)),
                    Expanded(flex: 10, child: Text(row['name'] ?? '—', style: AppTextStyles.body2.copyWith(fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis)),
                    Expanded(flex: 6, child: Text(row['stage'] ?? '—', style: AppTextStyles.caption, maxLines: 1, overflow: TextOverflow.ellipsis)),
                    Expanded(flex: 6, child: Text(row['grade'] ?? '—', style: AppTextStyles.caption, maxLines: 1, overflow: TextOverflow.ellipsis)),
                    Expanded(flex: 4, child: Text(row['section'] ?? '—', style: AppTextStyles.caption, maxLines: 1, overflow: TextOverflow.ellipsis)),
                  ],
                ),
              );
            })),
            if (_previewData.length > 10)
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Text(
                  context.l10n.auto_key_1769,
                  style: AppTextStyles.caption,
                  textAlign: TextAlign.center,
                maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
          ],
        ),
      ),
      const SizedBox(height: 20),
      SizedBox(
        height: 52,
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: _startImport,
          icon: const Icon(Icons.upload_file_rounded),
          label: Text(context.l10n.auto_key_1770, maxLines: 1, overflow: TextOverflow.ellipsis),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.present,
          ),
        ),
      ),
    ];
  }

  Widget _buildResultCard() {
    final allDone = _failedCount == 0;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: allDone ? AppColors.presentLight : AppColors.lateLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: allDone ? AppColors.present : AppColors.late),
      ),
      child: Column(
        children: [
          Icon(
            allDone ? Icons.check_circle_rounded : Icons.warning_rounded,
            size: 64,
            color: allDone ? AppColors.present : AppColors.late,
          ),
          const SizedBox(height: 16),
          Text(
            allDone ? context.l10n.auto_key_1771 : context.l10n.auto_key_1772,
            style: AppTextStyles.headline5.copyWith(
              color: allDone ? AppColors.presentDark : AppColors.lateDark,
            ),
          maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ResultBadge(value: _importedCount, label: context.l10n.auto_key_1773, color: AppColors.present),
              _ResultBadge(value: _failedCount, label: context.l10n.auto_key_1774, color: AppColors.absent),
              _ResultBadge(value: _importedCount + _failedCount, label: context.l10n.total, color: AppColors.primary),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _reset,
                  child: Text(context.l10n.auto_key_1775, maxLines: 1, overflow: TextOverflow.ellipsis),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(context.l10n.dismiss, maxLines: 1, overflow: TextOverflow.ellipsis),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().scale(duration: 400.ms, curve: Curves.elasticOut);
  }
}

class _ResultBadge extends StatelessWidget {
  final int value;
  final String label;
  final Color color;

  const _ResultBadge({required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$value',
          style: AppTextStyles.headline3.copyWith(color: color, fontWeight: FontWeight.bold),
        maxLines: 1, overflow: TextOverflow.ellipsis),
        Text(label, style: AppTextStyles.caption.copyWith(color: color), maxLines: 1, overflow: TextOverflow.ellipsis),
      ],
    );
  }
}

enum ImportStatus { idle, preview, importing, done }
