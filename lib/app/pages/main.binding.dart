import 'package:get/get.dart';
import 'package:oliveira_fotos/app/pages/main.controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(
      () => MainController(),
    );
  }
}
