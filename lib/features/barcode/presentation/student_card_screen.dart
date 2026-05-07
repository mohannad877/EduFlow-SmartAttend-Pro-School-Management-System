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

/// شاشة بطاقة الطالب مع QR Code
class StudentCardScreen extends ConsumerStatefulWidget {
  final AttStudent student;

  const StudentCardScreen({super.key, required this.student});

  @override
  ConsumerState<StudentCardScreen> createState() => _StudentCardScreenState();
}

class _StudentCardScreenState extends ConsumerState<StudentCardScreen> {
  String? _schoolName;
  bool _isLoading = true;
  final GlobalKey _cardKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _loadSchoolName();
  }

  Future<void> _loadSchoolName() async {
    final db = ref.read(attendanceDatabaseProvider);
    final settings = await db.select(db.attSettings).get();
    final nameEntry = settings.where((s) => s.key == 'school_name').firstOrNull;
    if (mounted) {
      setState(() {
        _schoolName = nameEntry?.value ?? context.l10n.schoolName;
        _isLoading = false;
      });
    }
  }

  String get _qrData {
    return BarcodeUtils.generateQRData(
      id: widget.student.id,
      name: widget.student.name,
      grade: widget.student.grade,
      section: widget.student.section,
    );
  }

  Future<void> _printCard() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a6,
        margin: const pw.EdgeInsets.all(AppSpacing.md),
        build: (ctx) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Text(
            _schoolName ?? context.l10n.schoolName,
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
           ),
            pw.SizedBox(height: 8),
            pw.Divider(),
            pw.SizedBox(height: 8),
            pw.BarcodeWidget(
              barcode: pw.Barcode.qrCode(),
              data: _qrData,
              width: 120,
              height: 120,
            ),
            pw.SizedBox(height: 8),
            pw.Text(
              widget.student.name,
              style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
           ),
            pw.SizedBox(height: 4),
            pw.Text(
              '${widget.student.stage} — ${widget.student.grade} — ${widget.student.section}',
              style: const pw.TextStyle(fontSize: 11),
           ),
            pw.SizedBox(height: 4),
            pw.Text(
              widget.student.barcode,
              style: const pw.TextStyle(fontSize: 10, letterSpacing: 2),
           ),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(onLayout: (_) => pdf.save());
  }

  Future<void> _shareCard() async {
    AppSnackBar.show(
      context,
      message: context.l10n.tryAgain,
      type: SnackBarType.info,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PremiumAppBar(
        title: Text(context.l10n.contactSupport),
        actions: [
          IconButton(
            icon: const Icon(Icons.print_rounded),
            onPressed: _printCard,
            tooltip: context.l10n.reportBug,
          ),
          IconButton(
            icon: const Icon(Icons.share_rounded),
            onPressed: _shareCard,
            tooltip: context.l10n.sendFeedback,
          ),
        ],
      ),
      body: _isLoading
          ? const LoadingIndicator()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  RepaintBoundary(
                    key: _cardKey,
                    child: _buildCard(),
                  ),
                  const SizedBox(height: 24),
                  _buildActions(),
                ],
              ),
            ),
    );
  }

  Widget _buildCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: const BoxDecoration(
              gradient: AppColors.premiumGradient,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.school_rounded, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      _schoolName ?? context.l10n.schoolName,
                      style: AppTextStyles.subtitle1.copyWith(color: Colors.white),
                   ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  context.l10n.contactSupport,
                  style: AppTextStyles.caption.copyWith(color: Colors.white70),
               ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                // QR Code
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: QrImageView(
                    data: _qrData,
                    version: QrVersions.auto,
                    size: 180,
                    errorCorrectionLevel: QrErrorCorrectLevel.H,
                  ),
                ),

                const SizedBox(height: 20),

                // Student Info
                Text(
                  widget.student.name,
                  style: AppTextStyles.headline5,
                  textAlign: TextAlign.center,
               ),
                const SizedBox(height: 8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _InfoTag(label: widget.student.stage, color: AppColors.primary),
                    const SizedBox(width: 8),
                    _InfoTag(label: widget.student.grade, color: AppColors.secondary),
                    const SizedBox(width: 8),
                    _InfoTag(label: widget.student.section, color: Theme.of(context).colorScheme.secondary),
                  ],
                ),

                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 12),

                // Barcode number
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Text(
                    widget.student.barcode,
                    style: AppTextStyles.barcodeId,
                    textDirection: TextDirection.ltr,
                 ),
                ),

                const SizedBox(height: 12),

                Text(
                  context.l10n.rateApp,
                  style: AppTextStyles.caption,
                  textAlign: TextAlign.center,
               ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          onPressed: _printCard,
          icon: const Icon(Icons.print_rounded),
          label: Text(context.l10n.shareApp),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => AppNavigator.push(AppRoutes.studentReport, arguments: widget.student),
          icon: const Icon(Icons.bar_chart_rounded),
          label: Text(context.l10n.privacyPolicy),
        ),
        const SizedBox(height: 12),
        TextButton.icon(
          onPressed: () async {
            final ok = await ConfirmDialog.show(
              context,
              title: context.l10n.termsOfService,
              message: context.l10n.licenses,
              confirmLabel: context.l10n.openSource,
              icon: Icons.qr_code_2,
            );
            if (ok == true && mounted) {
              AppSnackBar.show(context, message: context.l10n.academicSettings, type: SnackBarType.success);
            }
          },
          icon: const Icon(Icons.refresh_rounded),
          label: Text(context.l10n.termsOfService),
        ),
      ],
    ).animate(delay: 200.ms).fadeIn(duration: 400.ms);
  }
}

class _InfoTag extends StatelessWidget {
  final String label;
  final Color color;

  const _InfoTag({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
     ),
    );
  }
}
