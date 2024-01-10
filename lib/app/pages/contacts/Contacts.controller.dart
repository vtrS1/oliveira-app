import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:oliveira_fotos/app/models/contato.model.dart';

import 'package:oliveira_fotos/app/models/Os.model.dart';
import 'package:oliveira_fotos/app/pages/os/os.controller.dart';
import 'package:oliveira_fotos/app/repository/Contato.repository.dart';

class ContactsController extends GetxController {
  final formKey = new GlobalKey<FormState>();
  final Os os = GetStorage().read('os');
  bool loading = false;
  List<Contato> contacts = [];
  Contato newContact = new Contato();

  @override
  void onInit() {
    super.onInit();

    init();
  }

  init() async {
    loading = true;
    List<Contato> contatos = await ContatoRepository().getByOs(os.id!);
    this.contacts = contatos;
    loading = false;
    update();
  }

  toggleContact(Contato contato) async {
    loading = true;
    if (contato.status == 1) {
      contato.status = 0;
    } else {
      contato.status = 1;
    }
    await ContatoRepository().updateOne(contato);
    this.contacts = await ContatoRepository().getByOs(os.id!);
    await Get.find<OsViewController>().fetchContatos();
    loading = false;
    update();
  }

  addContato(String contato) async {
    loading = true;
    newContact.os = os.id;
    newContact.contato = contato;
    await ContatoRepository().insert(newContact);
    loading = false;
    this.init();
    update();
  }

  static ContactsController get to => Get.find();
}
