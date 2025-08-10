import 'dart:io';
import 'dart:ui';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

// Alias imports to avoid class name conflicts
import 'package:pdfx/pdfx.dart' as pdfx;
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart' as sfpdf;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdfx/pdfx.dart';
class PdfEditController extends GetxController {
  // PdfController for viewing PDF (from pdfx package)
  late pdfx.PdfControllerPinch pdfController;

  // Points for drawing annotations/signatures
  final points = <Offset>[].obs;
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
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
  Future<void> saveEditedPdf() async {
    try {
      if (points.isEmpty) {
        Get.snackbar('Info', 'No changes to save');
        return;
      }

      // Load and edit PDF
      final ByteData pdfData = await rootBundle.load('assets/who_dmg.pdf');
      final Uint8List pdfBytes = pdfData.buffer.asUint8List();
      final document = sfpdf.PdfDocument(inputBytes: pdfBytes);

      // Add drawings
      final page = document.pages[0];
      final pen = sfpdf.PdfPen(sfpdf.PdfColor(255, 0, 0), width: 2);
      for (int i = 0; i < points.length - 1; i++) {
        if (points[i] != Offset.zero && points[i + 1] != Offset.zero) {
          page.graphics.drawLine(pen, points[i], points[i + 1]);
        }
      }

      final List<int> pdfDataList = await document.save();
      final Uint8List editedBytes = Uint8List.fromList(pdfDataList);
      document.dispose();

      // Handle file saving
      if (Platform.isAndroid) {
        await _saveOnAndroid(editedBytes);
      } else if (Platform.isIOS) {
        await _saveOnIOS(editedBytes);
      }

      Get.snackbar('Success', 'PDF saved successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to save PDF: ${e.toString()}');
    }
  }

  Future<void> _saveOnAndroid(Uint8List bytes) async {
    // Request storage permission for Android < 13
    if (!await _requestStoragePermission()) {
      throw Exception('Storage permission denied');
    }

    final fileName = 'edited_${DateTime.now().millisecondsSinceEpoch}.pdf';
    await FileSaver.instance.saveFile(
      name: fileName,
      bytes: bytes,
      mimeType: MimeType.pdf,
    );
  }

  Future<void> _saveOnIOS(Uint8List bytes) async {
    /*final fileName = 'edited_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/$fileName');
    await tempFile.writeAsBytes(bytes);

    // On iOS, we typically use share sheet to save to Files app
    await Share.shareXFiles([XFile(tempFile.path)]);*/
  }

  Future<bool> _requestStoragePermission() async {
    if (await Permission.storage.request().isGranted) return true;
    if (await Permission.manageExternalStorage.request().isGranted) return true;
    return false;
  }

}