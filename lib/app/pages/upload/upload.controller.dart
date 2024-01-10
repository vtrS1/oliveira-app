import 'dart:convert';
import 'dart:io';
import 'dart:convert' show json, base64Encode;
import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oliveira_fotos/app/models/Image.model.dart';
import 'package:oliveira_fotos/app/models/Os.model.dart';
import 'package:oliveira_fotos/app/models/Parcela.model.dart';
import 'package:oliveira_fotos/app/models/contato.model.dart';
import 'package:oliveira_fotos/app/pages/listas/Listas.controller.dart';
import 'package:oliveira_fotos/app/provider/Connection.provider.dart';
import 'package:oliveira_fotos/app/repository/Boleto.repository.dart';
import 'package:oliveira_fotos/app/repository/Image.repository.dart';
import 'package:oliveira_fotos/app/repository/Os.repository.dart';
import 'package:oliveira_fotos/app/repository/Parcela.repository.dart';
import 'package:oliveira_fotos/app/repository/Pessoa.repository.dart';
import 'package:oliveira_fotos/app/repository/contato.repository.dart';
import 'package:oliveira_fotos/app/utils/consts.dart';
import 'package:path/path.dart' as path;
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:dio/dio.dart' as DT;

class UploadViewController extends GetxController {
  GetStorage box = GetStorage();
  Connection connection = new Connection();
  int currentIndex = 0;
  int qtd = 0;
  int erros = 0;
  bool isFinished = false;
  bool isUploading = false;
  bool isError = false;
  String imgAtual = '';
  int coutImage = 1;

  @override
  void onInit() {
    super.onInit();
    this.existOsToSend();
  }

  Future sendOsToServer(Os os) async {
    List<Parcela> parcelas = await ParcelaRepository().getByOs(os.id!);
    List<Contato> contatos = await ContatoRepository().getByOs(os.id!);

    Parcela temp = parcelas.first;
    if (!CPFValidator.isValid(temp.cpf)) {
      Get.snackbar('Aviso', '',
          snackPosition: SnackPosition.TOP,
          duration: Duration(seconds: 7),
          margin: EdgeInsets.all(20),
          backgroundColor: Colors.blue[800],
          colorText: Colors.white,
          messageText: Text(
            'O CPF do sacado não é válido (OS ${os.id}), A OS não será enviada até que você corrija isso.',
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
          ),
          icon: Icon(Icons.warning));
      return false;
    }

    Map<String, dynamic> parcelasToSend = Map<String, dynamic>();
    parcelasToSend['parcelas'] = [];
    parcelasToSend['contatos'] = [];
    parcelasToSend['images'] = [];
    parcelasToSend['os'] = os.toJson();
    for (Parcela p in parcelas) {
      try {
        parcelasToSend['parcelas'].add(p.toJson());
      } catch (e, stackTrace) {
        await Sentry.captureException(
          e,
          stackTrace: stackTrace,
        );
      }
    }
    for (Contato c in contatos) {
      try {
        parcelasToSend['contatos'].add(c.toJson());
      } catch (e, stackTrace) {
        await Sentry.captureException(
          e,
          stackTrace: stackTrace,
        );
      }
    }
    List<ImageModel> images = await ImageRepository().getByOs(os.id!);

    int countImage = 1;
    for (ImageModel image in images) {
      try {
        final bytes = await File(image.src!).readAsBytes();
        String img64 = base64Encode(bytes);
        List<String> novoNome = image.src!.split("/");
        novoNome = novoNome[novoNome.length - 1].split(".");
        Map form = Map();
        form['img'] = img64;
        form['extension'] = path.extension(image.src!);
        form['name'] = countImage.toString() + '-' + novoNome[0];
        form['tipo'] = image.tipoImagem!.toUpperCase();
        form['os'] = image.idListaAluno.toString();
        form['contrato'] = image.contrato.toString();
        form['ficha'] = image.idFicha.toString();
        parcelasToSend['images'].add(form);
        countImage++;
      } catch (e, stackTrace) {
        await Sentry.captureException(
          e,
          stackTrace: stackTrace,
        );
      }
    }
    try {
      DT.Response res = await connection.postSimple(
          Constants.API_HOST_SYNC, json.encode(parcelasToSend));
      // Não deleta as parcelas das OS que usaram boletos offline
      if (res.statusCode == 200) {
        await ParcelaRepository().deleteAllByOs(os.id!);
        await BoletoRepository().deleteAllByOs(os.id!);
        await OsRepository().updateStatus(os.id!, 2);
        await ResponsavelRepository().deleteAllByOs(os.id!);
        await ImageRepository().deleteImageByOs(os.id!);
        await GetStorage().remove(os.id.toString() + '-hasEditAddress');
      } else {
        await OsRepository().updateStatus(os.id!, 3);
      }
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      await OsRepository().updateStatus(os.id!, 3);
    }
  }

