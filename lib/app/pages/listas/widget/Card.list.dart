import 'dart:convert';
import 'dart:io';
import 'package:animated_icon_button/animated_icon_button.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:oliveira_fotos/app/models/Boleto.model.dart';
import 'package:oliveira_fotos/app/models/FormaPagamento.model.dart';
import 'package:oliveira_fotos/app/models/Image.model.dart';
import 'package:oliveira_fotos/app/models/Os.model.dart';
import 'package:oliveira_fotos/app/models/Pessoa.model.dart';
import 'package:oliveira_fotos/app/models/Parcela.model.dart';
import 'package:oliveira_fotos/app/pages/payment/paymentCpf.view.dart';
import 'package:oliveira_fotos/app/pages/profile/Profile.controller.dart';
import 'package:oliveira_fotos/app/pages/settings/Settings.controller.dart';
import 'package:oliveira_fotos/app/repository/Boleto.repository.dart';
import 'package:oliveira_fotos/app/repository/FormaPagamento.repository.dart';
import 'package:oliveira_fotos/app/repository/Image.repository.dart';
import 'package:oliveira_fotos/app/repository/Parcela.repository.dart';
import 'package:oliveira_fotos/app/repository/Pessoa.repository.dart';
import 'package:oliveira_fotos/app/utils/consts.dart';
import 'package:oliveira_fotos/app/widgets/ExpandedSection.widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path/path.dart' as path;
import '../../../../App.routes.dart';

class CardList extends StatefulWidget {
  final Os os;

  CardList({required this.os});

  @override
  State<CardList> createState() => _CardListState();
}

class _CardListState extends State<CardList> with TickerProviderStateMixin {
  bool expanded = false;
  DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  GetStorage box = new GetStorage();
  List<Boleto> boletosOffline = [];
  List<Responsaveis> responsaveis = [];

  String getStatusByOs(Os os) {
    if (widget.os.motivo != null) return ' (${os.motivo!})';
    if (widget.os.status! == 1) return ' - Finalizada';
    if (widget.os.status! == 0) return ' - Aguardando';
    if (widget.os.status! == 2) return ' - Finalizada e Sincronizada';
    return '';
  }

  Color getColorByStatus(int status) {
    if (status == 0) return Colors.blue[300]!;
    if (status == 2) return Colors.green[300]!;
    if (status == 3) return Colors.red[300]!;
    if (status == 4) return Colors.orange[300]!;
    return Colors.green[300]!;
  }

  Color getColorBgByStatus(int status) {
    if (status == 0) return Colors.blue[50]!;
    if (status == 2) return Colors.green[200]!;
    if (status == 3) return Colors.red[200]!;
    if (status == 4) return Colors.orange[200]!;
    return Colors.green[100]!;
  }

  Future fetchBoletosOffline() async {
    List<Boleto> ls = await BoletoRepository().getByOs(widget.os.id!);
    if (ls.length > 0) {
      if (mounted) {
        setState(() {
          this.boletosOffline = ls;
        });
      }
    }
  }

  fetchResponsaveis() async {
    List<Responsaveis> responsaveis =
        await ResponsavelRepository().getByOs(widget.os.id!);
    if (mounted) {
      setState(() {
        this.responsaveis = responsaveis;
      });
    }
  }

  shareOs(Os os) async {
    try {
      EasyLoading().dismissOnTap = false;
      EasyLoading.show(
        status: "Recuperando dados...",
        dismissOnTap: false,
        maskType: EasyLoadingMaskType.black,
      );
      List<Parcela> parcelas = await ParcelaRepository().getByOs(os.id!);

      Map<String, dynamic> parcelasToSend = Map<String, dynamic>();
      parcelasToSend['parcelas'] = [];
      parcelasToSend['images'] = [];
      parcelasToSend['os'] = os.toJson();
      parcelasToSend['version'] = Constants.APP_VERSION;
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

      final directory = await getApplicationDocumentsDirectory();

      File fileOs = await File('${directory.path}/${os.id!}.json')
          .writeAsString(json.encode(parcelasToSend));

      await Share.shareFiles([fileOs.path], subject: 'OS ${os.id!}');
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      Get.snackbar('Ops...', 'Ocorreu um erro, tente novamente mais tarde',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
          margin: EdgeInsets.only(top: 10, left: 10, right: 10));
    } finally {
      EasyLoading.dismiss();
    }
  }

