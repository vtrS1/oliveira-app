import 'package:get/get.dart';
import 'package:oliveira_fotos/app/pages/listas/Listas.controller.dart';

class ListasBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListaController>(
      () => ListaController(),
    );
  }
}
