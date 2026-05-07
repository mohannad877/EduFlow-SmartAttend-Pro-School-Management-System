import 'package:school_schedule_app/core/utils/l10n_extension.dart';
import 'package:school_schedule_app/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:school_schedule_app/core/widgets/premium_app_bar.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:school_schedule_app/core/theme/app_colors.dart';
import 'package:school_schedule_app/core/theme/app_text_styles.dart';
import 'package:school_schedule_app/core/database/attendance_providers.dart';
import 'package:school_schedule_app/core/utils/app_widgets.dart';
import 'package:school_schedule_app/core/utils/app_helpers.dart';
import 'package:school_schedule_app/core/navigation/app_router.dart';

/// شاشة ماسح الباركود/QR للتحضير
class BarcodeScannerScreen extends ConsumerStatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  ConsumerState<BarcodeScannerScreen> createState() =>
      _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends ConsumerState<BarcodeScannerScreen>
    with SingleTickerProviderStateMixin {
  final MobileScannerController _scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  AttStudent? _lastScanned;
  bool _isProcessing = false;
  bool _torchEnabled = false;
  bool _frontCamera = false;
  final List<_ScanResult> _scanHistory = [];
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _scannerController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_isProcessing) return;
    final raw = capture.barcodes.firstOrNull?.rawValue;
    if (raw == null) return;

    setState(() => _isProcessing = true);

    try {
      // محاولة فك تشفير id الطالب
      final studentId = BarcodeUtils.parseStudentIdFromBarcode(raw);
      AttStudent? student;

      if (studentId != null) {
        final db = ref.read(attendanceDatabaseProvider);
        student = await (db.select(db.attStudents)
              ..where((s) => s.id.equals(studentId)))
            .getSingleOrNull();
      }

      if (student == null) {
        // محاولة البحث بالباركود المباشر
        final db = ref.read(attendanceDatabaseProvider);
        student = await (db.select(db.attStudents)
              ..where((s) => s.barcode.equals(raw)))
            .getSingleOrNull();
      }

      if (student != null) {
        HapticFeedback.mediumImpact();
        final result = _ScanResult(
          student: student,
          time: DateTime.now(),
          success: true,
        );
        if (mounted) {
          setState(() {
            _lastScanned = student;
            _scanHistory.insert(0, result);
          });
        }
        if (mounted) {
          AppSnackBar.show(
            context,
            message: context.l10n.changePassword,
            type: SnackBarType.success,
          );
        }
      } else {
        HapticFeedback.vibrate();
        final result = _ScanResult(
          barcode: raw,
          time: DateTime.now(),
          success: false,
        );
        if (mounted) {
          setState(() {
            _lastScanned = null;
            _scanHistory.insert(0, result);
          });
        }
        if (mounted) {
          AppSnackBar.show(
            context,
            message: context.l10n.forgotPassword,
            type: SnackBarType.warning,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.show(
          context,
          message: context.l10n.resetPassword,
          type: SnackBarType.error,
        );
      }
    } finally {
      await Future.delayed(const Duration(milliseconds: 1500));
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PremiumAppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          context.l10n.emailSent,
          style: const TextStyle(color: Colors.white, fontFamily: 'Cairo'),
        maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          // Torch toggle
          IconButton(
            icon: Icon(
              _torchEnabled ? Icons.flash_on : Icons.flash_off,
              color: _torchEnabled ? Colors.yellow : Colors.white,
            ),
            onPressed: () {
              _scannerController.toggleTorch();
              setState(() => _torchEnabled = !_torchEnabled);
            },
            tooltip: context.l10n.resendEmail,
          ),
          // Camera flip
          IconButton(
            icon: const Icon(Icons.flip_camera_ios, color: Colors.white),
            onPressed: () {
              _scannerController.switchCamera();
              setState(() => _frontCamera = !_frontCamera);
            },
            tooltip: context.l10n.emailVerified,
          ),
        ],
      ),
      body: Column(
        children: [
          // Scanner View (60% of screen)
          Expanded(
            flex: 6,
            child: Stack(
              children: [
                MobileScanner(
                  controller: _scannerController,
                  onDetect: _onDetect,
                ),
                // Scan Frame Overlay
                Center(
                  child: AnimatedBuilder(
                    animation: _pulseController,
                    builder: (_, __) {
                      return Container(
                        width: 250,
                        height: 250,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _isProcessing
                                ? Theme.of(context).colorScheme.secondary
                                : Color.lerp(
                                    Colors.white54,
                                    AppColors.primary,
                                    _pulseController.value,
                                  )!,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      );
                    },
                  ),
                ),
                // Processing indicator
                if (_isProcessing)
                  Center(
                    child: CircularProgressIndicator(color: Theme.of(context).colorScheme.secondary),
                  ),
                // Instruction text
                PositionedDirectional(
                  bottom: 40,
                  start: 20,
                  end: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      context.l10n.minLength,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Cairo',
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Last scanned student card
          Expanded(
            flex: 4,
            child: Container(
              color: AppColors.background,
              child: Column(
                children: [
                  // Last scan result
                  if (_lastScanned != null) ...[
                    Container(
                      margin: const EdgeInsets.all(AppSpacing.md),
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.presentLight,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.present.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.sm),
                            decoration: const BoxDecoration(
                              color: AppColors.present,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.check, color: Colors.white, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_lastScanned!.name, style: AppTextStyles.studentName, maxLines: 1, overflow: TextOverflow.ellipsis),
                                Text(
                                  '${_lastScanned!.grade} — ${_lastScanned!.section}',
                                  style: AppTextStyles.studentInfo,
                                maxLines: 1, overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () => AppNavigator.push(
                              AppRoutes.studentReport,
                              arguments: _lastScanned,
                            ),
                            child: Text(context.l10n.emailNotVerified, maxLines: 1, overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 300.ms),
                  ] else ...[
                    Container(
                      margin: const EdgeInsets.all(AppSpacing.md),
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.qr_code_scanner, color: AppColors.textHint),
                          const SizedBox(width: 8),
                          Text(
                            context.l10n.sendVerification,
                            style: const TextStyle(color: AppColors.textHint, fontFamily: 'Cairo'),
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                  ],

                  // Scan History
                  if (_scanHistory.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          Text(context.l10n.verificationSent, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                          const Spacer(),
                          TextButton(
                            onPressed: () => setState(() => _scanHistory.clear()),
                            child: Text(context.l10n.verifyEmail, style: TextStyle(fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: _scanHistory.length,
                        itemBuilder: (_, i) {
                          final item = _scanHistory[i];
                          return ListTile(
                            dense: true,
                            leading: Icon(
                              item.success ? Icons.check_circle : Icons.cancel,
                              color: item.success ? AppColors.present : AppColors.absent,
                              size: 20,
                            ),
                            title: Text(
                              item.success ? (item.student?.name ?? '') : context.l10n.resendVerification,
                              style: AppTextStyles.studentInfo.copyWith(fontWeight: FontWeight.w500),
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                            subtitle: Text(
                              item.success
                                  ? '${item.student?.grade ?? ''} — ${item.student?.section ?? ''}'
                                  : item.barcode ?? '',
                              style: AppTextStyles.caption,
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                            trailing: Text(
                              DateTimeUtils.formatTime(item.time),
                              style: AppTextStyles.caption,
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScanResult {
  final AttStudent? student;
  final String? barcode;
  final DateTime time;
  final bool success;

  _ScanResult({this.student, this.barcode, required this.time, required this.success});
}