  @override
  void initState() {
    fetchBoletosOffline();
    fetchResponsaveis();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
            color: getColorBgByStatus(widget.os.status!),
            border: Border.all(color: Colors.black, width: 0.1),
            borderRadius: BorderRadius.circular(5)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'OS ${widget.os.id} ${getStatusByOs(widget.os)}',
                    style: GoogleFonts.lato(
                        fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                  Row(
                    children: [
                      boletosOffline.length > 0
                          ? Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Tooltip(
                                message: 'Boletos reservados',
                                child: Icon(FeatherIcons.creditCard,
                                    size: 16, color: Colors.orange[800]),
                              ),
                            )
                          : SizedBox(),
                      IconButton(
                          onPressed: () => shareOs(widget.os),
                          iconSize: 16,
                          icon: Icon(FeatherIcons.share2),
                          color: Colors.grey[800]),
                      AnimatedIconButton(
                        size: 25,
                        padding: EdgeInsets.all(0),
                        onPressed: () {
                          setState(() {
                            expanded = !expanded;
                          });
                        },
                        duration: Duration(milliseconds: 200),
                        icons: [
                          AnimatedIconItem(
                              icon: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: getColorByStatus(widget.os.status!),
                          )),
                          AnimatedIconItem(
                              icon: Icon(
                            Icons.keyboard_arrow_up_rounded,
                            color: Colors.red,
                          )),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            widget.os.motivo != null
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Text(
                          'Obs.: ${widget.os.obs}',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  )
                : SizedBox(),
            Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, bottom: 10, right: 30),
                child: Text(
                  widget.os.address(),
                  style: GoogleFonts.lato(fontSize: 16),
                  textAlign: TextAlign.center,
                )),

            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 15.0),
            //   child: Text('Aluno',
            //       style: GoogleFonts.lato(
            //           fontWeight: FontWeight.w600, fontSize: 16)),
            // ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                child: Center(
                  child: Text(
                    widget.os.pessoasNome!,
                    style: GoogleFonts.lato(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                )),
            ExpandedSection(
                expand: expanded,
                child: Container(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: ListView(
                    shrinkWrap: true,
                    // mainAxisAlignment: MainAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Text('Nome do pai',
                            style: GoogleFonts.lato(
                                fontWeight: FontWeight.w600, fontSize: 16)),
                        subtitle: Text(
                          widget.os.pessoasNomePai!,
                          style: GoogleFonts.lato(fontSize: 16),
                        ),
                      ),
                      ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Text('Nome da mãe',
                            style: GoogleFonts.lato(
                                fontWeight: FontWeight.w600, fontSize: 16)),
                        subtitle: Text(
                          widget.os.pessoasNomeMae!,
                          style: GoogleFonts.lato(fontSize: 16),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text('Instituição',
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.w600, fontSize: 16)),
                      Text(
                        widget.os.instituicoesNome!,
                        style: GoogleFonts.lato(fontSize: 16),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: OutlinedButton(
                            onPressed: () async {
                              EasyLoading.show(
                                  status: "Verificando OS ${widget.os.id}",
                                  dismissOnTap: false,
                                  maskType: EasyLoadingMaskType.black);
                              List<Parcela> parcelas = await ParcelaRepository()
                                  .getByOs(widget.os.id!);
                              EasyLoading.dismiss();
                              if (CPFValidator.isValid(parcelas.first.cpf)) {
                                Get.snackbar('Ops',
                                    'O CPF é válido, não é permitida a edição',
                                    backgroundColor: Colors.orange,
                                    colorText: Colors.white,
                                    duration: Duration(seconds: 3),
                                    margin: EdgeInsets.only(
                                        top: 10, left: 10, right: 10));
                              } else {
                                showCupertinoModalBottomSheet(
                                    expand: false,
                                    enableDrag: true,
                                    bounce: true,
                                    barrierColor: Colors.black.withOpacity(0.5),
                                    isDismissible: true,
                                    context: context,
                                    builder: (cttxReview) =>
                                        QuickCPFEdit(os: widget.os));
                              }
                            },
                            child: Text('Editar CPF')),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                )),
            getOptionsByOs(widget.os, boletosOffline, context),
            widget.os.status! == 2 && widget.os.motivo == null
                ? GestureDetector(
                    onTap: () async {
                      // Get.to(() => ReportView(os: widget.os));
                      try {
                        await Get.find<ProfileController>().fetchProfile();
                        if (Get.find<ProfileController>()
                                    .vendedor
                                    .value
                                    .assinatura !=
                                null &&
                            Get.find<ProfileController>()
                                    .vendedor
                                    .value
                                    .assinaturaTestemunha !=
                                null) {
                          await launch(Constants.API_HOST +
                              'external/contrato/' +
                              widget.os.id.toString());
                        } else {
                          Get.snackbar('Ops...',
                              'Você precisa cadastrar a sua assinatura e a de uma testemunha primeiro, acesse o 3º menu (Perfil) para criar uma',
                              backgroundColor: Colors.orangeAccent,
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
                        Get.snackbar(
                            'Erro', 'Ocorreu um erro ao arir este contrato',
                            backgroundColor: Colors.black54,
                            colorText: Colors.white,
                            duration: Duration(seconds: 3),
                            margin:
                                EdgeInsets.only(top: 10, left: 10, right: 10));
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(
                          left: 15, top: 5, bottom: 5, right: 5),
                      decoration: BoxDecoration(color: Colors.green[400]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Ver contrato da os',
                            style: GoogleFonts.poppins(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          Icon(
                            Icons.arrow_right,
                            size: 35,
                          )
                        ],
                      ),
                    ),
                  )
                : SizedBox()
          ],
        ));
  }

