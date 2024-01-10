import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:oliveira_fotos/App.routes.dart';
import 'package:oliveira_fotos/app/pages/profile/Profile.provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class LoginView extends StatefulWidget {
  LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController controllerCpf = new TextEditingController();
  var box = GetStorage();
  var keyForm = new GlobalKey<FormState>();

  Future login() async {
    if (keyForm.currentState!.validate()) {
      try {
        EasyLoading.show(
          status: 'Verificando, aguarde...',
          dismissOnTap: false,
          maskType: EasyLoadingMaskType.black,
        );
        bool exist =
            await ProfileProvider().existUser(controllerCpf.value.text);
        EasyLoading.dismiss();
        if (exist) {
          await box.write('cpf', controllerCpf.value.text);
          if (box.read('hasShowIntro') == false ||
              box.read('hasShowIntro') == null ||
              1 == 1) {
            Get.offAndToNamed(INTRO_ROUTE);
          } else {
            Get.offAndToNamed(MAIN_ROUTE);
          }
        } else {
          Get.snackbar('Ops', 'Não encontramos nenhum cadastro com seu CPF',
              backgroundColor: Colors.redAccent[400],
              colorText: Colors.white,
              icon: Icon(Icons.error),
              barBlur: 3.0,
              isDismissible: true,
              duration: Duration(seconds: 5),
              shouldIconPulse: true,
              margin: EdgeInsets.only(top: 10, left: 10, right: 10));
        }
      } catch (e, stackTrace) {
        await Sentry.captureException(
          e,
          stackTrace: stackTrace,
        );
        print(e);
        // EasyLoading.dismiss();
        EasyLoading.showError(e.toString());
      }
    } else {
      Get.snackbar('Ops...', 'Digite um CPF válido',
          backgroundColor: Colors.redAccent[400],
          colorText: Colors.white,
          icon: Icon(Icons.error),
          barBlur: 3.0,
          isDismissible: true,
          duration: Duration(seconds: 5),
          shouldIconPulse: true,
          margin: EdgeInsets.only(top: 10, left: 10, right: 10));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Center(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.height / 2,
                      height: MediaQuery.of(context).size.height / 2,
                      child: Image.asset('assets/logo.png'))),
              Form(
                key: keyForm,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: TextFormField(
                    enabled: true,
                    controller: controllerCpf,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'CPF',
                      hintText: 'Digite os 11 dígitos do seu CPF',
                      hintStyle:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      labelStyle:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    validator: (value) {
                      if (!CPFValidator.isValid(value)) {
                        return 'Digite um CPF válido';
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) => login(),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ]),
              ),
              Container(
                height: 60,
                margin: const EdgeInsets.symmetric(vertical: 20.0),
                child: ElevatedButton(
                  onPressed: () => login(),
                  autofocus: true,
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Color(0xFF005ede)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ))),
                  child: Center(
                      child: Text(
                    'Entrar'.toUpperCase(),
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16),
                  )),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
