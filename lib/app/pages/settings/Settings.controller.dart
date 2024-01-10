import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:oliveira_fotos/app/models/Os.model.dart';
import 'package:oliveira_fotos/app/pages/settings/Negativados.provider.dart';
import 'package:oliveira_fotos/app/provider/Parametros.provider.dart';
import 'package:oliveira_fotos/app/provider/TipoContatos.provider.dart';
import 'package:oliveira_fotos/app/repository/Os.repository.dart';
import 'package:oliveira_fotos/app/utils/consts.dart';
import 'package:oliveira_fotos/app/utils/functions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:oliveira_fotos/app/pages/payment/payment.provider.dart';
import 'package:oliveira_fotos/app/provider/Db.provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:share/share.dart';
// ignore: implementation_imports
import 'package:dio/src/response.dart' as DResp;
import 'package:url_launcher/url_launcher.dart';

class SettingsController extends GetxController {
  Rx<GetStorage> box = GetStorage().obs;
  RxBool isDarkMode = false.obs;
  RxString dateLastUpdateFormaPagamento = ''.obs;
  RxString sourceMidia = 'perguntar'.obs;
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  final DBProvider _dbProvider = DBProvider.db;

  String get getSourceMidia => this.sourceMidia.value == 'perguntar'
      ? 'Sempre perguntar'
      : this.sourceMidia.value == 'galeria'
          ? 'Galeria'
          : 'Câmera';

