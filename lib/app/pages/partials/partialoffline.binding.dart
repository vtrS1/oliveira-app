import 'package:get/get.dart';
import 'package:oliveira_fotos/app/pages/partials/partialsoffline.controller.dart';

class PartialsOfflineViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PartialsOfflineViewController>(
      () => PartialsOfflineViewController(),
    );
  }
}
