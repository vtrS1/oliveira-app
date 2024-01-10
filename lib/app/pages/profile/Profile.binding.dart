import 'package:get/get.dart';
import 'package:oliveira_fotos/app/pages/profile/Profile.controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(
      () => ProfileController(),
    );
  }
}
