import 'package:get/get.dart';
import 'package:oliveira_fotos/app/pages/detail/detail.controller.dart';

class DetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailController>(
      () => DetailController(),
    );
  }
}
