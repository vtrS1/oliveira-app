import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oliveira_fotos/app/models/Os.model.dart';
import 'package:oliveira_fotos/app/pages/listas/Listas.controller.dart';
import 'package:oliveira_fotos/app/repository/Contato.repository.dart';
import 'package:oliveira_fotos/app/repository/Image.repository.dart';
import 'package:oliveira_fotos/app/repository/Os.repository.dart';
import 'package:oliveira_fotos/app/repository/Parcela.repository.dart';
import 'package:oliveira_fotos/app/repository/Pessoa.repository.dart';

class CleanServicesWidget extends StatelessWidget {
  final ListaController listaController = Get.find<ListaController>();

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
                  Text('Limpeza',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                      'Ao clicar em confirmar, as Ordens de Serviço(OS) que já foram enviadas com sucesso seram removidas do aplicativo. Recomendamos que faça isso ao finalizar uma lista.',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w300)),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                          child: IconButton(
                              tooltip: 'Cancelar limpeza',
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              color: Colors.red,
                              icon: Icon(Icons.close))),
                      Flexible(
                          child: IconButton(
                              tooltip: 'Limpar OS finalizada',
                              onPressed: () async {
                                Navigator.pop(context);
                                List<Os> servicos =
                                    await OsRepository().getByStatus(2);
                                for (Os servico in servicos) {
                                  await ParcelaRepository()
                                      .deleteAllByOs(servico.id!);
                                  await ContatoRepository()
                                      .deleteAllByOs(servico.id!);
                                  await ImageRepository()
                                      .deleteImageByOs(servico.id!);
                                  await OsRepository().delete(servico.id!);
                                  await ResponsavelRepository()
                                      .deleteAllByOs(servico.id!);
                                }
                                await listaController.updateOfflineData();
                                listaController.update();
                                Get.snackbar('Sucesso',
                                    'As ordens de serviço(OS) que já haviam sido enviadas com sucesso foram removidas do aplicativo',
                                    backgroundColor: Colors.green,
                                    colorText: Colors.white,
                                    duration: Duration(seconds: 3),
                                    margin: EdgeInsets.only(
                                        top: 10, left: 10, right: 10));
                                Get.forceAppUpdate();
                              },
                              color: Colors.green,
                              icon: Icon(Icons.check_circle)))
                    ],
                  )
                ],
              ),
            )));
  }
}
