import 'package:get/get.dart';

import '../controllers/quize_controller.dart';

class QuizeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuizeController>(
      () => QuizeController(),
    );
  }
}
