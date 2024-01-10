import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:oliveira_fotos/App.routes.dart';
import 'package:oliveira_fotos/app/pages/listas/Listas.controller.dart';

class SelectListOsType extends StatelessWidget {
  final ListaController controller = Get.find<ListaController>();
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
                    leading: Icon(FeatherIcons.clock),
                    title: Text('Aguardando'),
                    subtitle: Text(
                        'Exibe todas as Os que estão aguardando para serem vendidas'),
                    onTap: () async {
                      await box.write('listaStatus', 'AGUARDANDO');
                      controller.filterList();
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(FeatherIcons.checkCircle),
                    title: Text('Finalizadas'),
                    subtitle: Text(
                        'Exibe todas as Os (Executados e não executadas) que estão aguardado o envio'),
                    onTap: () async {
                      await box.write('listaStatus', 'FINALIZADOS');
                      controller.filterList();
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(FeatherIcons.cloud),
                    title: Text('Enviadas'),
                    subtitle: Text('Exibe todas as Os que ja foram enviadas'),
                    onTap: () async {
                      await box.write('listaStatus', 'ENVIADOS');
                      controller.filterList();
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(FeatherIcons.grid),
                    title: Text('Todas'),
                    subtitle: Text('Exibe todas as Os'),
                    onTap: () async {
                      await box.write('listaStatus', 'TODOS');
                      controller.filterList();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            )));
  }
}
