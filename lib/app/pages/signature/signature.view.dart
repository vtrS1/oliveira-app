import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hand_signature/signature.dart';
import 'package:oliveira_fotos/app/models/Image.model.dart';
import 'package:oliveira_fotos/app/models/Os.model.dart';
import 'package:oliveira_fotos/app/repository/Image.repository.dart';
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

class SignatureView extends StatefulWidget {
  final String typeSingature;

  SignatureView({Key? key, required this.typeSingature}) : super(key: key);

  @override
  _SignatureViewState createState() => _SignatureViewState();
}

class _SignatureViewState extends State<SignatureView> {
  ImageModel image = new ImageModel();
  var box = GetStorage();

  String? cpf = '';
  String tipo = 'alb';
  String title = 'Assinatura';

  ScrollController _singtureScroll = ScrollController();

  bool isScrollEnd = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    Os? os = box.read('os');
    image.contrato = os!.fichasContrato;
    image.numero = os.fichasNumero;
    image.idFicha = os.fichasId!;
    image.idListaAluno = os.id;
    image.tipo = box.read('tipo');
    image.tipoImagem = widget.typeSingature;
    cpf = box.read('cpf');
    tipo = os.tiposNome!;
    if (widget.typeSingature == Constants.TIPO_ASSINATURA_DIGITAL) {
      title = 'Assinatura do Sacado';
    }
    if (widget.typeSingature == Constants.TIPO_ASSINATURA_DIGITAL_T1) {
      title = 'Assinatura da Testemunha 1';
    }
    if (widget.typeSingature == Constants.TIPO_ASSINATURA_DIGITAL_T2) {
      title = 'Assinatura da Testemunha 2';
    }
    control.clear();
    isScrollEnd = false;
  }

  init() async {
    print('Loading');
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    print(path);
    return File(
        '$path/$tipo-${image.contrato}-${image.numero}-${image.tipoImagem}-$cpf.png');
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
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
        backgroundColor: Color(0xFFF7F7F7),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black87),
        title: Text(title,
            style: TextStyle(fontFamily: 'Poppins', color: Colors.black87)),
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
                    image.src = signature.path;
                    await ImageRepository()
                        .deleteByContratoNumeroTipoTipoImagem(image.contrato,
                            image.numero, image.tipo, image.tipoImagem!);
                    await ImageRepository().insert(image);
                    Navigator.pop(context);
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
