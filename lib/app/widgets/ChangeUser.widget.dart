import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oliveira_fotos/App.routes.dart';
import 'package:oliveira_fotos/app/models/Os.model.dart';
import 'package:oliveira_fotos/app/repository/Contato.repository.dart';
import 'package:oliveira_fotos/app/repository/Image.repository.dart';
import 'package:oliveira_fotos/app/repository/Os.repository.dart';
import 'package:oliveira_fotos/app/repository/Parcela.repository.dart';

class ChangeUserWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomSheet(
        onClosing: () {},
        builder: (context) => Container(
              padding: EdgeInsets.all(15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Mudança de vendedor',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                      "Ao clicar em confirmar, as OS's que não foram iniciadas ou que já foram enviadas com sucesso serão removidas. Recomendamos que faça isso somente se estiver conectado a internet.",
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
                              tooltip: 'Cancelar',
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              color: Colors.red,
                              icon: Icon(Icons.close))),
                      Flexible(
                          child: IconButton(
                              tooltip: 'Mudar vendedor',
                              onPressed: () async {
                                List<Os> servicos =
                                    await OsRepository().getAll();
                                for (Os servico in servicos) {
                                  if (servico.status == 0 ||
                                      servico.status == 2) {
                                    await ParcelaRepository()
                                        .deleteAllByOs(servico.id!);
                                    await ContatoRepository()
                                        .deleteAllByOs(servico.id!);
                                    await ImageRepository()
                                        .deleteImageByOs(servico.id!);
                                    await OsRepository().delete(servico.id!);
                                  }
                                }
                                Get.offNamedUntil(
                                    LOGIN_ROUTE, (route) => false);
                              },
                              color: Colors.green,
                              icon: Icon(Icons.check_circle)))
                    ],
                  )
                ],
              ),
            ));
  }
}
