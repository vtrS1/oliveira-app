import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:oliveira_fotos/app/models/Estado.model.dart';
import 'package:oliveira_fotos/app/pages/address/Address.controller.dart';
import 'package:dropdown_search/dropdown_search.dart' as DS;

class AddressView extends StatelessWidget {
  final AddressController _controller =
      Get.put<AddressController>(AddressController());
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

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddressController>(
        init: _controller,
        builder: (controller) => Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text('Endereço (Os: ${controller.os.id.toString()})',
                  style: Get.theme.appBarTheme.titleTextStyle!
                      .copyWith(fontSize: 18)),
              automaticallyImplyLeading: true,
              iconTheme: IconThemeData(color: Colors.black87),
              actions: [
                IconButton(
                  icon: Icon(FeatherIcons.save),
                  onPressed: () async {
                    if (controller.formKey.currentState!.validate()) {
                      await controller.updateOsAddress();
                      Get.snackbar('Sucesso', 'O endereço foi atualizado',
                          backgroundColor: Colors.green,
                          snackPosition: SnackPosition.TOP,
                          colorText: Colors.white,
                          margin: EdgeInsets.all(20));
                      await Future.delayed(Duration(seconds: 4));
                      Get.back();
                    } else {
                      Get.snackbar(
                          'Aviso', 'Preencha todos os campos obrigatórios',
                          backgroundColor: Colors.orangeAccent,
                          snackPosition: SnackPosition.BOTTOM,
                          margin: EdgeInsets.all(20));
                    }
                  },
                )
              ],
            ),
            body: SingleChildScrollView(
                padding: EdgeInsets.all(10),
                child: Form(
                    onWillPop: () async {
                      sairSalvarModal(context);
                      return true;
                    },
                    key: controller.formKey,
                    autovalidateMode: AutovalidateMode.always,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: Get.width * 0.8,
                                child: TextFormField(
                                  controller: controller.inputCEPSacado,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'CEP',
                                  ),
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty ||
                                        value.length != 8) {
                                      return 'Digite um CEP válido';
                                    }
                                    return null;
                                  },
                                  onChanged: (val) {
                                    if (controller.formKey.currentState !=
                                        null) {
                                      controller.formKey.currentState!
                                          .validate();
                                    }
                                  },
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    if (controller.inputCEPSacado.text.length !=
                                        8) {
                                      Get.snackbar('Aviso',
                                          'Preencha o CEP corretamente',
                                          backgroundColor: Colors.orangeAccent,
                                          colorText: Colors.white,
                                          snackPosition: SnackPosition.TOP,
                                          margin: EdgeInsets.all(20));
                                    } else {
                                      controller.fetchCEP();
                                    }
                                  },
                                  icon: Icon(Icons.search)),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          DS.DropdownSearch<Estado>(
                              mode: DS.Mode.BOTTOM_SHEET,
                              items: controller.estados,
                              showSearchBox: true,
                              label: "Estado",
                              itemAsString: (estado) => estado!.nome,
                              onChanged: controller.setEstado,
                              selectedItem: controller.estadoSelecionado),
                          // TextFormField(
                          //   controller: controller.inputEmailSacado,
                          //   keyboardType: TextInputType.emailAddress,
                          //   decoration: InputDecoration(
                          //     labelText: 'Email',
                          //   ),
                          //   validator: (value) {
                          //     if (value == null ||
                          //         value.isEmpty ||
                          //         !value.isEmail) {
                          //       return 'Digite um email válido';
                          //     }
                          //     return null;
                          //   },
                          //   onChanged: (val) {
                          //     if (controller.formKey.currentState != null) {
                          //       controller.formKey.currentState!.validate();
                          //     }
                          //   },
                          // ),
                          // TextFormField(
                          //   controller: controller.inputTelefoneSacado,
                          //   keyboardType: TextInputType.phone,
                          //   decoration: InputDecoration(
                          //     labelText: 'Telefone',
                          //   ),
                          //   validator: (value) {
                          //     if (value == null ||
                          //         value.isEmpty ||
                          //         !value.isPhoneNumber) {
                          //       return 'Digite um número de telefone válido';
                          //     }
                          //     return null;
                          //   },
                          //   onChanged: (val) {
                          //     if (controller.formKey.currentState != null) {
                          //       controller.formKey.currentState!.validate();
                          //     }
                          //   },
                          // ),
                          TextFormField(
                            controller: controller.inputCidadeSacado,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              labelText: 'Cidade',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Digite uma cidade válida';
                              }
                              return null;
                            },
                            onChanged: (val) {
                              if (controller.formKey.currentState != null) {
                                controller.formKey.currentState!.validate();
                              }
                              controller.update();
                            },
                          ),
                          TextFormField(
                            controller: controller.inputBairroSacado,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              labelText: 'Bairro',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Digite um bairro válido';
                              }
                              return null;
                            },
                            onChanged: (val) {
                              if (controller.formKey.currentState != null) {
                                controller.formKey.currentState!.validate();
                              }
                              controller.update();
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          DS.DropdownSearch<String>(
                              mode: DS.Mode.BOTTOM_SHEET,
                              items: controller.tipoDeLogradouro,
                              showSearchBox: true,
                              label: "Tipo de endereço",
                              // itemAsString: (estado) => estado!.nome,
                              onChanged: controller.setLogradouro,
                              selectedItem: controller.tipoLogradouro),
                          TextFormField(
                            controller: controller.inputLogradouroSacado,
                            keyboardType: TextInputType.streetAddress,
                            maxLines: 2,
                            minLines: 1,
                            decoration: InputDecoration(
                              labelText: 'Endereço',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Digite um endereço válido';
                              }
                              return null;
                            },
                            onChanged: (val) {
                              if (controller.formKey.currentState != null) {
                                controller.formKey.currentState!.validate();
                              }
                              controller.update();
                            },
                          ),

                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text('Esse endereço possui um número?'),
                            subtitle:
                                Text('Se sim, deixe o campo ao lado marcado'),
                            value: controller.hasNumber,
                            onChanged: (val) {
                              controller.changeHasNumber(val);
                            },
                          ),
                          controller.hasNumber
                              ? TextFormField(
                                  controller: controller.inputNumeroSacado,
                                  keyboardType: TextInputType.streetAddress,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Digite um número válido';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Número da residência',
                                  ),
                                  onChanged: (val) {
                                    if (controller.formKey.currentState !=
                                        null) {
                                      controller.formKey.currentState!
                                          .validate();
                                    }
                                    controller.update();
                                  },
                                )
                              : SizedBox(),
                          TextFormField(
                            controller: controller.inputComplementoSacado,
                            keyboardType: TextInputType.streetAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Digite um complemento válido';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Complemento',
                            ),
                            onChanged: (val) {
                              if (controller.formKey.currentState != null) {
                                controller.formKey.currentState!.validate();
                              }
                              controller.update();
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text('Resultado final'.toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600)),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            width: Get.width,
                            decoration: BoxDecoration(
                              color: Colors.green[400],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Endereço: ${controller.tipoLogradouro} ${controller.inputLogradouroSacado.text} ${controller.hasNumber ? 'nº' + controller.inputNumeroSacado.text : 'S/N'}\nComplemento: ${controller.inputComplementoSacado.text}\nCEP: ${controller.inputCEPSacado.text}\nBairro: ${controller.inputBairroSacado.text}\nCidade: ${controller.inputCidadeSacado.text}\nEstado: ${controller.inputEstadoSacado.text}',
                              textAlign: TextAlign.left,
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          )
                        ])))));
  }
}
