import 'package:get/get.dart';

import '../controllers/pdf_edit_controller.dart';

class PdfEditBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PdfEditController>(
      () => PdfEditController(),
    );
  }
}
