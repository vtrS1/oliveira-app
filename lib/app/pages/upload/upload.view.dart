import 'package:flare_loading/flare_loading.dart';
import 'package:get/get.dart';
import 'package:oliveira_fotos/app/pages/upload/upload.controller.dart';
import 'package:flutter/material.dart';

class UploadView extends StatelessWidget {
  final UploadViewController controller =
      Get.put<UploadViewController>(UploadViewController());
  @override
  Widget build(BuildContext context) {
    Get.find<UploadViewController>().existOsToSend();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Envio de serviços',
          style: Get.theme.appBarTheme.titleTextStyle,
        ),
      ),
      body: GetBuilder<UploadViewController>(
          init: controller,
          builder: (_) {
            if (_.isFinished) {
              return Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: FlareLoading(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.width * 0.5,
                        name: 'assets/success.flr',
                        loopAnimation: 'play',
                        isLoading: false,
                        onSuccess: (_) {
                          print('Finished');
                        },
                        onError: (err, stack) {
                          print(err);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Text('Os serviços foram enviados',
                          textAlign: TextAlign.center,
                          style:
                              Get.textTheme.bodyText1!.copyWith(fontSize: 20)),
                    ),
                  ]);
            }
            if (_.isUploading) {
              return Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: FlareLoading(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.width * 0.5,
                      name: 'assets/uploading.flr',
                      loopAnimation: 'start',
                      isLoading: true,
                      onSuccess: (_) {
                        print('Finished');
                      },
                      onError: (err, stack) {
                        print(err);
                      },
                    ),
                  ),
                  enviandoImage(controller.imgAtual, controller.currentIndex,
                      controller.qtd)
                ],
              );
            }
            if (_.isError) {
              return erroNoEnvio();
            }
            if (_.qtd == 0) {
              return Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: FlareLoading(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.width * 0.5,
                        name: 'assets/empty_happy.flr',
                        loopAnimation: 'idle',
                        isLoading: true,
                        onSuccess: (_) {
                          print('Finished');
                        },
                        onError: (err, stack) {
                          print(err);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Text('Nenhum serviço aguardando o envio',
                          textAlign: TextAlign.center,
                          style:
                              Get.textTheme.bodyText1!.copyWith(fontSize: 20)),
                    )
                  ]);
            }

            return Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: FlareLoading(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.width * 0.5,
                    name: 'assets/empty_happy.flr',
                    loopAnimation: 'idle',
                    isLoading: true,
                    onSuccess: (_) {
                      print('Finished');
                    },
                    onError: (err, stack) {
                      print(err);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Text(
                      '${_.qtd} serviço(s)\n\n aguardando a sincronização',
                      textAlign: TextAlign.center,
                      style: Get.textTheme.bodyText1!.copyWith(fontSize: 20)),
                ),
                GestureDetector(
                  onTap: () async {
                    await _.fetchImages();
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 40),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.blue[500],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Enviar serviço(s)',
                            style: Get.textTheme.bodyText1!
                                .copyWith(fontSize: 18, color: Colors.white)),
                        Icon(Icons.upload, color: Colors.white, size: 30),
                      ],
                    ),
                  ),
                )
              ],
            );
          }),
    );
  }
}

Widget erroNoEnvio() {
  return Column(mainAxisSize: MainAxisSize.min, children: [
    Padding(
        padding: EdgeInsets.all(20), child: Image.asset('assets/cancel.png')),
    Text(
      "Ocorreu um erro no envio de uma ou mais imagens. Por favor, tente novamente mais tarde.",
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: 20,
          color: Colors.black87,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400),
    )
  ]);
}

Widget enviandoImage(String nomeImage, int os, int qtdOs) {
  return Column(mainAxisSize: MainAxisSize.min, children: [
    Text(
      "Aguarde, estamos enviando as OS's...",
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: 20,
          color: Colors.black87,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400),
    ),
    SizedBox(
      height: 20,
    ),
    Text(
      "Enviando a imagem ($nomeImage) da OS $os/$qtdOs",
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.black87, fontSize: 20),
    )
  ]);
}
