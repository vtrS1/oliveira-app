import 'package:get/get.dart';
import 'package:oliveira_fotos/app/pages/payment/payment.controller.dart';

class PaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentController>(
      () => PaymentController(),
    );
  }
}
