import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oliveira_fotos/App.routes.dart';
import 'package:oliveira_fotos/app/models/Image.model.dart';
import 'package:oliveira_fotos/app/models/Os.model.dart';
import 'package:oliveira_fotos/app/pages/detail/camera/camera.view.dart';
import 'package:oliveira_fotos/app/pages/detail/detail.controller.dart';
import 'package:oliveira_fotos/app/pages/signature/signature.view.dart';
import 'package:oliveira_fotos/app/repository/Os.repository.dart';
import 'package:oliveira_fotos/app/utils/consts.dart';
import 'package:oliveira_fotos/app/widgets/textdivider.widget.dart';

import 'preview/ImagePreview.view.dart';

class DetailView extends StatefulWidget {
  @override
  _DetailViewState createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  DetailController controller = Get.put<DetailController>(DetailController());
  var box = GetStorage();
  Os? os;

  FutureOr onGoBack(dynamic value) {
    controller.fetchImages();
    setState(() {
      FocusScope.of(context).requestFocus(FocusNode());
    });
  }

  @override
  void initState() {
    super.initState();
    controller.onInit();
    this.os = box.read('os');
    // box.write('tipo', Constants.KIT);
  }

  Future<List<ImageModel>> fetchData(String? tipo) async {
    switch (tipo) {
      case Constants.TIPO_ASSINATURA:
        return controller.fetchAssinaturas();
      case Constants.TIPO_ASSINATURA_DIGITAL:
        return controller.fetchAssinaturaDigital();
      case Constants.TIPO_ASSINATURA_DIGITAL_T1:
        return controller.fetchAssinaturaDigitalT1();
      case Constants.TIPO_ASSINATURA_DIGITAL_T2:
        return controller.fetchAssinaturaDigitalT2();
      case Constants.TIPO_CPF:
        return controller.fetchCpf();
      case Constants.TIPO_RG:
        return controller.fetchRG();
      case Constants.TIPO_COMP_RESIDENCIA:
        return controller.fetchCompResidencia();
      default:
        return <ImageModel>[];
    }
  }

  takePicture() {
    Route route = MaterialPageRoute(builder: (context) => CameraView());
    Navigator.push(context, route).then(onGoBack);
  }

  previewImage(ImageModel image, {bool signature = false}) {
    Route route = MaterialPageRoute(
        builder: (context) => ImagePreview(image, signature: true));
    Navigator.push(context, route).then(onGoBack);
  }

  signature({bool clear = false, String? typeSignature}) async {
    if (clear) {
      if (typeSignature == Constants.TIPO_ASSINATURA_DIGITAL) {
        await box.write('clearSignature', true);
      }
      if (typeSignature == Constants.TIPO_ASSINATURA_DIGITAL_T1) {
        await box.write('clearSignatureT1', true);
      }
      if (typeSignature == Constants.TIPO_ASSINATURA_DIGITAL_T2) {
        await box.write('clearSignatureT2', true);
      }
    }

    Route route = MaterialPageRoute(
        builder: (context) => SignatureView(
              typeSingature: typeSignature!,
            ));
    Navigator.push(context, route).then(onGoBack);
  }

  salvar() async {
    String? res = controller.validarFormulario();
    if (res == null) {
      Os? os = await OsRepository().getOne(this.os!.id!);
      if (os != null) {
        os.testemunha1Nome = this.controller.nomeT1Controller.text;
        os.testemunha2Nome = this.controller.nomeT2Controller.text;
        await OsRepository().updateOne(os);
      }
      Get.offAndToNamed(PAYMENT_ROUTE);
    } else {
      Get.snackbar('Aviso', res,
          backgroundColor: Colors.black54,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
          margin: EdgeInsets.only(top: 10, left: 10, right: 10));
    }
  }

