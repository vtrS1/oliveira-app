import 'package:get/get.dart';
import 'package:oliveira_fotos/app/pages/detail/preview/ImagePreview.controller.dart';

class ImagePreviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ImagePreviewController>(
      () => ImagePreviewController(),
    );
  }
}
