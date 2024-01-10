import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oliveira_fotos/App.routes.dart';
import 'package:oliveira_fotos/app/models/Os.model.dart';
import 'package:intl/intl.dart';
import 'package:oliveira_fotos/app/pages/partials/partialsoffline.controller.dart';

final oCcy = new NumberFormat("#,##0.00", "pt_BR");

// ignore: must_be_immutable
class PartialOfflineView extends StatelessWidget {
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  final PartialsOfflineViewController controller =
      Get.put(PartialsOfflineViewController());
  var box = GetStorage();
  Os? os = GetStorage().read('os');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
              'Parcelas da OS ' + os!.id!.toString() + ' - ${os!.pessoasNome}',
              style: Get.theme.appBarTheme.titleTextStyle),
          leading: IconButton(
              onPressed: () {
                Get.offNamedUntil(MAIN_ROUTE, (route) => false);
              },
              icon: Icon(Icons.arrow_back)),
          iconTheme: IconThemeData(color: Colors.black87),
          actions: [
            IconButton(
                icon: Icon(FeatherIcons.printer),
                onPressed: () async {
                  await controller.printBills(os!);
                })
          ],
        ),
        body: GetBuilder<PartialsOfflineViewController>(
            init: controller,
            initState: (context) => controller.fetchPartials(),
            builder: (_) => Container(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: ListView(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Você reservou números de boletos para essa OS, gere os boletos de acordo com as informações abaixo',
                        textAlign: TextAlign.justify,
                        style: GoogleFonts.lato(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: controller.parcelas.length,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) => Container(
                            margin: (controller.parcelas.length - 1) != index
                                ? EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 15)
                                : EdgeInsets.only(
                                    top: 5, bottom: 80, left: 15, right: 15),
                            decoration: BoxDecoration(
                                color: Color(0xFFe8e5f3),
                                borderRadius: BorderRadius.circular(8)),
                            child: Column(children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0, vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      (controller.parcelas[index].parcela
                                                  .toString() ==
                                              '0'
                                          ? 'ENTRADA'
                                          : 'Parcela ' +
                                              controller.parcelas[index].parcela
                                                  .toString()),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20),
                                    ),
                                    Text(
                                        dateFormat.format(DateTime.parse(
                                                controller
                                                    .parcelas[index].dataInicial
                                                    .toString())
                                            .add(Duration(
                                                days: 30 *
                                                    controller.parcelas[index]
                                                        .parcela!))),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 20)),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15.0, right: 15, bottom: 10, top: 10),
                                child: Text(
                                  'R\$ ' +
                                      oCcy.format(double.parse(
                                          controller.parcelas[index].valor!)),
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15.0, right: 15, bottom: 10, top: 10),
                                child: Text(
                                  controller.getNameFromIdFormaPagamento(
                                          controller.parcelas[index]
                                              .idFormaPagamento!) +
                                      '\n' +
                                      (controller.parcelas[index].nossoNumero ==
                                              null
                                          ? ''
                                          : controller
                                              .parcelas[index].nossoNumero
                                              .toString()),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ]))),
                  ],
                ))));
  }
}
