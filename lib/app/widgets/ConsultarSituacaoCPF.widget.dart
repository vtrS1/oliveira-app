import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oliveira_fotos/app/pages/payment/payment.provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class ConsultarSituacaoCPFWidget extends StatefulWidget {
  @override
  _ConsultarSituacaoCPFWidgetState createState() =>
      _ConsultarSituacaoCPFWidgetState();
}

class _ConsultarSituacaoCPFWidgetState
    extends State<ConsultarSituacaoCPFWidget> {
  TextEditingController _controllerCPF = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: MediaQuery.of(context).viewInsets,
        child: Padding(
          padding: EdgeInsets.only(top: 20.0, bottom: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Consultar situação do CPF',
                style: Get.textTheme.bodyText1!.copyWith(fontSize: 18),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: TextFormField(
                  controller: _controllerCPF,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'CPF do sacado',
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () async {
                  String cpf = _controllerCPF.text;

                  if (CPFValidator.isValid(cpf)) {
                    try {
                      EasyLoading.show(
                        status: 'Buscando informações...',
                        dismissOnTap: false,
                        maskType: EasyLoadingMaskType.black,
                      );
                      bool? isNotValid = await PaymentProvider().checkCPF(cpf);
                      EasyLoading.dismiss();
                      if (isNotValid == true) {
                        Get.snackbar('Aviso', '',
                            snackPosition: SnackPosition.TOP,
                            duration: Duration(seconds: 7),
                            margin: EdgeInsets.all(20),
                            backgroundColor: Colors.red[800],
                            colorText: Colors.white,
                            messageText: Text(
                              'Foram encontradas restrições de venda para esse CPF no sistema, uma nova venda não será liberada enquanto a pendência não for resolvida com o setor financeiro.',
                              style: GoogleFonts.poppins(
                                  fontSize: 16, color: Colors.white),
                            ),
                            icon: Icon(Icons.warning));
                      } else {
                        Get.snackbar('Aviso', '',
                            snackPosition: SnackPosition.TOP,
                            duration: Duration(seconds: 3),
                            margin: EdgeInsets.all(20),
                            backgroundColor: Colors.green[800],
                            colorText: Colors.white,
                            messageText: Text(
                              'Não foram econtradas restrições para esse CPF. Venda liberada.',
                              style: GoogleFonts.poppins(
                                  fontSize: 16, color: Colors.white),
                            ),
                            icon: Icon(Icons.check));
                      }
                    } catch (e, stackTrace) {
                      await Sentry.captureException(
                        e,
                        stackTrace: stackTrace,
                      );
                      EasyLoading.dismiss();
                      // Get.snackbar('Aviso', '',
                      //     snackPosition: SnackPosition.TOP,
                      //     duration: Duration(seconds: 7),
                      //     margin: EdgeInsets.all(20),
                      //     backgroundColor: Colors.blue[800],
                      //     colorText: Colors.white,
                      //     messageText: Text(
                      //       'Não foi possível checar se há pendencias nesse CPF, a venda está liberada nesse primeiro momento.',
                      //       style: GoogleFonts.poppins(
                      //           fontSize: 16, color: Colors.white),
                      //     ),
                      //     icon: Icon(Icons.warning));
                    }
                  } else {
                    Get.snackbar('Aviso', '',
                        snackPosition: SnackPosition.TOP,
                        duration: Duration(seconds: 7),
                        margin: EdgeInsets.all(20),
                        backgroundColor: Colors.orange[800],
                        colorText: Colors.white,
                        messageText: Text(
                          'Digite um CPF válido',
                          style: GoogleFonts.poppins(
                              fontSize: 16, color: Colors.white),
                        ),
                        icon: Icon(Icons.warning));
                  }
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.green[500],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Consultar',
                          style: Get.textTheme.bodyText1!
                              .copyWith(fontSize: 18, color: Colors.white)),
                      Icon(Icons.search, color: Colors.white, size: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
