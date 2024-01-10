import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:oliveira_fotos/app/pages/settings/Settings.controller.dart';
import 'package:oliveira_fotos/app/provider/Db.provider.dart';
import 'package:oliveira_fotos/app/utils/consts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
// ignore: implementation_imports
import 'package:dio/src/response.dart' as DResp;
import 'package:sentry_flutter/sentry_flutter.dart';

// ignore: must_be_immutable
class ClearDatabase extends StatefulWidget {
  final BuildContext cttxSettings;

  ClearDatabase({required this.cttxSettings});

  @override
  _ClearDatabaseState createState() => _ClearDatabaseState();
}

class _ClearDatabaseState extends State<ClearDatabase> {
  SettingsController controller = Get.find<SettingsController>();
  var onTapRecognizer;

  TextEditingController textEditingController = TextEditingController();

  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String currentText = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  Future validateOTP() async {
    try {
      EasyLoading.show(
        status: "Validando o código...",
        dismissOnTap: false,
        maskType: EasyLoadingMaskType.black,
      );
      DResp.Response res =
          await Dio().get(Constants.API_HOST + "external/resetkey");
      EasyLoading.dismiss();
      if (res.statusCode == 200) {
        if (res.data['valor'] == null) {
          throw Exception("Não foi possível recuperar a chave de reset");
        }
        String code = res.data['valor'];

        if (currentText == code) {
          EasyLoading.show(
            status: "Resetando banco de dados...",
            dismissOnTap: false,
            maskType: EasyLoadingMaskType.black,
          );
          await DBProvider.db.clearTables();

          Get.snackbar('Sucesso', 'A base de dados foi resetada',
              backgroundColor: Colors.green,
              colorText: Colors.white,
              duration: Duration(seconds: 3),
              margin: EdgeInsets.only(top: 10, left: 10, right: 10));
          await Future.delayed(Duration(seconds: 3));
        } else {
          Get.snackbar('Ops', '1RDB - Código incorreto',
              backgroundColor: Colors.red,
              colorText: Colors.white,
              duration: Duration(seconds: 3),
              margin: EdgeInsets.only(top: 10, left: 10, right: 10));
        }
      } else {
        Get.snackbar(
            'Ops', '2RDB - Ocorreu um erro, tente novamente mais tarde',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: Duration(seconds: 3),
            margin: EdgeInsets.only(top: 10, left: 10, right: 10));
      }
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      print(e);
      Get.snackbar('Ops', '3RDB - Ocorreu um erro, tente novamente mais tarde',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
          margin: EdgeInsets.only(top: 10, left: 10, right: 10));
    } finally {
      EasyLoading.dismiss();
    }
  }

  @override
  void initState() {
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.pop(context);
      };
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController?.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Limpar base dados do APP',
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
      body: GestureDetector(
        onTap: () {},
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: <Widget>[
              SizedBox(height: 30),
              // Container(
              //   height: MediaQuery.of(context).size.height / 3,
              //   child: FlareActor(
              //     "assets/otp.flr",
              //     animation: "otp",
              //     fit: BoxFit.fitHeight,
              //     alignment: Alignment.center,
              //   ),
              // ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Confirmação de segurança',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                child: Text(
                  "Digite o código para continuar",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54, fontSize: 15),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Form(
                key: formKey,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 30),
                    child: PinCodeTextField(
                      appContext: context,
                      pastedTextStyle: TextStyle(
                        color: Colors.green.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                      length: 6,
                      obscureText: false,
                      obscuringCharacter: '*',
                      animationType: AnimationType.fade,
                      validator: (v) {
                        if (v!.length < 3) {
                          return "";
                        } else {
                          return null;
                        }
                      },
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 60,
                        fieldWidth: 50,
                        activeFillColor:
                            hasError ? Colors.orange : Colors.white,
                      ),
                      cursorColor: Colors.black,
                      animationDuration: Duration(milliseconds: 300),
                      textStyle: TextStyle(fontSize: 20, height: 1.6),
                      backgroundColor: Colors.blue.shade50,
                      enableActiveFill: true,
                      errorAnimationController: errorController,
                      controller: textEditingController,
                      keyboardType: TextInputType.number,
                      boxShadows: [
                        BoxShadow(
                          offset: Offset(0, 1),
                          color: Colors.black12,
                          blurRadius: 10,
                        )
                      ],
                      onCompleted: (v) {
                        this.validateOTP();
                      },
                      // onTap: () {
                      //   print("Pressed");
                      // },
                      onChanged: (value) {
                        print(value);
                        setState(() {
                          currentText = value;
                        });
                      },
                      beforeTextPaste: (text) {
                        print("Allowing to paste $text");
                        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                        //but you can show anything you want here, like your pop up saying wrong paste format or etc
                        return true;
                      },
                    )),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  hasError ? "*Por favor complete o código" : "",
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(
                height: 20,
              ),

              SizedBox(
                height: 14,
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
                child: ButtonTheme(
                  height: 50,
                  // ignore: deprecated_member_use
                  child: FlatButton(
                    onPressed: () {
                      formKey.currentState?.validate();
                      // conditions for validating
                      if (currentText.length != 6) {
                        errorController?.add(ErrorAnimationType
                            .shake); // Triggering error shake animation
                        setState(() {
                          hasError = true;
                        });
                      } else {
                        setState(() {
                          hasError = false;
                        });
                        this.validateOTP();
                      }
                    },
                    child: Center(
                        child: Text(
                      "Limpar base de dados".toUpperCase(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                ),
                decoration: BoxDecoration(
                    color: Colors.green.shade300,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.green.shade200,
                          offset: Offset(1, -2),
                          blurRadius: 5),
                      BoxShadow(
                          color: Colors.green.shade200,
                          offset: Offset(-1, 2),
                          blurRadius: 5)
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
