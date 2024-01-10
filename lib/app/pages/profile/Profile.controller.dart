import 'package:get/get.dart';
import 'package:oliveira_fotos/App.routes.dart';
import 'package:oliveira_fotos/app/models/Vendedor.model.dart';

import 'package:oliveira_fotos/app/pages/profile/Profile.provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class ProfileController extends GetxController {
  RxBool isCompleted = false.obs;
  RxBool isError = false.obs;
  Rx<Vendedor> vendedor = new Rx<Vendedor>(new Vendedor());

  ProfileController() {
    this.fetchProfile();
  }

  Future fetchProfile() async {
    this.isCompleted.value = false;
    try {
      this.vendedor.value = await ProfileProvider().fetchProfile();
      this.isCompleted.value = true;
      await box.write('vendedor', this.vendedor.value.toJson());
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      print(e);
      var vendedorFromStorage = box.read('vendedor');
      if (vendedorFromStorage != null) {
        this.vendedor.value = new Vendedor.fromJson(vendedorFromStorage);
      }
      this.isError.value = true;
    } finally {
      this.isCompleted.value = true;
    }
  }
}
