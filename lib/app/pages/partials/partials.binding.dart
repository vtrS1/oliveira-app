import 'package:get/get.dart';
import 'package:oliveira_fotos/app/pages/partials/partials.controller.dart';

class PartialsViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PartialsViewController>(
      () => PartialsViewController(),
    );
  }
}
