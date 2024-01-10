import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:oliveira_fotos/app/models/Os.model.dart';
import 'package:oliveira_fotos/app/pages/contacts/Add/Add.Contacts.controller.dart';

class AddContatoView extends StatelessWidget {
  final Os os;
  final AddContactController addContactController =
      Get.put<AddContactController>(AddContactController());

  AddContatoView(this.os) {
    this.addContactController.os = os;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddContactController>(
        init: addContactController,
        builder: (_) => SafeArea(
                child: Container(
              padding: MediaQuery.of(context).viewInsets,
              child: Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 20),
                child: Form(
                  key: addContactController.formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Cadastar novo contato',
                        style: Get.textTheme.bodyText1!.copyWith(fontSize: 18),
                      ),
                      _.loading && _.tiposContatos.length > 0
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              width: Get.width,
                              child: DropdownButton<int>(
                                  isExpanded: true,
                                  value: _.idTipoContato,
                                  items: _.tiposContatos
                                      .map((e) => DropdownMenuItem<int>(
                                            child: Text(e.nome ?? ''),
                                            value: e.id,
                                          ))
                                      .toList(),
                                  onChanged: (e) => _.setTipoContato(e!)),
                            ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20),
                        child: TextFormField(
                          controller:
                              addContactController.contatoInputController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: 'Contato',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (_.contatoInputController.text.length <= 0) {
                            Get.snackbar(
                              'Erro',
                              'Preencha o campo contato',
                              icon: Icon(
                                Icons.error,
                                color: Colors.red,
                              ),
                              backgroundColor: Colors.white,
                              colorText: Colors.red,
                            );
                            return;
                          }
                          await _.addContato();
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.green[500],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Cadastrar',
                                  style: Get.textTheme.bodyText1!.copyWith(
                                      fontSize: 18, color: Colors.white)),
                              Icon(FeatherIcons.plus,
                                  color: Colors.white, size: 30),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )));
  }
}
