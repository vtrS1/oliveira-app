import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:oliveira_fotos/app/models/FormaPagamento.model.dart';
import 'package:oliveira_fotos/app/models/Parcela.model.dart';
import 'package:oliveira_fotos/app/pages/payment/payment.controller.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:oliveira_fotos/app/pages/payment/review.view.dart';
import 'package:oliveira_fotos/app/repository/FormaPagamento.repository.dart';

class PaymentView extends GetView<PaymentController> {
  selectionarFormaPagamento() {
    return Get.bottomSheet(BottomSheet(
        onClosing: () {},
        builder: (context) => Container(
              padding: EdgeInsets.zero,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text('Forma de pagamento',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child:
                        Icon(Icons.arrow_drop_up_sharp, color: Colors.black54),
                  ),
                  Container(
                    height: 180,
                    child: controller.obx(((data) => Scrollbar(
                        isAlwaysShown: true,
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) => ListTile(
                            title: Text(
                              data![index].nome!,
                              style: TextStyle(fontWeight: FontWeight.w400),
                            ),
                            // subtitle: Text(
                            //     'Máximo de parcelas: ${data[index].parcela}'),
                            onTap: () {
                              controller.inputFormaPagamento = data[index].id!;
                              controller.update();
                              Navigator.of(context).pop();
                            },
                          ),
                          itemCount: data!.length,
                        )))),
                  ),
                  Center(
                    child: Icon(Icons.arrow_drop_down_sharp,
                        color: Colors.black54),
                  )
                ],
              ),
            )));
  }

  selectionarFormaPagamentoParcela(int idx, bool isEntrada) async {
    List<FormaPagamento> accepted = [];
    if (isEntrada) {
      accepted = await controller.getFormaPagamentoEntrada();
    } else {
      accepted = await FormaPagamentoRepository().getAll();
    }

    return Get.bottomSheet(BottomSheet(
        onClosing: () {},
        builder: (context) => Container(
              padding: EdgeInsets.zero,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text('Forma de pagamento da parcela',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child:
                        Icon(Icons.arrow_drop_up_sharp, color: Colors.black54),
                  ),
                  Container(
                    height: 180,
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) => ListTile(
                        title: Text(
                          accepted[index].nome!,
                          style: TextStyle(fontWeight: FontWeight.w400),
                        ),
                        onTap: () async {
                          bool res = await controller.setFormaPagamentoParcela(
                              accepted[index], idx);

                          controller.update();
                          if (res) {
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                      itemCount: accepted.length,
                    ),
                  ),
                  Center(
                    child: Icon(Icons.arrow_drop_down_sharp,
                        color: Colors.black54),
                  )
                ],
              ),
            )));
  }

  Future<void> sairSalvarModal(BuildContext ctxPage) async {
    return showCupertinoModalPopup(
        context: ctxPage,
        builder: (BuildContext context) => CupertinoActionSheet(
            title: Text(
              'Você ainda não salvou esse conteúdo',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400),
            ),
            actions: [
              CupertinoActionSheetAction(
                  child: Text('Sair sem salvar'),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    Get.back();
                  }),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: const Text('Ficar onde estou'),
              // isDefaultAction: true,
              onPressed: () {
                Navigator.pop(context);
              },
            )));
  }

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
          centerTitle: true,
          title: Text('Pagamento', style: Get.theme.appBarTheme.titleTextStyle),
          leading: IconButton(
              onPressed: () {
                sairSalvarModal(context);
                // Get.toNamed(MAIN_ROUTE);
              },
              icon: Icon(Icons.arrow_back)),
          iconTheme: IconThemeData(color: Colors.black87),
          actions: [
            Padding(
                padding: EdgeInsets.only(left: 10),
                child: IconButton(
                  tooltip: 'Finalizar venda',
                  onPressed: () async {
                    if (!CPFValidator.isValid(controller.inputCPFSacado.text)) {
                      Get.snackbar('Aviso', '',
                          snackPosition: SnackPosition.TOP,
                          duration: Duration(seconds: 7),
                          margin: EdgeInsets.all(20),
                          backgroundColor: Colors.blue[800],
                          colorText: Colors.white,
                          messageText: Text(
                            'Digite um CPF válido',
                            style: GoogleFonts.poppins(
                                fontSize: 16, color: Colors.white),
                          ),
                          icon: Icon(Icons.warning));
                    } else {
                      bool res = await controller
                          .checkCpf(controller.inputCPFSacado.text);
                      if (res) {
                        if (controller.formKey.currentState!.validate()) {
                          showCupertinoModalBottomSheet(
                              expand: false,
                              enableDrag: true,
                              bounce: true,
                              barrierColor: Colors.black.withOpacity(0.5),
                              isDismissible: true,
                              context: context,
                              builder: (cttxReview) => ReviewPaymentView(
                                  parcelas: controller.parcelas,
                                  cttxPayment: context));
                        }
                      }
                    }
                  },
                  icon: Icon(Icons.save),
                  color: Colors.green,
                ))
          ],
        ),
        body: Center(
            child: SingleChildScrollView(
                padding: EdgeInsets.all(10),
                child: Form(
                    onWillPop: () async {
                      sairSalvarModal(context);
                      return true;
                    },
                    key: controller.formKey,
                    autovalidateMode: AutovalidateMode.always,
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      TextFormField(
                        controller: controller.inputNomeSacado,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          labelText: 'Nome do sacado',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Digite algum nome';
                          }
                          return null;
                        },
                        onChanged: (val) {
                          if (controller.formKey.currentState != null) {
                            controller.formKey.currentState!.validate();
                          }
                        },
                      ),
                      TextFormField(
                        controller: controller.inputCPFSacado,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                            labelText: 'CPF do sacado',
                            suffixIcon: IconButton(
                              icon: Icon(Icons.search),
                              onPressed: () {
                                controller
                                    .checkCpf(controller.inputCPFSacado.text);
                              },
                            )),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              !CPFValidator.isValid(value)) {
                            return 'Digite um CPF válido';
                          }
                          return null;
                        },
                        onChanged: (val) {
                          if (controller.formKey.currentState != null) {
                            controller.formKey.currentState!.validate();
                          }
                        },
                        onSaved: (val) {
                          controller.checkCpf(controller.inputCPFSacado.text);
                        },
                      ),
                      TextFormField(
                        controller: controller.inputRGSacado,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'RG do sacado',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Digite um RG válido';
                          }
                          return null;
                        },
                        onChanged: (val) {
                          if (controller.formKey.currentState != null) {
                            controller.formKey.currentState!.validate();
                          }
                        },
                      ),
                      controller.obx(
                        ((data) => ListTile(
                            title: Text(
                              'Data de nascimento (Sacado)',
                              style: TextStyle(fontWeight: FontWeight.w400),
                            ),
                            contentPadding: EdgeInsets.zero,
                            onTap: () async {
                              DatePicker.showDatePicker(context,
                                  showTitleActions: true,
                                  theme: DatePickerTheme(
                                      backgroundColor: Colors.white,
                                      cancelStyle:
                                          TextStyle(color: Colors.red)),
                                  minTime: DateTime(1920, 01, 01),
                                  maxTime: DateTime.now(),
                                  onChanged: (date) {}, onConfirm: (date) {
                                controller.dateNascimentoSacado = new DateTime(
                                    date.year, date.month, date.day);
                                controller.update();
                              },
                                  currentTime: controller.dateNascimentoSacado,
                                  locale: LocaleType.pt);
                            },
                            subtitle: Text(controller.dateFormat
                                .format(controller.dateNascimentoSacado)
                                .toString()))),
                      ),
                      TextFormField(
                        controller: controller.inputQtdParcela,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        maxLength: 2,
                        decoration: InputDecoration(
                          labelText: 'Qtd. Parcelas',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Digite um número válido';
                          }

                          if (int.parse(value) < 0) {
                            return 'Digite um número maior ou igual a 0';
                          }

                          return null;
                        },
                        onChanged: (val) {
                          if (controller.formKey.currentWidget != null) {
                            controller.formKey.currentState!.validate();
                          }
                        },
                      ),
                      Container(
                        width: Get.width,
                        child: Card(
                            color: Colors.green[300],
                            child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                    ' A entrada não precisa ser incluída no "Qtd. de parcelas". Coloque 0 se o cliente for pagar a vista e no valor da entrada coloque o valor total.',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                        fontSize: 16)))),
                      ),
                      TextFormField(
                        controller: controller.inputValorUnitario,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          labelText: 'Valor total',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Digite um valor válido';
                          }

                          return null;
                        },
                        onChanged: (val) {
                          if (controller.formKey.currentState != null) {
                            controller.formKey.currentState!.validate();
                          }
                        },
                      ),
                      TextFormField(
                        controller: controller.inputValorEntrada,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Valor da entrada (opcional)',
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onChanged: (val) {
                          if (controller.formKey.currentState != null) {
                            controller.formKey.currentState!.validate();
                          }
                        },
                      ),
                      Container(
                        width: Get.width,
                        child: Card(
                            color: Colors.green[300],
                            child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                    'Se essa for uma venda no cartão de crédito, coloque no campo "Qtd. Parcelas" o mesmo número de parcelas que o cliente escolheu na maquininha do cartão!',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                        fontSize: 16)))),
                      ),
                      controller.obx(
                        ((data) => ListTile(
                            title: Text(
                              'Venc. da primeira parcela',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            onTap: () async {
                              DatePicker.showDatePicker(context,
                                  showTitleActions: true,
                                  theme: DatePickerTheme(
                                      backgroundColor: Colors.white,
                                      cancelStyle:
                                          TextStyle(color: Colors.red)),
                                  minTime: DateTime.now(),
                                  maxTime: DateTime(2090, 12, 31),
                                  onChanged: (date) {}, onConfirm: (date) {
                                controller.dateInitialParcel = new DateTime(
                                    date.year, date.month, date.day);
                                controller.update();
                              },
                                  currentTime: controller.dateInitialParcel,
                                  locale: LocaleType.pt);
                            },
                            subtitle: Text(controller.dateFormat
                                .format(controller.dateInitialParcel)
                                .toString()))),
                      ),
                      controller.obx(((data) => ListTile(
                            title: Text(
                              'Forma de pagamento',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            onTap: selectionarFormaPagamento,
                            subtitle: Text(data!
                                .firstWhere((element) =>
                                    element.id ==
                                    controller.inputFormaPagamento)
                                .nome!),
                          ))),
                      ElevatedButton(
                          onPressed: () async {
                            EasyLoading.show(
                              status: 'Gerando...',
                              dismissOnTap: false,
                              maskType: EasyLoadingMaskType.black,
                            );
                            await controller.gerarParcelas();
                            controller.update();
                            EasyLoading.dismiss();
                          },
                          style: ButtonStyle(),
                          child: Container(
                            height: 70,
                            child: Center(
                              child: Text('Gerar parcelas'),
                            ),
                          )),
                      Container(
                        child: GetBuilder<PaymentController>(
                          init: controller,
                          builder: (_) => ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: controller.parcelas.length,
                            itemBuilder: (context, index) => ListTile(
                              title: Text(
                                (controller.parcelas[index].parcela
                                                .toString() ==
                                            '0'
                                        ? 'Entrada'
                                        : 'Parcela ' +
                                            controller.parcelas[index].parcela
                                                .toString()) +
                                    ' (' +
                                    controller.getNameFromIdFormaPagamento(
                                        controller.parcelas[index]
                                            .idFormaPagamento!) +
                                    ')',
                                style: TextStyle(fontWeight: FontWeight.w400),
                              ),
                              subtitle: Text(
                                getPartialInfo(controller.parcelas[index]),
                                style: TextStyle(fontWeight: FontWeight.w400),
                              ),
                              trailing: Icon(Icons.mode_rounded),
                              onTap: () => selectionarFormaPagamentoParcela(
                                  index,
                                  controller.parcelas[index].parcela == 0),
                            ),
                          ),
                        ),
                      ),
                    ])))));
  }
}