  Widget getOptionsByOs(Os os, List<Boleto> boletos, BuildContext cttx) {
    if (os.status == 2 && os.motivo == null) {
      return GestureDetector(
        onTap: () async {
          // await box.write('os', os);
          // Get.offNamedUntil(PARTIAL_ROUTE, (route) => false);
          try {
            await launch(
                Constants.API_HOST + 'external/boletos/' + os.id!.toString());
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
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(left: 15, top: 5, bottom: 5, right: 5),
          decoration: BoxDecoration(color: Colors.green),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ver boletos da OS',
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Icon(
                Icons.arrow_right,
                size: 35,
              )
            ],
          ),
        ),
      );
    }
    if (os.status == 0) {
      return GestureDetector(
        onTap: () async {
          List<FormaPagamento> fPagamentos =
              await FormaPagamentoRepository().getAll();
          if (fPagamentos.length == 0) {
            await Get.find<SettingsController>().updateFormaPagamento();
          }
          await box.write('os', os);
          Get.toNamed(OS_ROUTE);
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(left: 15, top: 5, bottom: 5, right: 5),
          decoration: BoxDecoration(color: getColorByStatus(os.status!)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ver detalhes da OS',
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Icon(
                Icons.arrow_right,
                size: 35,
              )
            ],
          ),
        ),
      );
    }
    if (boletos.length > 0) {
      return GestureDetector(
        onTap: () async {
          await box.write('os', os);
          Get.offNamedUntil(PARTIAL_OFFLINE_ROUTE, (route) => false);
          // await box.write('os', os);
          // showCupertinoModalBottomSheet(
          //     expand: false,
          //     enableDrag: true,
          //     bounce: true,
          //     isDismissible: true,
          //     context: cttx,
          //     builder: (context) => ReservBillNumbers());
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(left: 15, top: 5, bottom: 5, right: 5),
          decoration: BoxDecoration(color: getColorByStatus(os.status!)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ver boletos reservados',
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Icon(Icons.arrow_right, size: 35)
            ],
          ),
        ),
      );
    }

    return SizedBox();
  }
}
