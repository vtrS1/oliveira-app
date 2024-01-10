import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:oliveira_fotos/app/models/Os.model.dart';
import 'package:oliveira_fotos/app/pages/listas/Listas.controller.dart';
import 'package:oliveira_fotos/app/pages/os/Os.provider.dart';
import 'package:oliveira_fotos/app/repository/os.repository.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class ReservListBillsWidget extends StatefulWidget {
  @override
  _ReservListBillsWidgetState createState() => _ReservListBillsWidgetState();
}

class _ReservListBillsWidgetState extends State<ReservListBillsWidget> {
  TextEditingController listaController = TextEditingController();

  offlineListBills() async {
    try {
      List<Os> oss =
          await OsRepository().getByLista(int.parse(this.listaController.text));

      EasyLoading.showProgress(0.0, status: 'Gerando  numeracao');

      if (oss.length == 0) {
        Get.snackbar('Aviso', 'Nenhuma Os encontrada para a lista informada',
            backgroundColor: Colors.orange,
            colorText: Colors.white,
            duration: Duration(seconds: 3),
            margin: EdgeInsets.only(top: 10, left: 10, right: 10));
      } else {
        for (Os os in oss) {
          try {
            EasyLoading.showProgress((oss.indexOf(os) + 1) / oss.length,
                status:
                    'Gerando  numeracao ${oss.indexOf(os) + 1}/${oss.length}');

            await OsProvider().offlineBills(os.toReservBillJson());
          } catch (e, stackTrace) {
            EasyLoading.showProgress((oss.indexOf(os) + 1) / oss.length,
                status:
                    'ERRO - Ao gerar a numeracao dos boletos da os ${oss.indexOf(os) + 1}/${oss.length}');
            Sentry.captureException(e, stackTrace: stackTrace);
          }
        }
        Get.snackbar('Aviso', 'Numeração dos boletos reservada com sucesso',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: Duration(seconds: 3),
            margin: EdgeInsets.only(top: 10, left: 10, right: 10));
      }
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      Get.snackbar('Erro', e.toString(),
          backgroundColor: Colors.black54,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
          margin: EdgeInsets.only(top: 10, left: 10, right: 10));
      print(e);
    } finally {
      try {
        Get.find<ListaController>().updateData();
      } catch (e) {
        print(e);
      }
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: MediaQuery.of(context).viewInsets,
        child: Padding(
          padding: EdgeInsets.only(top: 20.0, bottom: 20, left: 20, right: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Reservar numeração de boletos para a lista',
                style: Get.textTheme.bodyText1!.copyWith(fontSize: 18),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Use essa opção apenas se você for para um local onde não terá acesso a internet para pelo menos a maioria das vendas'
                    .toUpperCase(),
                textAlign: TextAlign.center,
                style: Get.textTheme.bodyText1!
                    .copyWith(fontSize: 18, color: Colors.red),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: TextFormField(
                  controller: listaController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Número da Lista',
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () async {
                  await offlineListBills();
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.green[500],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Reservar numeração',
                          style: Get.textTheme.bodyText1!
                              .copyWith(fontSize: 18, color: Colors.white)),
                      Icon(Icons.data_saver_on, color: Colors.white, size: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
