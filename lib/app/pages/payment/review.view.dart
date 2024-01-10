import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oliveira_fotos/app/models/Os.model.dart';
import 'package:oliveira_fotos/app/models/Parcela.model.dart';
import 'package:oliveira_fotos/app/pages/payment/payment.controller.dart';

// ignore: must_be_immutable
class ReviewPaymentView extends StatelessWidget {
  var box = GetStorage();
  Os? os = GetStorage().read('os');
  final List<Parcela> parcelas;
  final BuildContext cttxPayment;
  PaymentController controller = Get.find<PaymentController>();

  ReviewPaymentView({required this.parcelas, required this.cttxPayment});

  String getPartialInfo(Parcela partial) {
    String finalText = 'R\$ ' + partial.valor.toString();
    if (partial.nossoNumero != null) {
      finalText += ' - ' + partial.nossoNumero.toString();
    }
    return finalText;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Revisão da venda',
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
        body: SafeArea(
            child: Center(
          child: SingleChildScrollView(
              child: Container(
                  padding: EdgeInsets.all(15),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text('Nome completo',
                              style: GoogleFonts.montserrat(fontSize: 14)),
                          subtitle: Text(controller.inputNomeSacado.text,
                              style: GoogleFonts.montserrat(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text('CPF',
                              style: GoogleFonts.montserrat(fontSize: 14)),
                          subtitle: Text(controller.inputCPFSacado.text,
                              style: GoogleFonts.montserrat(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text('RG',
                              style: GoogleFonts.montserrat(fontSize: 14)),
                          subtitle: Text(controller.inputRGSacado.text,
                              style: GoogleFonts.montserrat(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text('Data de nascimento',
                              style: GoogleFonts.montserrat(fontSize: 14)),
                          subtitle: Text(
                              controller.dateFormat
                                  .format(controller.dateNascimentoSacado)
                                  .toString(),
                              style: GoogleFonts.montserrat(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text('Qtd. de parcelas',
                              style: GoogleFonts.montserrat(fontSize: 14)),
                          subtitle: Text(controller.inputQtdParcela.text,
                              style: GoogleFonts.montserrat(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text('Valor da entrada',
                              style: GoogleFonts.montserrat(fontSize: 14)),
                          subtitle: Text('${controller.inputValorEntrada.text}',
                              style: GoogleFonts.montserrat(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text('Data de vencimento da primeira parcela',
                              style: GoogleFonts.montserrat(fontSize: 14)),
                          subtitle: Text(
                              controller.dateFormat
                                  .format(controller.dateInitialParcel)
                                  .toString(),
                              style: GoogleFonts.montserrat(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                        Container(
                          width: Get.width,
                          child: Card(
                              color: Colors.orange,
                              child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                      'A partir dessa data que o vencimento das parcelas será gerado (a 1º terá a data de vencimento igual a escolhida, e as proximas terão 1 Mês de acrescimo apartir da última). Lembrando que a entrada tem sua data de recebimento dada como HOJE e não será influencida por essa data de vencimento.',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                          fontSize: 16)))),
                        ),
                        SizedBox(height: 20),
                        Text('Resumo das parcelas',
                            textAlign: TextAlign.left,
                            style: GoogleFonts.roboto(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        for (Parcela parcela in parcelas)
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                                (parcela.parcela == 0
                                        ? 'Entrada'
                                        : 'Parcela ${parcela.parcela}') +
                                    ' (' +
                                    controller.getNameFromIdFormaPagamento(
                                        parcela.idFormaPagamento!) +
                                    ')',
                                style: GoogleFonts.montserrat(fontSize: 14)),
                            subtitle: Text(getPartialInfo(parcela),
                                style: GoogleFonts.montserrat(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            Get.find<PaymentController>()
                                .finalizarVenda(cttxPayment);
                          },
                          child: Container(
                            height: 60,
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.green[600]),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Confirmar venda',
                                  style: GoogleFonts.lato(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                                Icon(Icons.check_circle,
                                    color: Colors.white, size: 35),
                              ],
                            ),
                          ),
                        ),
                      ]))),
        )));
  }
}
