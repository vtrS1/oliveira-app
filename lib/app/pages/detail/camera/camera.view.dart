import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oliveira_fotos/app/models/Os.model.dart';
import 'package:oliveira_fotos/app/pages/detail/camera/camera.controller.dart';
import 'package:oliveira_fotos/app/utils/consts.dart';
import 'package:path/path.dart' as path;
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oliveira_fotos/app/models/Image.model.dart';
import 'package:oliveira_fotos/app/repository/Image.repository.dart';
import 'package:path_provider/path_provider.dart';

class CameraView extends StatefulWidget {
  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  File? myImage;
  var box = GetStorage();
  final picker = ImagePicker();

  Future saveLocalImage(PickedFile? pickedFile) async {
    if (pickedFile != null) {
      Directory? directory = await getExternalStorageDirectory();
      Os? os = box.read('os');
      String? tipoImagem = box.read('tipo_imagem');
      if (os != null) {
        File tmpFile = File(pickedFile.path);
        final String fileName = path.basename(pickedFile.path);
        tmpFile = await tmpFile.copy(
            '${directory!.path}/${os.id.toString()}-${tipoImagem ?? "IMG"}$fileName');
      }
    }
  }

  Future openCamera() async {
    PickedFile? pickedFile = await picker.getImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
        imageQuality: 70);

    await this.saveLocalImage(pickedFile);

    setState(() {
      if (pickedFile != null) {
        myImage = File(pickedFile.path);

// copy the file to a new path

      } else {
        print('No image selected.');
      }
    });
  }

  Future openGalley() async {
    var pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 70);

    await this.saveLocalImage(pickedFile);
    setState(() {
      if (pickedFile != null) {
        myImage = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  renameImage(File picture, String newName) {
    String dir = path.dirname(picture.path);
    String extensionImg = path.extension(picture.path);
    String newPath = path.join(dir, '$newName$extensionImg');
    print('NewPath: $newPath');
    picture.renameSync(newPath);
    return newPath;
  }

  Future<void> choiceImage() async {
    String defaultChoice = box.read('sourceMidia') ?? 'perguntar';
    if (defaultChoice == 'galeria') {
      Get.snackbar('Informação',
          'Você definiu que as imagens devem sempre vir da Galeria, caso não goste disse altere nas configurações',
          backgroundColor: Colors.orangeAccent,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
          margin: EdgeInsets.only(top: 10, left: 10, right: 10));
      openGalley();
    } else if (defaultChoice == 'camera') {
      Get.snackbar('Informação',
          'Você definiu que as imagens devem sempre vir da Câmera, caso não goste disse altere nas configurações',
          backgroundColor: Colors.orangeAccent,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
          margin: EdgeInsets.only(top: 10, left: 10, right: 10));
      openCamera();
    } else {
      return showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) => CupertinoActionSheet(
              title: Text(
                'Origem da imagem',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400),
              ),
              actions: [
                CupertinoActionSheetAction(
                    child: Text('Câmera'),
                    onPressed: () {
                      openCamera();
                      Navigator.of(context).pop();
                    }),
                CupertinoActionSheetAction(
                    child: Text('Galeria'),
                    onPressed: () {
                      openGalley();
                      Navigator.of(context).pop();
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
  }

  Future saveImage() async {
    ImageModel image = new ImageModel();
    Os? os = box.read('os');
    image.contrato = os!.fichasContrato;
    image.numero = os.fichasNumero;
    image.idFicha = os.fichasId!;
    image.idListaAluno = os.id;
    image.tipo = box.read('tipo');
    image.tipoImagem = box.read('tipo_imagem');
    String? cpf = box.read('cpf');
    List<ImageModel> imagesTipo = [];
    String tipo = os.tiposNome!;
    int tipoImagem = 1;
    switch (image.tipoImagem) {
      case Constants.TIPO_ASSINATURA:
        tipoImagem = 1;
        imagesTipo = await CameraController().fetchAssinaturas();
        break;
      case Constants.TIPO_RG:
        tipoImagem = 3;
        imagesTipo = await CameraController().fetchRG();
        break;
      case Constants.TIPO_CPF:
        tipoImagem = 2;
        imagesTipo = await CameraController().fetchCpf();
        break;
      case Constants.TIPO_COMP_RESIDENCIA:
        tipoImagem = 4;
        imagesTipo = await CameraController().fetchCompResidencia();
        break;
    }

    image.src = renameImage(myImage!,
        '$tipo-${image.contrato}-${image.numero}-$tipoImagem-${imagesTipo.length + 1}-$cpf');
    await ImageRepository().insert(image);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Adicionar ' + box.read('tipo_imagem').toString().toUpperCase(),
            style: TextStyle(fontFamily: 'Poppins', color: Colors.black87),
          ),
          centerTitle: true,
          backgroundColor: Color(0xFFF7F7F7),
          iconTheme: IconThemeData(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        body: Container(
          child: myImage == null
              ? Center(
                  child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/empty.png'),
                    Text(
                      "Nenhuma imagem selecionada",
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.black87,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400),
                    )
                  ],
                ))
              : Center(child: Image.file(myImage!)),
        ),
        floatingActionButton: myImage == null
            ? FloatingActionButton.extended(
                onPressed: () {
                  choiceImage();
                },
                key: new GlobalKey(),
                heroTag: 'btnSelectImage',
                label: Text(
                    myImage == null ? 'Escolher imagem' : 'Escolhar outra'),
                icon: Icon(Icons.add_a_photo),
                backgroundColor: myImage == null ? Colors.blue : Colors.orange,
              )
            : Stack(
                children: [
                  Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 30),
                        child: FloatingActionButton.extended(
                          onPressed: () {
                            choiceImage();
                          },
                          label: Text('Escolhar outra'),
                          key: new GlobalKey(),
                          heroTag: 'btnSelectOutherImage',
                          icon: Icon(Icons.add_a_photo),
                          backgroundColor: Colors.orange,
                        ),
                      )),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton.extended(
                      onPressed: () {
                        saveImage();
                      },
                      label: Text('Salvar'),
                      key: new GlobalKey(),
                      heroTag: 'btnSaveImage',
                      icon: Icon(Icons.save),
                      backgroundColor: Colors.green,
                    ),
                  )
                ],
              ));
  }
}
