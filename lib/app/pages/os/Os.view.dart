import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:oliveira_fotos/App.routes.dart';
import 'package:oliveira_fotos/app/models/Os.model.dart';
import 'package:oliveira_fotos/app/pages/os/ReportOs.view.dart';
import 'package:oliveira_fotos/app/pages/os/ReservBillNumbers.view.dart';
// import 'package:oliveira_fotos/app/pages/os/ReservBillNumbers.view.dart';
import 'package:oliveira_fotos/app/pages/os/os.controller.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class OsView extends StatelessWidget {
  var box = GetStorage();
  Os? os = GetStorage().read('os');
  final OsViewController controllerOs =
      Get.put<OsViewController>(OsViewController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OsViewController>(
      init: controllerOs,
      builder: (controller) => Scaffold(
          appBar: AppBar(
            title: Text(
              os!.pessoasNome ?? '',
              style: Get.theme.appBarTheme.titleTextStyle,
            ),
            automaticallyImplyLeading: false,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: CircleAvatar(
                  backgroundColor: Colors.red[300],
                  child: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              )
            ],
          ),
          bottomNavigationBar: SafeArea(
              child: GestureDetector(
            onTap: () async {
              controller.initService(os!);
            },
            child: Padding(
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 20),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.redAccent),
                    width: 60,
                    height: 60,
                    child: IconButton(
                      tooltip: 'Os não iniciada',
                      icon: Icon(Icons.info, color: Colors.white, size: 35),
                      onPressed: () async {
                        showCupertinoModalBottomSheet(
                            expand: false,
                            enableDrag: true,
                            barrierColor: Colors.black.withOpacity(0.5),
                            bounce: true,
                            isDismissible: true,
                            context: context,
                            builder: (context) =>
                                ReportOsView(homeCttx: context));
                      },
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.amber[700]),
                    width: 60,
                    height: 60,
                    child: IconButton(
                      tooltip: 'Reservar númeração de boletos',
                      onPressed: () async {
                        showCupertinoModalBottomSheet(
                            expand: false,
                            enableDrag: true,
                            bounce: true,
                            isDismissible: true,
                            barrierColor: Colors.black.withOpacity(0.5),
                            context: context,
                            builder: (context) => ReservBillNumbers());
                      },
                      icon: Icon(Icons.payment_rounded,
                          color: Colors.white, size: 35),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: Container(
                      height: 60,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.green[600]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Iniciar serviço',
                            style: GoogleFonts.lato(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                          Icon(Icons.play_arrow, color: Colors.white, size: 35),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
          body: controller.isLoadingData
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  child: ListView(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      children: [
                      Row(
                        children: [
                          Flexible(
                              child: ListTile(
                                  dense: true,
                                  subtitle: Text(os!.id!.toString(),
                                      style: GoogleFonts.lato(fontSize: 16)),
                                  title: Text("OS",
                                      style: GoogleFonts.lato(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700)))),
                          Flexible(
                            child: ListTile(
                                dense: true,
                                subtitle: Text(os!.fichasContrato.toString(),
                                    style: GoogleFonts.lato(fontSize: 16)),
                                title: Text("Contrato",
                                    style: GoogleFonts.lato(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700))),
                          ),
                          Flexible(
                              child: ListTile(
                                  dense: true,
                                  subtitle: Text(os!.fichasNumero.toString(),
                                      style: GoogleFonts.lato(fontSize: 16)),
                                  title: Text("Ficha",
                                      style: GoogleFonts.lato(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700)))),
                        ],
                      ),
                      Row(children: [
                        Flexible(
                            child: ListTile(
                                dense: true,
                                subtitle: Text(os!.fichasQtdFoto.toString(),
                                    style: GoogleFonts.lato(fontSize: 16)),
                                title: Text("Qtd. de fotos",
                                    style: GoogleFonts.lato(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700)))),
                        Flexible(
                            child: ListTile(
                                dense: true,
                                subtitle: Text(os!.tiposNome ?? '',
                                    style: GoogleFonts.lato(fontSize: 16)),
                                title: Text("Tipo das fotos",
                                    style: GoogleFonts.lato(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700))))
                      ]),
                      ListTile(
                          dense: true,
                          subtitle: Text(os!.pessoasNome ?? '',
                              style: GoogleFonts.lato(fontSize: 16)),
                          title: Text("Nome do aluno",
                              style: GoogleFonts.lato(
                                  fontSize: 16, fontWeight: FontWeight.w700))),
                      // ListTile(
                      //     dense: true,
                      //     subtitle: Text(os!.pessoasNome!.toString(),
                      //         style: GoogleFonts.lato(fontSize: 16)),
                      //     title: Text("Nome do responsável",
                      //         style: GoogleFonts.lato(
                      //             fontSize: 16, fontWeight: FontWeight.w700))),
                      // ListTile(
                      //     dense: true,
                      //     subtitle: Text(os!.pessoasNome!.toString(),
                      //         style: GoogleFonts.lato(fontSize: 16)),
                      //     title: Text("Nome do responsável",
                      //         style: GoogleFonts.lato(
                      //             fontSize: 16, fontWeight: FontWeight.w700))),
                      ListTile(
                          dense: true,
                          subtitle: Text(os!.instituicoesNome.toString(),
                              style: GoogleFonts.lato(fontSize: 16)),
                          title: Text("Instituição",
                              style: GoogleFonts.lato(
                                  fontSize: 16, fontWeight: FontWeight.w700))),
                      ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Endereço",
                                style: GoogleFonts.lato(
                                    fontSize: 16, fontWeight: FontWeight.w700)),
                            IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  Get.toNamed(ADDRESS_ROUTE, arguments: os);
                                },
                                tooltip: 'Editar endereço',
                                icon: Icon(
                                  FeatherIcons.edit,
                                  size: 18,
                                )),
                          ],
                        ),
                        subtitle: Container(
                          decoration: BoxDecoration(
                              // color: Get.theme.cardColor,
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(os!.fullAddress().toUpperCase(),
                              textAlign: TextAlign.justify,
                              style: Get.textTheme.bodyText1!.copyWith(
                                  fontSize: 16, fontWeight: FontWeight.w300)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, left: 15),
                        child: Text("Responsáveis",
                            style: GoogleFonts.lato(
                                fontSize: 16, fontWeight: FontWeight.w700)),
                      ),
                      Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          // padding: EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                              // color: Get.theme.cardColor,
                              borderRadius: BorderRadius.circular(5)),
                          child: ListView(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              children: [
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                  title: Text(os!.pessoasNomePai ?? '',
                                      style: Get.textTheme.bodyText1!.copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300)),
                                  leading: Icon(FeatherIcons.user,
                                      color: Colors.black87),
                                ),
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                  title: Text(os!.pessoasNomeMae ?? '',
                                      style: Get.textTheme.bodyText1!.copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300)),
                                  leading: Icon(FeatherIcons.user,
                                      color: Colors.black87),
                                ),
                              ])),
                      ListTile(
                          title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Contatos",
                              style: GoogleFonts.lato(
                                  fontSize: 16, fontWeight: FontWeight.w700)),
                          IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                Get.toNamed(CONTACTS_ROUTE);
                              },
                              tooltip: 'Editar contatos',
                              icon: Icon(
                                FeatherIcons.edit,
                                size: 18,
                              )),
                        ],
                      )),
                      Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: controller.contatos.length,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) => ListTile(
                              tileColor: controller.contatos[index].status == 0
                                  ? Colors.red[200]
                                  : Colors.transparent,
                              dense: true,
                              title: Text(
                                  controller.contatos[index].tipoContatosNome ??
                                      'Contato',
                                  style: Get.textTheme.bodyText1!.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400)),
                              subtitle: Text(
                                  controller.contatos[index].contato ?? '',
                                  style: Get.textTheme.bodyText1!.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300)),
                              trailing: Icon(Icons.call, color: Colors.green),
                              onTap: () async {
                                try {
                                  if (await canLaunch(
                                      controller.contatos[index].contato ??
                                          '')) {
                                    await launch(
                                        controller.contatos[index].contato ??
                                            '');
                                  }
                                } catch (e, stackTrace) {
                                  await Sentry.captureException(
                                    e,
                                    stackTrace: stackTrace,
                                  );
                                  Get.snackbar(
                                      'Erro',
                                      'Não foi possível ligar para o número ' +
                                          (controller.contatos[index].contato ??
                                              '') +
                                          ', o número foi copiado para a sua área de transferências',
                                      backgroundColor: Colors.black54,
                                      colorText: Colors.white,
                                      duration: Duration(seconds: 3),
                                      margin: EdgeInsets.only(
                                          top: 10, left: 10, right: 10));
                                }
                              },
                            ),
                          )),
                      SizedBox(
                        height: 200,
                      ),
                    ]))),
    );
  }
}
