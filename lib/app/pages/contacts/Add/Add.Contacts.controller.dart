import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oliveira_fotos/app/models/contato.model.dart';

import 'package:oliveira_fotos/app/models/Os.model.dart';
import 'package:oliveira_fotos/app/models/Tipocontato.model.dart';
import 'package:oliveira_fotos/app/pages/contacts/Contacts.controller.dart';
import 'package:oliveira_fotos/app/pages/os/os.controller.dart';
import 'package:oliveira_fotos/app/repository/contato.repository.dart';
import 'package:oliveira_fotos/app/repository/tipoContato.repository.dart';

class AddContactController extends GetxController {
  // Form
  final formKey = new GlobalKey<FormState>();
  TextEditingController contatoInputController = TextEditingController();
  int idTipoContato = 0;
  // Os
  Os? os;
  bool loading = false;
  List<Contato> contacts = [];
  List<TipoContato> tiposContatos = [];

  AddContactController() {
    init();
  }

  init() async {
    loading = true;
    List<TipoContato> tipos = await TipoContatosRepository().getAll();
    if (tipos.length > 0) {
      this.idTipoContato = tipos[0].id!;
    }
    this.tiposContatos = tipos;
    loading = false;
    update();
  }

  setTipoContato(int id) {
    this.idTipoContato = id;
    update();
  }

  addContato() async {
    loading = true;
    update();
    Contato c = new Contato();
    c.idTipoContato = idTipoContato;
    c.tipoContatosNome =
        tiposContatos.firstWhere((t) => t.id == idTipoContato).nome;
    c.contato = contatoInputController.text;
    c.os = os?.id;
    c.status = 1;
    c.idPessoa = os?.pessoasId;
    await ContatoRepository().insert(c);
    await Get.find<ContactsController>().init();
    await Get.find<OsViewController>().fetchContatos();
    contatoInputController.text = "";
    loading = false;
    update();
  }

  static AddContactController get to => Get.find();
}
