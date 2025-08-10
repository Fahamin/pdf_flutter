import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pdfx/pdfx.dart';

import '../controllers/pdf_edit_controller.dart';

class PdfEditView extends GetView<PdfEditController> {
  const PdfEditView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Editor (GetX)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: controller.saveEditedPdf,
          ),
          Obx(() => IconButton(
            icon: Icon(
              controller.isEditing.value ? Icons.edit_off : Icons.edit,
            ),
            onPressed: () {
              controller.isEditing.toggle();
              if (!controller.isEditing.value) {
                controller.endStroke(); // End current stroke when turning off
              }
            },
          )),
        ],
      ),
      body: Stack(
        children: [
          PdfViewPinch(
            controller: controller.pdfController,
            scrollDirection: Axis.vertical,
            builders: PdfViewPinchBuilders<DefaultBuilderOptions>(
              options: const DefaultBuilderOptions(),
              documentLoaderBuilder: (_) =>
              const Center(child: CircularProgressIndicator()),
              pageLoaderBuilder: (_) =>
              const Center(child: CircularProgressIndicator()),
              errorBuilder: (_, error) =>
                  Center(child: Text('PDF Error: ${error.toString()}')),
            ),
          ),
          // Only show and enable gesture detector when editing
          Obx(() {
            if (!controller.isEditing.value) {
              return const SizedBox.shrink();
            }
            return GestureDetector(
              onPanUpdate: (details) =>
                  controller.addPoint(details.localPosition),
              onPanEnd: (_) => controller.endStroke(),
              child: Obx(() {
                final points = controller.points;
                points.length; // reactivity
                return CustomPaint(
                  painter: SignaturePainter(points),
                  size: Size.infinite,
                );
              }),
            );
          }),
        ],
      ),
    );
  }
}

class SignaturePainter extends CustomPainter {
  final List<Offset> points;

  SignaturePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != Offset.zero && points[i + 1] != Offset.zero) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(SignaturePainter oldDelegate) => true;
}
