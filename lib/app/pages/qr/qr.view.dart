// import 'dart:async';
// import 'package:adonis_websok_null_safety/io.dart';
// import 'package:barcode_scan2/barcode_scan2.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:oliveira_fotos/app/models/Os.model.dart';
// import 'package:oliveira_fotos/app/utils/consts.dart';
// import 'package:sentry_flutter/sentry_flutter.dart';

// class QRViewPage extends StatefulWidget {
//   @override
//   _QRViewPageState createState() => new _QRViewPageState();
// }

// class _QRViewPageState extends State<QRViewPage> {
//   ScanResult barcode = new ScanResult();
//   String status = '';
//   GetStorage box = GetStorage();
//   late IOAdonisWebsok socket;
//   var disponible;

//   Future initServer() async {
//     this.socket = IOAdonisWebsok(host: Constants.WS_HOST, port: -1, tls: true);
//     await this.socket.connect();
//     this.disponible = await this.socket.subscribe('boletoCode');
//     this
//         .disponible
//         .on('message', (data) => print('message: ${data.toString()}'));
//   }

//   @override
//   initState() {
//     super.initState();
//     // scan();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: new AppBar(
//         centerTitle: true,
//         title:
//             new Text('Boletos QR', style: Get.theme.appBarTheme.titleTextStyle),
//         iconTheme: IconThemeData(color: Colors.black87),
//       ),
//       body: Container(
//         width: MediaQuery.of(context).size.width,
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             SizedBox(height: 24),
//             Text(
//               'Acesso o sistema web pelo computador e navegue até',
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 20),
//             ),
//             SizedBox(height: 20),
//             Text('Financeiro > Boletos QR',
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
//             SizedBox(height: 20),
//             Text(
//               'e siga as instruções exibidas na tela',
//               style: TextStyle(fontSize: 20),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 20),
//             Container(
//               height: 60,
//               width: MediaQuery.of(context).size.width,
//               child: ElevatedButton(
//                   style: ButtonStyle(
//                     backgroundColor:
//                         MaterialStateProperty.all<Color>(Colors.blue),
//                   ),
//                   onPressed: scan,
//                   child: const Text('Escanear QR Code',
//                       style: TextStyle(
//                           fontSize: 20, fontWeight: FontWeight.w500))),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   Future scan() async {
//     try {
//       ScanResult barcode = await BarcodeScanner.scan(
//           options: ScanOptions(
//               strings: {
//             'cancel': 'Cancelar',
//             'flash_on': 'Ligar Flash',
//             'flash_off': 'Desligar Flash'
//           },
//               android: AndroidOptions(
//                 useAutoFocus: true,
//               )));
//       print(barcode);
//       setState(() {
//         this.barcode = barcode;
//       });

//       if (this.barcode.rawContent.length > 1) {
//         sendMessage();
//         Get.snackbar('Código lido com sucesso',
//             'Foi enviada uma solicitação de liberação da página. Caso a liberação não ocorra recarregue a página web e tente novamente.',
//             backgroundColor: Colors.black54,
//             colorText: Colors.white,
//             duration: Duration(seconds: 5),
//             margin: EdgeInsets.only(top: 10, left: 10, right: 10));
//       } else {
//         Get.snackbar('Nenhum código ligo',
//             'Caso a liberação não ocorra recarregue a página web e tente novamente.',
//             backgroundColor: Colors.black54,
//             colorText: Colors.white,
//             duration: Duration(seconds: 5),
//             margin: EdgeInsets.only(top: 10, left: 10, right: 10));
//       }
//     } on PlatformException catch (e) {
//       if (e.code == BarcodeScanner.cameraAccessDenied) {
//         Get.snackbar('Aviso de erro',
//             'O aplicativo está sem permissões de acesso a câmera, permita e tente novamente.  Cod. E004',
//             backgroundColor: Colors.black54,
//             colorText: Colors.white,
//             duration: Duration(seconds: 5),
//             margin: EdgeInsets.only(top: 10, left: 10, right: 10));
//       } else {
//         Get.snackbar('Aviso de erro',
//             'Ocorreum um erro desconhecido, tente novamente mais tarde. Cod. E003',
//             backgroundColor: Colors.black54,
//             colorText: Colors.white,
//             duration: Duration(seconds: 5),
//             margin: EdgeInsets.only(top: 10, left: 10, right: 10));
//       }
//     } on FormatException {
//       Get.snackbar('Aviso de erro',
//           'O usuário retornou antes que a verificação terminasse. Cod. E002',
//           backgroundColor: Colors.black54,
//           colorText: Colors.white,
//           duration: Duration(seconds: 5),
//           margin: EdgeInsets.only(top: 10, left: 10, right: 10));
//     } catch (e, stackTrace) {
//       await Sentry.captureException(
//         e,
//         stackTrace: stackTrace,
//       );
//       Get.snackbar('Aviso de erro',
//           'Ocorreum um erro desconhecido, tente novamente mais tarde. Cod. E001',
//           backgroundColor: Colors.black54,
//           colorText: Colors.white,
//           duration: Duration(seconds: 5),
//           margin: EdgeInsets.only(top: 10, left: 10, right: 10));
//     }
//   }

//   void sendMessage() async {
//     // EasyLoading.show(status: 'Liberando página...');
//     try {
//       print(this.barcode.rawContent);
//       await initServer();
//       await this.disponible.emit('message', {
//         'code': barcode.rawContent,
//         'action': 'ALLOW',
//         'os': GetStorage().read<Os>('os')!.id
//       });
//     } catch (e, stackTrace) {
//       await Sentry.captureException(
//         e,
//         stackTrace: stackTrace,
//       );
//       print(e);
//       Get.snackbar('Aviso de erro', e.toString(),
//           backgroundColor: Colors.black54,
//           colorText: Colors.white,
//           duration: Duration(seconds: 5),
//           margin: EdgeInsets.only(top: 10, left: 10, right: 10));
//     } finally {
//       // EasyLoading.dismiss();
//     }
//   }

//   @override
//   void dispose() {
//     if (this.disponible != null) {
//       this.disponible.close();
//     }
//     super.dispose();
//   }
// }
