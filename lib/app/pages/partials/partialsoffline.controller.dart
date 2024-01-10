import 'dart:convert';
import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:oliveira_fotos/app/models/FormaPagamento.model.dart';
import 'package:oliveira_fotos/app/models/Os.model.dart';
import 'package:oliveira_fotos/app/models/Parcela.model.dart';
import 'package:oliveira_fotos/app/pages/payment/payment.provider.dart';
import 'package:oliveira_fotos/app/repository/FormaPagamento.repository.dart';
import 'package:oliveira_fotos/app/repository/Parametro.repository.dart';
import 'package:oliveira_fotos/app/repository/Parcela.repository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:share/share.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:dio/dio.dart' as DT;

class PartialsOfflineViewController extends GetxController {
  List<Parcela> parcelas = [];
  List<FormaPagamento> formasPagamentos = [];
  GetStorage box = GetStorage();
  static PartialsOfflineViewController get to => Get.find();

  PartialsOfflineViewController() {
    fetchPartials();
  }

  void fetchPartials() async {
    this.formasPagamentos = await FormaPagamentoRepository().getAll();
    this.parcelas =
        (await ParcelaRepository().getByOs(box.read<Os>('os')!.id!));
    // .where((element) => element.idBoleto != null)
    // .toList();
    update();
  }

  String getNameFromIdFormaPagamento(int id) {
    return this
        .formasPagamentos
        .firstWhere((element) => element.id == id)
        .nome!;
  }

  Future printBills(Os os) async {
    try {
      EasyLoading.show(
        status: 'Gerando boletos...',
        dismissOnTap: false,
        maskType: EasyLoadingMaskType.black,
      );
      Map<String, dynamic> data = {};
      data['parametros'] = await ParametrosRepository().toServer();
      data['os'] = os.toOfflineBill();
      data['vendedor'] = PaymentProvider().getVendedor()?.toOfflineBill();
      data['boletos'] = await ParcelaRepository().getByOs(os.id!);

      DT.Response html = await DT.Dio()
          .post('http://localhost:8080/', data: json.encode(data));
      String htmlContent = html.data.toString();

      var bytes = await Printing.convertHtml(
        format: PdfPageFormat(16 * PdfPageFormat.cm, 7.5 * PdfPageFormat.cm,
            marginAll: 0),
        html: htmlContent,
      );

      Directory appDocDir = await getApplicationDocumentsDirectory();
      final targetPath = appDocDir.path;
      final targetFileName = "boletos-app-${os.id}.pdf";
      File f =
          await File(targetPath + '/' + targetFileName).writeAsBytes(bytes);
      EasyLoading.dismiss();
      await Share.shareFiles([f.path]);
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      print(e);
      EasyLoading.dismiss();
    }
  }
}
