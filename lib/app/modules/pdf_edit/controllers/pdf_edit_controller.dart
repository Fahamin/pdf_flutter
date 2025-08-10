import 'dart:io';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

// Alias imports to avoid class name conflicts
import 'package:pdfx/pdfx.dart' as pdfx;
import 'package:syncfusion_flutter_pdf/pdf.dart' as sfpdf;

class PdfEditController extends GetxController {
  // PdfController for viewing PDF (from pdfx package)
  late pdfx.PdfControllerPinch pdfController;

  // Points for drawing annotations/signatures
  final points = <Offset>[].obs;

  var isEditing = false.obs; // Track if user is currently drawing

  @override
  void onInit() {
    super.onInit();
    // Load PDF for viewing
    pdfController = pdfx.PdfControllerPinch(
      document: pdfx.PdfDocument.openAsset('assets/who_dmg.pdf'),
    );
  }

  // Add drawing point (called on user touch move)
  void addPoint(Offset point) {
    points.add(point);
  }

  // Add a zero point to mark stroke end (called on user touch end)
  void endStroke() {
    points.add(Offset.zero);
  }

  // Save the edited PDF with drawn lines overlaid using Syncfusion PDF
  Future<String> saveEditedPdf() async {
    try {
      // 1. Load original PDF from assets
      final ByteData pdfData = await rootBundle.load('assets/who_dmg.pdf');
      final Uint8List pdfBytes = pdfData.buffer.asUint8List();

      // 2. Load PDF document
      final sfpdf.PdfDocument document = sfpdf.PdfDocument(inputBytes: pdfBytes);

      // 3. Add drawings if there are points
      if (points.isNotEmpty) {
        final page = document.pages[0];
        final pen = sfpdf.PdfPen(sfpdf.PdfColor(255, 0, 0), width: 2);

        for (int i = 0; i < points.length - 1; i++) {
          if (points[i] != Offset.zero && points[i + 1] != Offset.zero) {
            page.graphics.drawLine(pen, points[i], points[i + 1]);
          }
        }
      }

      // 4. Save the document
      final List<int> editedBytes = await document.save();
      document.dispose();

      // 5. Save to app directory
      final Directory dir = await getApplicationDocumentsDirectory();
      final String editedPath = '${dir.path}/edited_${DateTime.now().millisecondsSinceEpoch}.pdf';
      await File(editedPath).writeAsBytes(editedBytes);

      // 6. Notify user
      Get.snackbar(
        'Success',
        'PDF saved successfully',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );

      // Optional: return the path if needed
      return editedPath;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save PDF: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
      );
      rethrow;
    }
  }
}
