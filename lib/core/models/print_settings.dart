import 'package:pdf/pdf.dart';

class PrintSettings {
  final bool showTeacherName;
  final bool showSubjectCode;
  final bool showRoomNumber;
  final bool includeLegend;
  final PdfPageFormat pageFormat;
  final bool isColorful;

  const PrintSettings({
    this.showTeacherName = true,
    this.showSubjectCode = true,
    this.showRoomNumber = true,
    this.includeLegend = true,
    this.pageFormat = PdfPageFormat.a4,
    this.isColorful = true,
  });

  PrintSettings copyWith({
    bool? showTeacherName,
    bool? showSubjectCode,
    bool? showRoomNumber,
    bool? includeLegend,
    PdfPageFormat? pageFormat,
    bool? isColorful,
  }) {
    return PrintSettings(
      showTeacherName: showTeacherName ?? this.showTeacherName,
      showSubjectCode: showSubjectCode ?? this.showSubjectCode,
      showRoomNumber: showRoomNumber ?? this.showRoomNumber,
      includeLegend: includeLegend ?? this.includeLegend,
      pageFormat: pageFormat ?? this.pageFormat,
      isColorful: isColorful ?? this.isColorful,
    );
  }
}
