import 'package:get/get.dart';

import '../controllers/pdf_due_controller.dart';

class PdfDueBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PdfDueController>(
      () => PdfDueController(),
    );
  }
}