  Future<void> sairSalvarModal(BuildContext ctxPage) async {
    return showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
            title: Text(
              'Você ainda não salvou esse conteúdo',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400),
            ),
            actions: [
              CupertinoActionSheetAction(
                  child: Text('Sair sem salvar'),
                  onPressed: () async {
                    await controller.cleanData();
                    Navigator.of(context).pop();
                    Navigator.pop(ctxPage);
                  }),
              CupertinoActionSheetAction(
                  child: Text('Salvar e sair'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(ctxPage).pop();
                    // salvar();
                  }),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: const Text('Cancelar'),
              // isDefaultAction: true,
              onPressed: () {
                Navigator.pop(context);
              },
            )));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          sairSalvarModal(context);
          return true;
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                box.read('os') != null
                    ? 'OS ' + box.read<Os>('os')!.id!.toString()
                    : 'Sem tipo',
                style: Get.theme.appBarTheme.titleTextStyle,
              ),
              centerTitle: true,
              actions: [
                Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: IconButton(
                      icon: Icon(Icons.save_rounded),
                      color: Colors.green,
                      onPressed: () {
                        salvar();
                      },
                    )),
              ],
              leading: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    color: Get.theme.cardColor,
                    onPressed: () {
                      sairSalvarModal(context);
                      // Navigator.pop(context);

                      //
                    },
                  )),
            ),
            // floatingActionButton: FloatingActionButton.extended(
            //   label: Text('Salvar'),
            //   heroTag: 'btnSaveKit',
            //   key: GlobalKey(),
            //   icon: Icon(
            //     Icons.save,
            //     color: Colors.white,
            //   ),
            //   backgroundColor: Colors.green,
            //   onPressed: () {
            //     salvar();
            //   },
            // ),
            body: GetBuilder<DetailController>(
                global: true,
                autoRemove: false,
                init: controller,
                builder: (_) => Container(
                      padding: EdgeInsets.all(10),
                      child: ListView(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // TextDivider(
                            //   title: 'Assinatura',
                            // ),
                            // imageView(
                            //   context,
                            //   tipoImagem: Constants.TIPO_ASSINATURA,
                            // ),
                            TextDivider(
                              title: 'Assinatura digital',
                            ),
                            digitalSignature(
                                context, Constants.TIPO_ASSINATURA_DIGITAL),
                            TextDivider(
                              title: 'CPF',
                            ),
                            imageView(context, tipoImagem: Constants.TIPO_CPF),
                            TextDivider(
                              title: 'RG',
                            ),
                            imageView(
                              context,
                              tipoImagem: Constants.TIPO_RG,
                            ),
                            TextDivider(
                              title: 'Comprovante de Residência (Opcional)',
                            ),
                            imageView(
                              context,
                              tipoImagem: Constants.TIPO_COMP_RESIDENCIA,
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            TextFormField(
                              controller: _.nomeT1Controller,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  labelText: 'Nome e RG (Testemunha 1)',
                                  labelStyle: GoogleFonts.lato(
                                      color: Get.textTheme.bodyText2!.color)),
                              // onChanged: (String val) {
                              //   _.setNomeT1(val);
                              // },
                            ),
                            TextDivider(
                              title: 'Assinatura digital (Testemunha 1)',
                            ),
                            digitalSignature(
                                context, Constants.TIPO_ASSINATURA_DIGITAL_T1),
                            SizedBox(
                              height: 30,
                            ),
                            TextFormField(
                              controller: _.nomeT2Controller,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  labelText: 'Nome e RG (Testemunha 2)',
                                  labelStyle: GoogleFonts.lato(
                                      color: Get.textTheme.bodyText2!.color)),
                              // onChanged: (String val) {
                              //   _.setNomeT2(val);
                              // },
                            ),
                            TextDivider(
                              title: 'Assinatura digital (Testemunha 2)',
                            ),
                            digitalSignature(
                                context, Constants.TIPO_ASSINATURA_DIGITAL_T2),
                          ]),
                    ))));
  }

  Widget digitalSignature(BuildContext context, String typeSignature) {
    return Container(
        width: Get.size.width,
        margin: EdgeInsets.only(top: 10, bottom: 10),
        height: 120,
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
        child: FutureBuilder(
            future: fetchData(typeSignature),
            builder: (context, AsyncSnapshot<List<ImageModel>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              List<ImageModel> images = snapshot.data!;

              if (images.length == 0) {
                return Container(
                    width: Get.size.width,
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    height: 120,
                    child: TextButton(
                        onPressed: () => signature(
                            clear: true, typeSignature: typeSignature),
                        child: Center(
                            child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                              Icon(
                                Icons.text_format,
                                color: Colors.black87,
                              ),
                              Text(
                                " Assinar",
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w400),
                              )
                            ]))));
              }
              return GestureDetector(
                child: Container(
                    width: Get.size.width,
                    // margin: EdgeInsets.only(top: 10, bottom: 10),
                    decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(10)),
                    height: 120,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_circle,
                            ),
                            Text(
                              ' Assinado',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Clique para ver ou editar',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                        )
                      ],
                    )),
                onTap: () async {
                  previewImage(images[0], signature: true);
                },
              );
            }));
  }

  Widget imageView(BuildContext context, {tipoImagem}) {
    return Container(
        width: Get.size.width,
        height: 120,
        child: GetBuilder<DetailController>(
            global: true,
            autoRemove: false,
            init: controller,
            // initState: () { fetchData()},
            builder: (_) => FutureBuilder(
                future: fetchData(tipoImagem),
                builder: (context, AsyncSnapshot<List<ImageModel>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.connectionState == ConnectionState.none) {
                    return imageCapture(
                      context,
                      tipoImagem: tipoImagem,
                    );
                  }

                  List<ImageModel> images = snapshot.data!;
                  if (images.length == 0) {
                    return imageCapture(
                      context,
                      tipoImagem: tipoImagem,
                    );
                  }
                  return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      itemCount: images.length + 1,
                      itemBuilder: (context, idx) {
                        if (idx == 0) {
                          return GestureDetector(
                              onTap: () {
                                box.write('tipo_imagem', tipoImagem);
                                takePicture();
                              },
                              child: Container(
                                  width: 100,
                                  margin: EdgeInsets.only(
                                      right: 10, top: 10, bottom: 10),
                                  height: 100,
                                  decoration: BoxDecoration(
                                      color:
                                          Colors.green[100], //Colors.grey[300],
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Icon(Icons.add)));
                        }

                        return GestureDetector(
                            onTap: () {
                              box.write('tipo_imagem', tipoImagem);
                              previewImage(images[idx - 1]);
                            },
                            child: Container(
                                margin: EdgeInsets.only(
                                    right: 10, top: 10, bottom: 10),
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(10)),
                                child: Image.file(
                                  File(images[idx - 1].src!),
                                  fit: BoxFit.cover,
                                )));
                      });
                })));
  }

  Widget imageCapture(BuildContext context, {tipoImagem}) {
    return GestureDetector(
        onTap: () {
          box.write('tipo_imagem', tipoImagem);
          takePicture();
        },
        child: Container(
            width: Get.size.width,
            height: 70,
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10)),
            child: Center(
                child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [Icon(Icons.add), Text("Tirar foto")]))));
  }
}
