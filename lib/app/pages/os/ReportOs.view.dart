import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:oliveira_fotos/app/models/Os.model.dart';
import 'package:oliveira_fotos/app/pages/os/os.controller.dart';
import 'package:oliveira_fotos/app/widgets/SelectMotivo.widget.dart';

// ignore: must_be_immutable
class ReportOsView extends StatelessWidget {
  var box = GetStorage();
  Os? os = GetStorage().read('os');
  OsViewController osController = Get.find<OsViewController>();
  TextEditingController motivoController = new TextEditingController();
  final BuildContext homeCttx;

  ReportOsView({required this.homeCttx});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Serviço não executado',
            style: Get.theme.appBarTheme.titleTextStyle,
          ),
          automaticallyImplyLeading: false,
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
            child: GestureDetector(
          onTap: () async {
            await box.write('tipo', os!.tiposNome);
            Navigator.of(context).pop();
          },
          child: Padding(
            padding: EdgeInsets.all(12),
            child: GestureDetector(
              onTap: () async {
                await osController.saveInfoOs();
                Navigator.of(context).pop();
                Navigator.of(this.homeCttx).pop();
              },
              child: Container(
                height: 60,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.green[600]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Salvar informações',
                      style: GoogleFonts.lato(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                    Icon(Icons.save, color: Colors.white, size: 35),
                  ],
                ),
              ),
            ),
          ),
        )),
        body: GetBuilder<OsViewController>(
            init: osController,
            builder: (_) {
              return Container(
                  padding: EdgeInsets.all(15),
                  child: ListView(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      children: [
                        Text(
                          'Informe o motivo',
                          style: Get.textTheme.bodyText1,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            showMaterialModalBottomSheet(
                                context: context,
                                builder: (context) => SelectMotivoWidget(
                                      update: _.setMotivo,
                                    ));
                          },
                          child: Container(
                            height: 70,
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            width: Get.size.width,
                            decoration: BoxDecoration(
                                color: Get.theme.cardColor,
                                borderRadius: BorderRadius.circular(5)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _.motivo,
                                  style: Get.textTheme.bodyText1!.copyWith(
                                      color: Get.theme.scaffoldBackgroundColor),
                                ),
                                Icon(Icons.arrow_drop_down,
                                    color: Get.theme.scaffoldBackgroundColor)
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Observação (Opcional)',
                          style: Get.textTheme.bodyText1,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              color: Get.theme.cardColor,
                              borderRadius: BorderRadius.circular(5)),
                          child: Center(
                            child: TextFormField(
                              minLines: 3,
                              maxLines: 10,
                              controller: _.obs,
                              style: Get.textTheme.bodyText1!.copyWith(
                                  color: Get.theme.scaffoldBackgroundColor),
                              decoration: new InputDecoration.collapsed(
                                  hintText: 'Digite sua oberservação aqui...'),
                            ),
                          ),
                        )
                      ]));
            }));
  }
}
