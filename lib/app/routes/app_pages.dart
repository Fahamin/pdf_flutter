import 'package:get/get.dart';

import '../modules/pdf_due/bindings/pdf_due_binding.dart';
import '../modules/pdf_due/views/pdf_due_view.dart';
import '../modules/pdf_edit/bindings/pdf_edit_binding.dart';
import '../modules/pdf_edit/views/pdf_edit_view.dart';
import '../modules/quize/bindings/quize_binding.dart';
import '../modules/quize/views/quize_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.PDF_EDIT;

  static final routes = [
    GetPage(
      name: _Paths.PDF_DUE,
      page: () => PdfDueView(),
      binding: PdfDueBinding(),
    ),
    GetPage(
      name: _Paths.PDF_EDIT,
      page: () =>  PdfEditView(),
      binding: PdfEditBinding(),
    ),
    GetPage(
      name: _Paths.QUIZE,
      page: () => const QuizeView(),
      binding: QuizeBinding(),
    ),
  ];
}
