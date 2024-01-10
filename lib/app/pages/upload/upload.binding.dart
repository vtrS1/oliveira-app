import 'package:get/get.dart';
import 'package:oliveira_fotos/app/pages/upload/upload.controller.dart';

class UploadBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UploadViewController>(
      () => UploadViewController(),
    );
  }
}