  Future sendOsNotExecutedToServer(Os os) async {
    try {
      List<Contato> contatos = await ContatoRepository().getByOs(os.id!);
      Map<String, dynamic> parcelasToSend = Map<String, dynamic>();
      parcelasToSend['os'] = os.toJson();
      parcelasToSend['version'] = Constants.APP_VERSION;
      parcelasToSend['contatos'] = [];
      for (Contato c in contatos) {
        try {
          parcelasToSend['contatos'].add(c.toJson());
        } catch (e, stackTrace) {
          await Sentry.captureException(
            e,
            stackTrace: stackTrace,
          );
        }
      }
      DT.Response res = await connection.postSimple(
          Constants.API_HOST + 'external/os/nao-executada/v2',
          json.encode(parcelasToSend));

      if (res.statusCode == 200) {
        await ParcelaRepository().deleteAllByOs(os.id!);
        await OsRepository().updateStatus(os.id!, 2);
        await ImageRepository().deleteImageByOs(os.id!);
        await BoletoRepository().deleteAllByOs(os.id!);
        await ResponsavelRepository().deleteAllByOs(os.id!);
        await ContatoRepository().deleteAllByOs(os.id!);
        await GetStorage().remove(os.id.toString() + '-hasEditAddress');
        EasyLoading.showSuccess(
            'Serviço não executado foi enviado com sucesso');
      } else {
        await OsRepository().updateStatus(os.id!, 3);
        EasyLoading.showError(
            'ES5 - Ocorreu um erro ao enviar o serviço, tente novamente mais tarde no menu de "sincronização"');
      }
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      await OsRepository().updateStatus(os.id!, 3);
      EasyLoading.showError(
          'ES3 - Ocorreu um erro ao enviar o serviço, tente novamente mais tarde no menu de "sincronização"');
    }
  }

  Future existOsToSend() async {
    try {
      this.isFinished = false;
      this.isError = false;
      this.isUploading = false;
      EasyLoading.show(
        status: 'Aguarde...',
        dismissOnTap: false,
        maskType: EasyLoadingMaskType.black,
      );
      List<Os> servicos = await OsRepository().getAll();

      servicos = servicos
          .where((element) =>
              element.status == 1 || element.status == 3 || element.status == 4)
          .toList();
      qtd = servicos.length;
      update();
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      Get.snackbar(
          'Atualizado', 'Ocorreu um erro, feche o aplicativo e tente novamente',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
          margin: EdgeInsets.only(top: 10, left: 10, right: 10));
    } finally {
      await Future.delayed(Duration(seconds: 1));
      EasyLoading.dismiss();
    }
  }

  Future fetchImages() async {
    try {
      this.isUploading = true;
      List<Os> servicos = await OsRepository().getAll();

      servicos = servicos
          .where((element) =>
              element.status == 1 || element.status == 3 || element.status == 4)
          .toList();
      qtd = servicos.length;
      update();

      for (Os os in servicos) {
        currentIndex++;
        update();
        if (os.status != 4 && os.motivo == null) {
          try {
            await sendOsToServer(os);
          } catch (e, stackTrace) {
            await Sentry.captureException(e, stackTrace: stackTrace);
          }
        } else {
          await sendOsNotExecutedToServer(os);
        }
      }

      isFinished = true;
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      isFinished = true;
      isError = true;
    } finally {
      this.isUploading = false;
      Get.find<ListaController>().updateData();
      update();
    }
  }

  Future syncOneService(Os os) async {
    try {
      EasyLoading.show(
          status: "Enviando OS ${os.id}",
          dismissOnTap: false,
          maskType: EasyLoadingMaskType.black);
      if (os.status != 4 && os.motivo == null) {
        try {
          await sendOsToServer(os);
        } catch (e, stackTrace) {
          await Sentry.captureException(e, stackTrace: stackTrace);
        }
      } else {
        await sendOsNotExecutedToServer(os);
      }
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      EasyLoading.showError(
          'ES4 - Ocorreu um erro ao enviar o serviço, tente novamente mais tarde no menu de "sincronização"');
    } finally {
      EasyLoading.dismiss();
    }
  }
}
