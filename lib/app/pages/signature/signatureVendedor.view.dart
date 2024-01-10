import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hand_signature/signature.dart';
import 'package:oliveira_fotos/app/models/Image.model.dart';
import 'package:oliveira_fotos/app/provider/Connection.provider.dart';
import 'package:oliveira_fotos/app/utils/consts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

HandSignatureControl control = new HandSignatureControl(
  threshold: 1.0,
  smoothRatio: 0.65,
  velocityRange: 2.0,
);

ValueNotifier<String?> svg = ValueNotifier<String?>(null);

ValueNotifier<ByteData?> rawImage = ValueNotifier<ByteData?>(null);

class SignatureVendedorView extends StatefulWidget {
  SignatureVendedorView({Key? key}) : super(key: key);

  @override
  _SignatureVendedorViewState createState() => _SignatureVendedorViewState();
}

class _SignatureVendedorViewState extends State<SignatureVendedorView> {
  ImageModel image = new ImageModel();
  var box = GetStorage();

  String? cpf = '';
  String tipo = 'alb';

  ScrollController _singtureScroll = ScrollController();
  Connection connection = new Connection();

  bool isScrollEnd = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    isScrollEnd = false;
  }

  init() async {
    print('Loading');
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    print(path);
    return File('$path/ASSINATURA-VENDEDOR.png');
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future uploadSignature(String path) async {
    List<int> imageBytes = File(path).readAsBytesSync();
    String base64Image = base64Encode(imageBytes);

    Map form = Map();
    form['img'] = base64Image;
    form['cpf'] = box.read('cpf');

    try {
      EasyLoading.show(
        status: 'Enviando assinatura, aguarde',
        dismissOnTap: false,
        maskType: EasyLoadingMaskType.black,
      );
      var res = await connection.postWithOutToken('assinatura.php', form);
      if (res.data['status']) {
        form['img'] = '';
        form['url'] = res.data['url'];

        await connection.postSimple(
            Constants.API_HOST + 'external/vendedor/imagem/assinatura', form);
        Navigator.pop(context);
        Get.snackbar(
            'Atualizado', 'A sua assinatura digital foi atualizado com sucesso',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: Duration(seconds: 3),
            margin: EdgeInsets.only(top: 10, left: 10, right: 10));
      } else {
        Get.snackbar('Aviso',
            'Ocorreu um erro no envio de uma das imagens, estamos tentando novamente...');
        return null;
      }
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      print(e);
      return null;
    } finally {
      EasyLoading.dismiss();
    }
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: Get.theme.appBarTheme.iconTheme!,
        title: Text('Assinatura do vendedor',
            style: Get.theme.appBarTheme.titleTextStyle),
        actions: [
          IconButton(
              onPressed: () {
                control.clear();
              },
              icon: Icon(Icons.clear)),
          IconButton(
              onPressed: () async {
                try {
                  ByteData? png = await control.toImage();
                  if (png != null) {
                    File signature = await _localFile;
                    await signature.writeAsBytes(png.buffer.asUint8List());
                    await box.write('assinaturaVendedor', signature.path);
                    await uploadSignature(signature.path);
                  } else {
                    Get.snackbar(
                        'Aviso', 'A assinatura não pode ficar em branco');
                  }
                } catch (e, stackTrace) {
                  await Sentry.captureException(
                    e,
                    stackTrace: stackTrace,
                  );
                  Get.snackbar(
                      'Aviso', 'A assinatura não pode ficar em branco');
                }
              },
              icon: Icon(Icons.check)),
        ],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        child: Icon(
            isScrollEnd ? Icons.arrow_back_sharp : Icons.arrow_forward_sharp),
        onPressed: () {
          if (isScrollEnd) {
            _singtureScroll.animateTo(_singtureScroll.position.minScrollExtent,
                duration: Duration(milliseconds: 500), curve: Curves.ease);
          } else {
            _singtureScroll.animateTo(_singtureScroll.position.maxScrollExtent,
                duration: Duration(milliseconds: 500), curve: Curves.ease);
          }

          setState(() {
            isScrollEnd = !isScrollEnd;
          });
        },
      ),
      body: SingleChildScrollView(
          controller: _singtureScroll,
          scrollDirection: Axis.horizontal,
          physics: NeverScrollableScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width * 1.75,
            child: HandSignaturePainterView(
              control: control,
              width: 2.0,
              maxWidth: 3.0,
              type: SignatureDrawType.shape,
            ),
          )),
    );
  }
}
