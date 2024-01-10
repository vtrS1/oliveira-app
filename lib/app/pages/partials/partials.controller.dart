import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:oliveira_fotos/app/models/Boleto.model.dart';
import 'package:oliveira_fotos/app/models/Os.model.dart';
import 'package:oliveira_fotos/app/pages/partials/partials.provider.dart';

class PartialsViewController extends GetxController
    with StateMixin<List<Boleto>> {
  List<Boleto>? boletos;
  GetStorage box = GetStorage();
  static PartialsViewController get to => Get.find();

  @override
  void onInit() {
    super.onInit();
    change(null, status: RxStatus.loading());
    PartialsProvider().fetchPartials(box.read<Os>('os')!.id!.toString()).then(
        (resp) {
      if (resp.isBlank!) {
        change(resp, status: RxStatus.empty());
      } else {
        this.boletos = resp;
        change(resp, status: RxStatus.success());
      }
    }, onError: (err) {
      change(
        null,
        status: RxStatus.error(err.toString()),
      );
    });
  }
}
