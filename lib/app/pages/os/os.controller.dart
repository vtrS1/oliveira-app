import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:oliveira_fotos/app/models/Boleto.model.dart';
import 'package:oliveira_fotos/app/models/contato.model.dart';
import 'package:oliveira_fotos/app/models/Os.model.dart';
import 'package:oliveira_fotos/app/models/Pessoa.model.dart';
import 'package:oliveira_fotos/app/pages/listas/Listas.controller.dart';
import 'package:oliveira_fotos/app/pages/os/Os.provider.dart';
import 'package:oliveira_fotos/app/pages/upload/upload.controller.dart';
import 'package:oliveira_fotos/app/repository/Boleto.repository.dart';
import 'package:oliveira_fotos/app/repository/Contato.repository.dart';
import 'package:oliveira_fotos/app/repository/Os.repository.dart';
import 'package:oliveira_fotos/app/repository/Pessoa.repository.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../../App.routes.dart';

class OsViewController extends GetxController {
  List<Contato> contatos = [];
  List<Responsaveis> responsaveis = [];
  GetStorage box = GetStorage();
  static OsViewController get to => Get.find();
  String motivo = 'Selecione';
  bool isLoading = false;
  bool isLoadingData = true;
  TextEditingController obs = new TextEditingController();
  List<Boleto>? boletos;
  Os? os;

  bool hasEditAddress = false;

  @override
  void onInit() {
    super.onInit();
    os = box.read<Os>('os');
    initData();
  }

  OsViewController() {
    initData();
  }

  void initData() async {
    print('Dados iniciais');
    isLoadingData = true;
    update();
    if (os != null) {
      await this.fetchContatos();
      await this.fetchResponsaveis();
    }
    isLoadingData = false;
    update();
  }

  fetchContatos() async {
    List<Contato> contatosByOs =
        await ContatoRepository().getByOs(box.read<Os>('os')!.id!);
    this.contatos = [];
    for (Contato temp in contatosByOs) {
      bool has =
          this.contatos.any((element) => element.contato == temp.contato);

      if (!has) {
        this.contatos.add(temp);
      }
    }
    update();
  }

  fetchResponsaveis() async {
    List<Responsaveis> res =
        await ResponsavelRepository().getByOs(box.read<Os>('os')!.id!);
    this.responsaveis = res;
    update();
  }

  fetchBoletos() async {
    List<Boleto> res =
        await BoletoRepository().getByOs(box.read<Os>('os')!.id!);
    this.boletos = res;
    update();
  }

  setMotivo(String motivo) {
    this.motivo = motivo;
    update();
  }

  Future<bool> hasValidAddress() async {
    this.hasEditAddress =
        box.read(this.os!.id.toString() + '-hasEditAddress') ?? false;
    List<Contato> contatos = await ContatoRepository().getByOs(this.os!.id!);
    if (contatos.length == 0) {
      Get.snackbar(
        'Atenção',
        'Você precisa cadastrar pelo menos um contato para continuar',
        icon: Icon(Icons.warning),
        backgroundColor: Colors.red,
        margin: EdgeInsets.only(top: 10, left: 10, right: 10),
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
      return false;
    } else if (this.hasEditAddress == false) {
      Get.snackbar(
        'Atenção',
        'Você precisa editar o endereço para continuar',
        icon: Icon(Icons.warning),
        margin: EdgeInsets.only(top: 10, left: 10, right: 10),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
      return false;
    }
    return true;
  }

  initService(Os os) async {
    this.hasEditAddress =
        box.read(os.id.toString() + '-hasEditAddress') ?? false;
    List<Contato> contatos = await ContatoRepository().getByOs(os.id!);
    if (contatos.length == 0) {
      Get.snackbar(
        'Atenção',
        'Você precisa cadastrar pelo menos um contato para continuar',
        icon: Icon(Icons.warning),
        backgroundColor: Colors.red,
        margin: EdgeInsets.only(top: 10, left: 10, right: 10),
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    } else if (this.hasEditAddress == false) {
      Get.snackbar(
        'Atenção',
        'Você precisa editar o endereço para continuar',
        icon: Icon(Icons.warning),
        margin: EdgeInsets.only(top: 10, left: 10, right: 10),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    } else {
      await box.write('tipo', os.tiposNome ?? '');
      Get.offAndToNamed(DETAIL_ROUTE);
    }
  }

  saveInfoOs() async {
    Os? os = await OsRepository().getOne(box.read<Os>('os')!.id!);
    if (os != null && this.motivo != 'Selecione') {
      os.status = 4;
      os.obs = this.obs.text;
      os.motivo = this.motivo;
      await OsRepository().updateOne(os);

      await Get.find<UploadViewController>().syncOneService(os);

      Get.snackbar('Aviso', 'OS finalizada',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
          margin: EdgeInsets.only(top: 10, left: 10, right: 10));

      Get.find<ListaController>().updateData();
      await Future.delayed(Duration(seconds: 3));

      Get.toNamed(MAIN_ROUTE);
    } else if (this.motivo == 'Selecione') {
      Get.snackbar('Ops', 'Selecione um motivo válido',
          backgroundColor: Colors.orangeAccent,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
          margin: EdgeInsets.only(top: 10, left: 10, right: 10));
    } else {
      Get.snackbar('Error', 'Ocorreu um erro ao finalizar a OS',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
          margin: EdgeInsets.only(top: 10, left: 10, right: 10));
    }
  }

  offlineBills() async {
    try {
      this.isLoading = true;
      Os? os = await OsRepository().getOne(box.read<Os>('os')!.id!);
      EasyLoading.show(
        status: 'Gerando numeração...',
        dismissOnTap: false,
        maskType: EasyLoadingMaskType.black,
      );
      List<Boleto>? res = await OsProvider()
          .offlineBills(os!.toReservBillJson())
          .then((value) => this.boletos = value);
      print(res);
      Get.snackbar('Aviso', 'Numeração dos boletos gerada com sucesso',
          backgroundColor: Colors.black54,
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
          margin: EdgeInsets.only(top: 10, left: 10, right: 10));
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      Get.snackbar('Erro', e.toString(),
          backgroundColor: Colors.black54,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
          margin: EdgeInsets.only(top: 10, left: 10, right: 10));
      print(e);
    } finally {
      EasyLoading.dismiss();
      this.isLoading = false;
      update();
    }
  }
}
