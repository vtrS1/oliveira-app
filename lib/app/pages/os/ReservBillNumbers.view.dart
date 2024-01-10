import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oliveira_fotos/app/models/Os.model.dart';
import 'package:oliveira_fotos/app/pages/os/os.controller.dart';

// ignore: must_be_immutable
class ReservBillNumbers extends StatelessWidget {
  var box = GetStorage();
  Os? os = GetStorage().read('os');
  OsViewController osController = Get.find<OsViewController>();
  TextEditingController motivoController = new TextEditingController();

  ReservBillNumbers() {
    osController.fetchBoletos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Reservar numeração dos boletos',
            style: Get.theme.appBarTheme.titleTextStyle,
          ),
          automaticallyImplyLeading: false,
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: CircleAvatar(
                backgroundColor: Colors.red[300],
                child: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            )
          ],
        ),
        bottomNavigationBar: SafeArea(
            child: GetBuilder<OsViewController>(
                init: osController,
                initState: (_) => osController.fetchBoletos(),
                builder: (_) => osController.boletos != null &&
                        osController.boletos!.length > 0
                    ? SizedBox()
                    : GestureDetector(
                        onTap: () async {
                          await box.write('tipo', os!.tiposNome);
                          Navigator.of(context).pop();
                        },
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: GestureDetector(
                            onTap: () async {
                              if (!_.isLoading) {
                                await osController.offlineBills();
                              }
                            },
                            child: Container(
                              height: 60,
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.green[600]),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Sim, reservar numeração',
                                    style: GoogleFonts.lato(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Icon(Icons.save,
                                      color: Colors.white, size: 35),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ))),
        body: GetBuilder<OsViewController>(
            init: osController,
            builder: (_) {
              return osController.boletos == null ||
                      osController.boletos?.length == 0
                  ? Container(
                      padding: EdgeInsets.all(15),
                      child: ListView(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            Text(
                              'Sómente faça a reserva de númeração dos boletos se no local da venda você não tenha acesso a internet.',
                              style: Get.textTheme.bodyText1,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Lembre-se que com isso você terá que gerar e imprimir o boleto manualmente de acordo com o restante dos dados que você preencher no decorrer da venda.',
                              style: Get.textTheme.bodyText1,
                            ),
                          ]))
                  : Container(
                      padding: EdgeInsets.all(15),
                      child: ListView.builder(
                          itemCount: osController.boletos!.length + 1,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return Text(
                                'Você já reservou a numeração dos boletos para essa OS.',
                                textAlign: TextAlign.center,
                                style: Get.textTheme.bodyText1,
                              );
                            }
                            return ListTile(
                              title: Text('Boleto $index',
                                  style: GoogleFonts.lato(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600)),
                              subtitle: Text(
                                  osController.boletos![index - 1].nossoNumero
                                      .toString(),
                                  style: GoogleFonts.lato(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w400)),
                            );
                          }));
            }));
  }
}
