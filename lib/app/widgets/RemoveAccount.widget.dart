import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:oliveira_fotos/App.routes.dart';

class RemoveAccount extends StatelessWidget {
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
                  Text('Remover conta do APP',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                      'Ao clicar em confirmar, você removera a sua conta do APP. Serviços não sincronizados serão perdidos.',
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
                              icon: Icon(FeatherIcons.arrowLeftCircle))),
                      Flexible(
                          child: IconButton(
                              tooltip: 'Confirmar',
                              onPressed: () async {
                                Navigator.pop(context);
                                GetStorage box = GetStorage();
                                await box.remove('user');
                                await box.remove('cpf');
                                await box.remove('vendedor');
                                Get.offNamedUntil(
                                    LOGIN_ROUTE, (route) => false);
                              },
                              color: Colors.green,
                              icon: Icon(FeatherIcons.checkCircle))),
                    ],
                  )
                ],
              ),
            )));
  }
}
