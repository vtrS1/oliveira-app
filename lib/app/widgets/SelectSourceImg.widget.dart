import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oliveira_fotos/App.routes.dart';
import 'package:oliveira_fotos/app/pages/settings/Settings.controller.dart';

class SelectSourceMidiaWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomSheet(
        onClosing: () {},
        builder: (context) => SafeArea(
                child: Container(
              padding: EdgeInsets.all(15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: Icon(Icons.collections),
                    title: Text('Galeria'),
                    onTap: () async {
                      await box.write('sourceMidia', 'galeria');
                      Navigator.pop(context);
                      Get.snackbar('Atualizado',
                          'Agora toda vez que você for selecionar uma foto para uma venda, essa será a opção padrão',
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                          duration: Duration(seconds: 3),
                          margin:
                              EdgeInsets.only(top: 10, left: 10, right: 10));
                      Get.find<SettingsController>().updateSourceMidia();
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.camera),
                    title: Text('Câmera'),
                    onTap: () async {
                      await box.write('sourceMidia', 'camera');
                      Navigator.pop(context);
                      Get.snackbar('Atualizado',
                          'Agora toda vez que você for selecionar uma foto para uma venda, essa será a opção padrão',
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                          duration: Duration(seconds: 3),
                          margin:
                              EdgeInsets.only(top: 10, left: 10, right: 10));
                      Get.find<SettingsController>().updateSourceMidia();
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.help),
                    title: Text('Sempre perguntar'),
                    onTap: () async {
                      await box.write('sourceMidia', 'perguntar');
                      Navigator.pop(context);
                      Get.snackbar('Atualizado',
                          'Agora toda vez que você for selecionar uma foto para uma venda, essa será a opção padrão',
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                          duration: Duration(seconds: 3),
                          margin:
                              EdgeInsets.only(top: 10, left: 10, right: 10));
                      Get.find<SettingsController>().updateSourceMidia();
                    },
                  ),
                ],
              ),
            )));
  }
}
