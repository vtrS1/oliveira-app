import 'package:get/get.dart';
import 'package:oliveira_fotos/app/pages/os/os.controller.dart';

class OsViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OsViewController>(
      () => OsViewController(),
    );
  }
}