  String get getLastUpdateFormaPagamento =>
      this.dateLastUpdateFormaPagamento.value;

  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = box.value.read('isDarkMode');
    dateLastUpdateFormaPagamento.value =
        box.value.read('lastUpdateFormaPagamento') ?? '';
  }

  toggleTheme(bool value) {
    box.value.write('isDarkMode', value);
    this.isDarkMode.value = box.value.read('isDarkMode');
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
    update();
  }

  updateSourceMidia() {
    String val = box.value.read('sourceMidia') ?? 'perguntar';

    this.sourceMidia.value = val;
    update();
  }

  updateFormaPagamento() async {
    try {
      // EasyLoading.instance.displayDuration = Duration(seconds: 10);
      EasyLoading.show(
        status: 'Atualizando formas de pagamento, aguarde...',
        dismissOnTap: false,
        maskType: EasyLoadingMaskType.black,
      );
      await PaymentProvider().initFormasPagamentos();
      EasyLoading.dismiss();
      EasyLoading.show(
        status: 'Atualizando dados de endereços, aguarde...',
        dismissOnTap: false,
        maskType: EasyLoadingMaskType.black,
      );
      await PaymentProvider().initEstados();
      EasyLoading.dismiss();
      EasyLoading.show(
        status: 'Atualizando dados de parametros, aguarde...',
        dismissOnTap: false,
        maskType: EasyLoadingMaskType.black,
      );
      await ParametroProvider().initParametros();
      EasyLoading.dismiss();
      EasyLoading.show(
        status: 'Atualizando tipos de contatos, aguarde...',
        dismissOnTap: false,
        maskType: EasyLoadingMaskType.black,
      );
      await TipoContatosProvider().initTiposContatos();
      // await PaymentProvider().initCidades();
      Get.snackbar('Atualizado',
          'A lista de formas de pagamento, parametros, estados e cidades foi atualizada com sucesso',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
          margin: EdgeInsets.only(top: 10, left: 10, right: 10));

      await box.value.write('lastUpdateFormaPagamento',
          dateFormat.format(new DateTime.now()).toString());
      dateLastUpdateFormaPagamento.value =
          box.value.read('lastUpdateFormaPagamento') ?? '';
      EasyLoading.show(
        status: 'Dados atualizados com sucesso',
        dismissOnTap: false,
        maskType: EasyLoadingMaskType.black,
      );
      await Future.delayed(Duration(seconds: 2));
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      Get.snackbar('Ops',
          'Erro ao atualizar as formas de pagamento, parametros, estados e cidades',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
          margin: EdgeInsets.only(top: 10, left: 10, right: 10));
    } finally {
      EasyLoading.dismiss();
    }
  }

  updateInadimplentes() async {
    try {
      EasyLoading.show(
        dismissOnTap: false,
        maskType: EasyLoadingMaskType.black,
        status: 'Atualizando...',
      );
      List negativados = await NegativadosProvider().initNegativados();
      EasyLoading.dismiss();
      print(negativados.length);
      Get.snackbar(
          'Atualizado', 'A lista de inadimplentes foi atualizada com sucesso',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
          margin: EdgeInsets.only(top: 10, left: 10, right: 10));
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      Get.snackbar('Ops', 'Erro ao atualizar a lista de inadimplentes',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
          margin: EdgeInsets.only(top: 10, left: 10, right: 10));
    }
  }

  Future exportDatabase() async {
    try {
      EasyLoading.show(
        status: 'Exportando dados...',
        dismissOnTap: false,
        maskType: EasyLoadingMaskType.black,
      );
      String? file = await _dbProvider.generateBackup();
      if (file != null) {
        var vendedor = await box.value.read('vendedor');
        Get.snackbar('Exportado', 'Dados exportados com sucesso',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: Duration(seconds: 3),
            margin: EdgeInsets.only(top: 10, left: 10, right: 10));
        Share.shareFiles([file],
            text: 'BKP do vendedor ' + vendedor['id'].toString());
      } else {
        Get.snackbar('Ops', 'Erro ao exportar os dados',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: Duration(seconds: 3),
            margin: EdgeInsets.only(top: 10, left: 10, right: 10));
      }
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      print(e);
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future clearMemoryCache() async {
    List<Os> servicos = await OsRepository().getAll();
    if (servicos.length > 0) {
      Get.snackbar('Ops',
          'Você ainda tem serviços, termine todos eles antes de tentar limpar o cache do APP',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
          margin: EdgeInsets.only(top: 10, left: 10, right: 10));
    } else {
      EasyLoading.show(
        status: 'Limpando cache...',
        dismissOnTap: false,
        maskType: EasyLoadingMaskType.black,
      );
      try {
        final cacheDir = await getTemporaryDirectory();

        if (cacheDir.existsSync()) {
          cacheDir.deleteSync(recursive: true);
        }

        final appDir = await getApplicationSupportDirectory();

        if (appDir.existsSync()) {
          appDir.deleteSync(recursive: true);
        }
        EasyLoading.dismiss();
        Get.snackbar('Sucesso', 'O cache do APP foi limpo com sucesso',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: Duration(seconds: 3),
            margin: EdgeInsets.only(top: 10, left: 10, right: 10));
      } catch (e, stackTrace) {
        await Sentry.captureException(
          e,
          stackTrace: stackTrace,
        );
        print(e);
        EasyLoading.dismiss();
        Get.snackbar('Ops', 'Ocorreu um erro tentar limpar o cache do APP',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: Duration(seconds: 3),
            margin: EdgeInsets.only(top: 10, left: 10, right: 10));
      }
    }
  }

  Future<bool> verifyUpdate() async {
    try {
      EasyLoading.show(
        status: 'Verificando atualização...',
        dismissOnTap: false,
        maskType: EasyLoadingMaskType.black,
      );
      DResp.Response res =
          await Dio().get(Constants.API_HOST + "external/appversion");
      if (res.statusCode == 200) {
        if (res.data['valor'] == null) {
          throw Exception(
              'Não foi possível verificar se há uma nova versão do app');
        }
        if (parseFloat(res.data['valor'])! >
            parseFloat(Constants.APP_VERSION)!) {
          return true;
        }
      }
      EasyLoading.dismiss();
      return false;
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      EasyLoading.dismiss();
      return false;
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future updateApp() async {
    try {
      if (await verifyUpdate()) {
        DResp.Response res =
            await Dio().get(Constants.API_HOST + "external/app");
        if (res.statusCode == 200) {
          if (res.data['valor'] == null) {
            throw Exception(
                'Não foi possível verificar se há uma nova versão do app');
          }
          try {
            await launch(res.data['valor']);
          } catch (e, stackTrace) {
            await Sentry.captureException(
              e,
              stackTrace: stackTrace,
            );
            Get.snackbar('Erro',
                'Ocorreu um erro ao tentar baixar a atualização, tente novamente mais tarde',
                backgroundColor: Colors.black54,
                colorText: Colors.white,
                duration: Duration(seconds: 3),
                margin: EdgeInsets.only(top: 10, left: 10, right: 10));
          }
          // EasyLoading.show(
          //     status: 'Baixando atualização, não saia dessa tela e aguarde...');
          // var downloadId = await UpdateApp.updateApp(
          //     url: res.data['valor'],
          //     appleId: "375380948",
          //     title: "Work",
          //     description: "Nova versão disponível");
          // var process = await UpdateApp.downloadProcess(downloadId: downloadId);
          // EasyLoading.dismiss();
          // print(process);
        } else {
          throw Exception('Não foi possível baixar o app');
        }
      } else {
        Get.snackbar('Ops', 'Você já esta usando a versão mais recente do APP',
            backgroundColor: Colors.orangeAccent,
            colorText: Colors.white,
            duration: Duration(seconds: 3),
            margin: EdgeInsets.only(top: 10, left: 10, right: 10));
      }
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      print(e);
      Get.snackbar(
          'Ops',
          '1UDT - Erro ao atualizar o APP, tente novamente mais tarde ' +
              e.toString(),
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
          margin: EdgeInsets.only(top: 10, left: 10, right: 10));
    } finally {
      EasyLoading.dismiss();
    }
  }
}
