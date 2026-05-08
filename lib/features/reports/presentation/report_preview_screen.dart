import 'package:school_schedule_app/core/utils/l10n_extension.dart';
import 'dart:io';
import 'package:school_schedule_app/core/widgets/premium_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing/printing.dart';
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:excel/excel.dart' as xl;
import 'package:webview_flutter/webview_flutter.dart';
import 'package:school_schedule_app/core/theme/app_colors.dart';
import 'package:school_schedule_app/core/utils/arabic_formatter.dart';
import 'package:school_schedule_app/core/services/file_size_formatter.dart';

/// 📦 معاملات شاشة المعاينة
class ReportPreviewScreenArgs {
  final String title;
  final String filePath;
  final String? fileType; // 'pdf', 'excel', 'html', 'image'
  final Uint8List? fileBytes; // بديل للمسار إذا كان في الذاكرة
  final Map<String, dynamic>? metadata; // حجم الملف، تاريخ الإنشاء، إلخ

  ReportPreviewScreenArgs({
    required this.title,
    required this.filePath,
    String? fileType,
    this.fileBytes,
    this.metadata,
  }) : fileType = fileType ?? _getFileType(filePath);

  static String _getFileType(String path) {
    final ext = path.split('.').last.toLowerCase();
    if (ext == 'pdf') return 'pdf';
    if (ext == 'xlsx' || ext == 'xls') return 'excel';
    if (ext == 'html' || ext == 'htm') return 'html';
    if (ext == 'png' || ext == 'jpg' || ext == 'jpeg') return 'image';
    return 'unknown';
  }
}

/// 🎯 شاشة المعاينة الرئيسية (مطورة بالكامل)
class ReportPreviewScreen extends StatefulWidget {
  final ReportPreviewScreenArgs args;

  const ReportPreviewScreen({super.key, required this.args});

  @override
  State<ReportPreviewScreen> createState() => _ReportPreviewScreenState();
}

class _ReportPreviewScreenState extends State<ReportPreviewScreen> {
  Uint8List? _fileBytes;
  bool _isLoading = true;
  String? _errorMessage;
  FileInfo? _fileInfo;

  @override
  void initState() {
    super.initState();
    _loadFile();
  }

