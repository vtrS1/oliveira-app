import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:oliveira_fotos/App.routes.dart';
import 'package:oliveira_fotos/app/models/Os.model.dart';
import 'package:oliveira_fotos/app/pages/partials/partials.controller.dart';
import 'package:oliveira_fotos/app/utils/consts.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';
import 'package:intl/intl.dart';

final oCcy = new NumberFormat("#,##0.00", "pt_BR");

// ignore: must_be_immutable
class PartialView extends GetView<PartialsViewController> {
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  var box = GetStorage();
  Os? os = GetStorage().read('os');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
              'Boletos da OS ' + os!.id!.toString() + ' - ${os!.pessoasNome}',
              style: Get.theme.appBarTheme.titleTextStyle),
          leading: IconButton(
              onPressed: () {
                Get.offNamedUntil(MAIN_ROUTE, (route) => false);
              },
              icon: Icon(Icons.arrow_back)),
          iconTheme: IconThemeData(color: Colors.black87),
          actions: [
            IconButton(
                tooltip: 'Imprimir todos os boletos',
                onPressed: () async {
                  try {
                    await launch(Constants.API_HOST +
                        'external/boletos/' +
                        os!.id!.toString());
                  } catch (e, stackTrace) {
                    await Sentry.captureException(
                      e,
                      stackTrace: stackTrace,
                    );
                    Get.snackbar('Erro',
                        'Ocorreu um erro ao imprimir todos os boletos, tente novamente mais tarde. E006',
                        backgroundColor: Colors.black54,
                        colorText: Colors.white,
                        duration: Duration(seconds: 3),
                        margin: EdgeInsets.only(top: 10, left: 10, right: 10));
                  }
                },
                icon: Icon(Icons.print))
          ],
        ),
        // floatingActionButton: FloatingActionButton.extended(
        //   onPressed: () {
        //     Get.toNamed(QR_ROUTE);
        //   },
        //   label: Text('Boletos QR'),
        //   icon: Icon(Icons.qr_code),
        //   backgroundColor: Colors.blue,
        //   tooltip: 'Liberar boletos na página web',
        // ),
        body: Container(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: controller.obx(((data) => ListView.builder(
                shrinkWrap: true,
                itemCount: data!.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) => Container(
                    margin: (data.length - 1) != index
                        ? EdgeInsets.symmetric(vertical: 5, horizontal: 15)
                        : EdgeInsets.only(
                            top: 5, bottom: 80, left: 15, right: 15),
                    decoration: BoxDecoration(
                        color: (data[index].status == 0)
                            ? Colors.black54
                            : (data[index].status == 1)
                                ? Color(0xFFe8e5f3)
                                : (data[index].status == 2)
                                    ? Colors.green[200]
                                    : (data[index].status == 3)
                                        ? Colors.red[200]
                                        : Color(0xFFe8e5f3),
                        borderRadius: BorderRadius.circular(8)),
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              (data[index].parcela!.toString() == '0'
                                  ? 'ENTRADA'
                                  : 'Parcela ' +
                                      data[index].parcela!.toString()),
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 20),
                            ),
                            Text(
                                dateFormat.format(DateTime.parse(
                                    data[index].dataVencimento.toString())),
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 20)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15, bottom: 10, top: 10),
                        child: Text(
                          'R\$ ' + oCcy.format(data[index].valor),
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w700),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 10),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                    tooltip: 'Compartilhar link do boleto',
                                    onPressed: () async {
                                      try {
                                        Share.share(data[index].url!);
                                      } catch (e, stackTrace) {
                                        await Sentry.captureException(
                                          e,
                                          stackTrace: stackTrace,
                                        );
                                        Get.snackbar('Erro',
                                            'Ocorreu um erro ao abrir este boleto',
                                            backgroundColor: Colors.black54,
                                            colorText: Colors.white,
                                            duration: Duration(seconds: 3),
                                            margin: EdgeInsets.only(
                                                top: 10, left: 10, right: 10));
                                      }
                                    },
                                    icon: Icon(Icons.share,
                                        color: Colors.green[300])),
                                IconButton(
                                    tooltip: 'Abrir no navegador',
                                    onPressed: () async {
                                      try {
                                        await launch(data[index].url!);
                                      } catch (e, stackTrace) {
                                        await Sentry.captureException(
                                          e,
                                          stackTrace: stackTrace,
                                        );
                                        Get.snackbar('Erro',
                                            'Ocorreu um erro ao compartilhar este boleto',
                                            backgroundColor: Colors.black54,
                                            colorText: Colors.white,
                                            duration: Duration(seconds: 3),
                                            margin: EdgeInsets.only(
                                                top: 10, left: 10, right: 10));
                                      }
                                    },
                                    icon: Icon(Icons.open_in_browser,
                                        color: Colors.red[300])),
                                IconButton(
                                  tooltip: 'Imprimir/savar pdf do boleto',
                                  icon: Icon(
                                    Icons.print,
                                    color: Colors.blue[300],
                                  ),
                                  onPressed: () async {
                                    try {
                                      EasyLoading.show(
                                        status: 'Carregando boleto',
                                        dismissOnTap: false,
                                        maskType: EasyLoadingMaskType.black,
                                      );
                                      var res = await Dio().get(
                                          data[index].url! + '&compacto=1');
                                      if (res.statusCode == 200) {
                                        // await Printing.layoutPdf(
                                        //     onLayout:
                                        //         (PdfPageFormat format) async =>
                                        //             await Printing.convertHtml(
                                        //               format: format,
                                        //               html: res.data,
                                        //             ));
                                      } else {
                                        Get.snackbar('Erro',
                                            'Ocorreu um erro ao exibir o PDF deste boleto (E.2)',
                                            backgroundColor: Colors.black54,
                                            colorText: Colors.white,
                                            duration: Duration(seconds: 3),
                                            margin: EdgeInsets.only(
                                                top: 10, left: 10, right: 10));
                                      }
                                    } catch (e, stackTrace) {
                                      await Sentry.captureException(
                                        e,
                                        stackTrace: stackTrace,
                                      );
                                      Get.snackbar('Erro',
                                          'Ocorreu um erro ao exibir o PDF deste boleto',
                                          backgroundColor: Colors.black54,
                                          colorText: Colors.white,
                                          duration: Duration(seconds: 3),
                                          margin: EdgeInsets.only(
                                              top: 10, left: 10, right: 10));
                                    } finally {
                                      EasyLoading.dismiss();
                                    }
                                  },
                                ),
                              ]))
                    ])))))));
  }
}
