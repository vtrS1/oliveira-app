import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oliveira_fotos/app/models/Os.model.dart';
import 'package:oliveira_fotos/app/models/Parcela.model.dart';
import 'package:oliveira_fotos/app/repository/Parcela.repository.dart';

class QuickCPFEdit extends StatefulWidget {
  final Os os;

  QuickCPFEdit({required this.os});

  @override
  State<QuickCPFEdit> createState() => _QuickCPFEditState();
}

class _QuickCPFEditState extends State<QuickCPFEdit> {
  TextEditingController cpfController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Editar CPF Os: ${widget.os.id}',
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
                        TextFormField(
                          controller: cpfController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                !CPFValidator.isValid(value)) {
                              return 'Digite um CPF válido';
                            }
                            return null;
                          },
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (!CPFValidator.isValid(cpfController.text)) {
                              EasyLoading.showError('CPF inválido');
                              return;
                            } else {
                              EasyLoading.show(
                                  status: "Verificando...",
                                  dismissOnTap: false,
                                  maskType: EasyLoadingMaskType.black);
                              List<Parcela> parcelas = await ParcelaRepository()
                                  .getByOs(widget.os.id!);
                              EasyLoading.dismiss();
                              for (Parcela parcela in parcelas) {
                                parcela.cpf = cpfController.text;
                                ParcelaRepository repository =
                                    ParcelaRepository();
                                repository.updateOne(parcela);
                              }
                              EasyLoading.showSuccess(
                                  'CPF atualizado com sucesso');
                              await Future.delayed(Duration(seconds: 2));
                              Navigator.of(context).pop();
                            }
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
                                  'Confirmar alteração',
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
