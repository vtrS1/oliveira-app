import 'package:get/get.dart';
import 'package:oliveira_fotos/app/pages/detail/camera/camera.controller.dart';

class CameraBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CameraController>(
      () => CameraController(),
    );
  }
}