  Future<void> _loadFile() async {
    setState(() => _isLoading = true);
    try {
      // تحميل الملف إما من البايتات أو من المسار
      if (widget.args.fileBytes != null) {
        _fileBytes = widget.args.fileBytes;
      } else {
        final file = File(widget.args.filePath);
        if (await file.exists()) {
          _fileBytes = await file.readAsBytes();
          // جمع معلومات الملف
          final stat = await file.stat();
          _fileInfo = FileInfo(
            size: stat.size,
            modified: stat.modified,
            path: widget.args.filePath,
          );
        } else {
          throw Exception(context.l10n.fileNotFound);
        }
      }
      setState(() => _isLoading = false);
    } catch (e) {
      setState(() {
        _errorMessage = context.l10n.loadingError;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(),
        bottomNavigationBar: _buildBottomBar(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PremiumAppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.args.title, style: const TextStyle(fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis),
          if (_fileInfo != null)
            Text(
              '${ArabicFormatter.toArabicNumber(FileSizeFormatter.format(_fileInfo!.size))} • ${ArabicFormatter.formatDate(_fileInfo!.modified)}',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
      actions: [
        // مشاركة سريعة
        IconButton(
          icon: const Icon(Icons.share),
          tooltip: context.l10n.shareFile,
          onPressed: _shareFile,
        ),
        // فتح بتطبيق خارجي
        IconButton(
          icon: const Icon(Icons.open_in_new),
          tooltip: context.l10n.openExternal,
          onPressed: () => OpenFile.open(widget.args.filePath),
        ),
        // قائمة إضافية
        PopupMenuButton<String>(
          onSelected: _handleMenuAction,
          itemBuilder: (context) => [
            PopupMenuItem(value: 'save_copy', child: Text(context.l10n.saveAs, maxLines: 1, overflow: TextOverflow.ellipsis)),
            PopupMenuItem(value: 'send_mail', child: Text(context.l10n.sendEmail, maxLines: 1, overflow: TextOverflow.ellipsis)),
            PopupMenuItem(value: 'print', child: Text(context.l10n.reportBug, maxLines: 1, overflow: TextOverflow.ellipsis)),
            PopupMenuItem(value: 'info', child: Text(context.l10n.fileInfo, maxLines: 1, overflow: TextOverflow.ellipsis)),
          ],
        ),
      ],
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 16),
            Text(_errorMessage!, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadFile,
              child: Text(context.l10n.retry, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      );
    }

    // معاينة حسب نوع الملف
    switch (widget.args.fileType) {
      case 'pdf':
        return _buildPdfPreview();
      case 'excel':
        return _buildExcelPreview();
      case 'html':
        return _buildHtmlPreview();
      case 'image':
        return _buildImagePreview();
      default:
        return _buildUnknownPreview();
    }
  }

  Widget _buildPdfPreview() {
    return PdfPreview(
      build: (format) async => _fileBytes ?? Uint8List(0),
      allowPrinting: true,
      allowSharing: true,
      canChangeOrientation: true,
      canChangePageFormat: false,
      canDebug: false,
      pdfFileName: widget.args.title,
      onPrinted: (_) => _showSnackbar(context.l10n.printSuccess),
      onShared: (_) => _showSnackbar(context.l10n.shareSuccess),
    );
  }

  Widget _buildExcelPreview() {
    // استخدام WebView لعرض Excel بعد تحويله إلى HTML
    return FutureBuilder<String>(
      future: _convertExcelToHtml(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text(context.l10n.excelError, maxLines: 1, overflow: TextOverflow.ellipsis));
        }
        return WebViewWidget(
          controller: WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..loadHtmlString(snapshot.data ?? context.l10n.cannotDisplay),
        );
      },
    );
  }

  Future<String> _convertExcelToHtml() async {
    // تحويل ملف Excel إلى HTML لعرضه في WebView باستخدام مكتبة excel الحالية في المشروع
    try {
      final excel = xl.Excel.decodeBytes(_fileBytes!);
      final sb = StringBuffer();
      sb.write('<html dir="rtl"><head><meta charset="UTF-8"><style>');
      sb.write('table {border-collapse: collapse; width: 100%; font-family: sans-serif;}');
      sb.write('td, th {border: 1px solid #ddd; padding: 12px; text-align: right;}');
      sb.write('th {background-color: #f2f2f2;}');
      sb.write('tr:nth-child(even) {background-color: #f9f9f9;}');
      sb.write('</style></head><body>');
      
      for (var table in excel.tables.keys) {
        sb.write('<h2 style="color: #1565C0; padding: 10px;">$table</h2>');
        sb.write('<table>');
        final sheetData = excel.tables[table]!;
        for (var row in sheetData.rows) {
          sb.write('<tr>');
          for (var cell in row) {
            final value = cell?.value?.toString() ?? '';
            sb.write('<td>$value</td>');
          }
          sb.write('</tr>');
        }
        sb.write('</table>');
      }
      
      sb.write('</body></html>');
      return sb.toString();
    } catch (e) {
      return context.l10n.conversionFailed;
    }
  }

  Widget _buildHtmlPreview() {
    return WebViewWidget(
      controller: WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadRequest(Uri.file(widget.args.filePath))
        ..setNavigationDelegate(NavigationDelegate(
          onPageFinished: (_) => setState(() {}),
          onWebResourceError: (error) => _showSnackbar(context.l10n.pageLoadError),
        )),
    );
  }

  Widget _buildImagePreview() {
    return InteractiveViewer(
      minScale: 0.5,
      maxScale: 4.0,
      child: Center(
        child: Image.memory(_fileBytes!),
      ),
    );
  }

  Widget _buildUnknownPreview() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.insert_drive_file, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(context.l10n.cannotPreview, style: TextStyle(color: Colors.grey.shade600), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.open_in_new),
            label: Text(context.l10n.openExternal, maxLines: 1, overflow: TextOverflow.ellipsis),
            onPressed: () => OpenFile.open(widget.args.filePath),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return BottomAppBar(
      color: Colors.white,
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildBottomAction(Icons.print, context.l10n.reportBug, _printFile),
            _buildBottomAction(Icons.share, context.l10n.sendFeedback, _shareFile),
            _buildBottomAction(Icons.save_alt, context.l10n.saveCopy, _saveCopy),
            _buildBottomAction(Icons.email, context.l10n.sendMail, _sendByEmail),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomAction(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }

  // ==========================================================================
  // الإجراءات
  // ==========================================================================

  Future<void> _shareFile() async {
    if (_fileBytes == null) return;
    await Share.shareXFiles(
      [XFile(widget.args.filePath, mimeType: _getMimeType())],
      text: context.l10n.shareReport,
    );
    _showSnackbar(context.l10n.shareSuccess);
  }

  Future<void> _printFile() async {
    if (widget.args.fileType == 'pdf') {
      await Printing.layoutPdf(onLayout: (context) async => _fileBytes!);
      _showSnackbar(context.l10n.sentToPrinter);
    } else {
      _showSnackbar(context.l10n.printOnlyPdf);
    }
  }

  Future<void> _saveCopy() async {
    try {
      // final directory = await getExternalStorageDirectory() ?? await getApplicationDocumentsDirectory();
      final newPath = context.l10n.backupPath;
      await File(widget.args.filePath).copy(newPath);
      _showSnackbar(context.l10n.copySaved);
    } catch (e) {
      _showSnackbar(context.l10n.copySaveFailed);
    }
  }

  Future<void> _sendByEmail() async {
    final emailUri = Uri(
      scheme: 'mailto',
      path: '',
      query: 'subject=${Uri.encodeComponent(widget.args.title)}&body=${Uri.encodeComponent(context.l10n.reportAttachment)}',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      _showSnackbar(context.l10n.noMailApp);
    }
  }

  void _handleMenuAction(String value) {
    switch (value) {
      case 'save_copy':
        _saveCopy();
        break;
      case 'send_mail':
        _sendByEmail();
        break;
      case 'print':
        _printFile();
        break;
      case 'info':
        _showFileInfoDialog();
        break;
    }
  }

  void _showFileInfoDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.fileInfo, maxLines: 1, overflow: TextOverflow.ellipsis),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.fileName, maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 8),
            Text(context.l10n.fileType, maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 8),
            Text('${context.l10n.type} ${widget.args.fileType ?? "Unknown"}', maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 8),
            Text(context.l10n.modified, maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(context.l10n.dismiss, maxLines: 1, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }

  String _getMimeType() {
    switch (widget.args.fileType) {
      case 'pdf': return 'application/pdf';
      case 'excel': return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
      case 'html': return 'text/html';
      case 'image': return 'image/png';
      default: return 'application/octet-stream';
    }
  }

  void _showSnackbar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, maxLines: 1, overflow: TextOverflow.ellipsis), duration: const Duration(seconds: 2)),
    );
  }
}

// ============================================================================
// فئات مساعدة
// ============================================================================

class FileInfo {
  final int size;
  final DateTime modified;
  final String path;
  FileInfo({required this.size, required this.modified, required this.path});
}
