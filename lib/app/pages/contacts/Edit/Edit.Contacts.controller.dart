import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oliveira_fotos/app/models/contato.model.dart';

import 'package:oliveira_fotos/app/models/Os.model.dart';
import 'package:oliveira_fotos/app/pages/contacts/Contacts.controller.dart';
import 'package:oliveira_fotos/app/pages/os/os.controller.dart';

class EditContactController extends GetxController {
  // Form
  final formKey = new GlobalKey<FormState>();
  TextEditingController contatoInputController = TextEditingController();
  int idTipoContato = 0;
  // Os
  Os? os;
  bool loading = false;
  Contato contacts = new Contato();

  editContato() async {
    loading = true;
    update();
    Contato c = new Contato();
    c.contato = contatoInputController.text;
    await Get.find<ContactsController>().init();
    await Get.find<OsViewController>().fetchContatos();
    loading = false;
    update();
  }

  static EditContactController get to => Get.find();
}
