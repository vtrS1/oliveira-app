import 'package:get/get.dart';
import 'package:oliveira_fotos/app/pages/settings/Settings.controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsController>(
      () => SettingsController(),
    );
  }
}
