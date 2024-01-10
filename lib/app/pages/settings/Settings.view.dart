import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:oliveira_fotos/app/pages/settings/ClearDatabase.view.dart';
// import 'package:oliveira_fotos/app/pages/settings/Negativados.provider.dart';
import 'package:oliveira_fotos/app/pages/settings/Settings.controller.dart';
import 'package:oliveira_fotos/app/utils/consts.dart';
import 'package:oliveira_fotos/app/widgets/CleanServices.widget.dart';
import 'package:oliveira_fotos/app/widgets/ConsultarSituacaoCPF.widget.dart';
import 'package:oliveira_fotos/app/widgets/RemoveAccount.widget.dart';
import 'package:oliveira_fotos/app/widgets/SelectSourceImg.widget.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:url_launcher/url_launcher.dart';
import '../../../App.routes.dart';

class SettingsView extends StatelessWidget {
  final SettingsController controller =
      Get.put<SettingsController>(SettingsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Ajustes',
              style: Get.theme.appBarTheme.titleTextStyle!
                  .copyWith(fontSize: 18, fontWeight: FontWeight.w700)),
          automaticallyImplyLeading: false,
          iconTheme: IconThemeData(color: Colors.black87),
        ),
        body: Obx(
          () => SettingsList(
            sections: [
              // SettingsSection(
              //     title: 'Aparência',
              //     titleTextStyle: TextStyle(
              //       fontFamily: 'Poppins',
              //       fontSize: 16,
              //     ),
              //     // subtitle: Text('Personalize a aparência do APP'),
              //     tiles: [
              //       SettingsTile.switchTile(
              //         title: 'Modo noturno',
              //         leading: Icon(Icons.dark_mode),
              //         switchValue: ThemeService().theme == ThemeMode.light
              //             ? false
              //             : true,
              //         onToggle: (bool value) {
              //           ThemeService().switchTheme();
              //         },
              //       ),
              //     ]),
              SettingsSection(
                  // titlePadding: EdgeInsets.only(top: 30, left: 15),
                  // margin: EdgeInsets.only(top: 30, left: 15),
                  title: Text('Preferências',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                      )),
                  tiles: [
                    SettingsTile(
                      title: Text('Localização padrão das imagens'),
                      leading: Icon(FeatherIcons.image),
                      description:
                          Text(Get.find<SettingsController>().getSourceMidia),
                      onPressed: (a) {
                        showCupertinoModalBottomSheet(
                            expand: false,
                            barrierColor: Colors.black.withOpacity(0.5),
                            enableDrag: true,
                            bounce: true,
                            isDismissible: true,
                            context: context,
                            builder: (context) => SelectSourceMidiaWidget());
                      },
                    ),
                  ]),
              SettingsSection(
                title: Text('Limpeza',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                    )),
                // titlePadding: EdgeInsets.only(top: 30, left: 15),

                tiles: [
                  SettingsTile(
                    title: Text('Limpar Os`s executadas'),
                    leading: Icon(FeatherIcons.package),
                    onPressed: (a) {
                      showCupertinoModalBottomSheet(
                          expand: false,
                          enableDrag: true,
                          barrierColor: Colors.black.withOpacity(0.5),
                          bounce: true,
                          isDismissible: true,
                          context: context,
                          builder: (context) => CleanServicesWidget());
                    },
                  ),
                  SettingsTile(
                    title: Text('Limpar cache do APP'),
                    leading: Icon(FeatherIcons.cpu),
                    onPressed: (a) async {
                      await controller.clearMemoryCache();
                    },
                  ),
                  SettingsTile(
                    title: Text('Limpar base de dados'),
                    leading: Icon(FeatherIcons.hardDrive),
                    onPressed: (a) async {
                      showCupertinoModalBottomSheet(
                          expand: false,
                          enableDrag: true,
                          barrierColor: Colors.black.withOpacity(0.5),
                          bounce: true,
                          isDismissible: true,
                          context: context,
                          builder: (context) =>
                              ClearDatabase(cttxSettings: context));
                    },
                  ),
                ],
              ),
              SettingsSection(
                  // titlePadding: EdgeInsets.only(top: 30, left: 15),
                  title: Text('Atualizações',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                      )),
                  tiles: [
                    SettingsTile(
                      title: Text('Atualizar dados básicos'),
                      leading: Icon(FeatherIcons.creditCard),
                      description: Text('Ultima atualização em ' +
                          Get.find<SettingsController>()
                              .getLastUpdateFormaPagamento),
                      onPressed: (c) async {
                        await Get.find<SettingsController>()
                            .updateFormaPagamento();
                      },
                    ),
                    // SettingsTile(
                    //   title: 'Atualizar dados dos inadimplentes',
                    //   leading: Icon(FeatherIcons.users),
                    //   subtitle: 'Ultima atualização em 20/07/2021',
                    //   onPressed: (c) async {
                    //     await Get.find<SettingsController>()
                    //         .updateInadimplentes();
                    //   },
                    // ),
                    SettingsTile(
                      title: Text('Ver novidades dessa versão'),
                      leading: Icon(FeatherIcons.bell),
                      description: Text(
                          'Saiba o que mudou e aprenda a usar as novidades'),
                      onPressed: (c) async {
                        Get.toNamed(INTRO_ROUTE);
                      },
                    ),
                    SettingsTile(
                      title: Text('Atualizar aplicativo'),
                      leading: Icon(FeatherIcons.smartphone),
                      description:
                          Text('Versão atual: ' + Constants.APP_VERSION),
                      onPressed: (c) async {
                        await Get.find<SettingsController>().updateApp();
                      },
                    ),
                  ]),
              SettingsSection(
                  // titlePadding: EdgeInsets.only(top: 30, left: 15),
                  title: Text('Boleto',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                      )),
                  tiles: [
                    SettingsTile(
                      title: Text('Aprenda a configurar o gerador de boletos'),
                      description: Text('Vídeo mostrando como configurar'),
                      leading: Icon(FeatherIcons.video),
                      onPressed: (a) async {
                        try {
                          if (await canLaunch('https://youtu.be/wxanB_GjpNI')) {
                            await launch('https://youtu.be/wxanB_GjpNI');
                          } else {
                            throw 'Não foi possível acessar o vídeo de ajuda';
                          }
                        } catch (e) {
                          Get.snackbar('Ops',
                              'Não foi possível acessar o vídeo de ajuda (${e.toString()})',
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                              duration: Duration(seconds: 3),
                              margin: EdgeInsets.only(
                                  top: 10, left: 10, right: 10));
                        }
                      },
                    ),
                    SettingsTile(
                        title: Text('Baixar gerador de boletos'),
                        description:
                            Text('Necessário para gerar boletos sem internet'),
                        leading: Icon(FeatherIcons.filePlus),
                        onPressed: (a) async {
                          try {
                            if (await canLaunch(Constants.APP_BOLETO_RENDER)) {
                              await launch(Constants.APP_BOLETO_RENDER);
                            } else {
                              throw 'Não foi possível baixar o gerador de boletos';
                            }
                          } catch (e) {
                            Get.snackbar('Ops',
                                'Erro ao instalar o gerador de boletos (${e.toString()})',
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                                duration: Duration(seconds: 3),
                                margin: EdgeInsets.only(
                                    top: 10, left: 10, right: 10));
                          }
                        }),
                    SettingsTile(
                        title: Text('Instalar serviço de boletos offline'),
                        description:
                            Text('Necessário para gerar boletos sem internet'),
                        leading: Icon(FeatherIcons.server),
                        onPressed: (a) async {
                          try {
                            if (await canLaunch(Constants.APP_SERVER_URL)) {
                              await launch(Constants.APP_SERVER_URL);
                            } else {
                              throw 'Não foi possível abrir o serviço de boletos offline';
                            }
                          } catch (e) {
                            Get.snackbar('Ops',
                                'Erro ao instalar servidor (${e.toString()})',
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                                duration: Duration(seconds: 3),
                                margin: EdgeInsets.only(
                                    top: 10, left: 10, right: 10));
                          }
                        }),
                  ]),
              SettingsSection(
                  // titlePadding: EdgeInsets.only(top: 30, left: 15),
                  title: Text('Outros',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                      )),
                  tiles: [
                    SettingsTile(
                      title: Text('Exportar base de dados'),
                      leading: Icon(FeatherIcons.database),
                      onPressed: (a) async {
                        await Get.find<SettingsController>().exportDatabase();
                      },
                    ),
                    SettingsTile(
                      title: Text('Ajuda com o sistema'),
                      description: Text('Veja vídeos de como usar o sistema'),
                      leading: Icon(FeatherIcons.youtube),
                      onPressed: (a) async {
                        try {
                          if (await canLaunch(Constants.APP_PLAYLIST_HELP)) {
                            await launch(Constants.APP_PLAYLIST_HELP);
                          } else {
                            throw 'Não foi possível acessar os vídeos de ajuda';
                          }
                        } catch (e) {
                          Get.snackbar('Ops',
                              'Não foi possível acessar os vídeos de ajuda (${e.toString()})',
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                              duration: Duration(seconds: 3),
                              margin: EdgeInsets.only(
                                  top: 10, left: 10, right: 10));
                        }
                      },
                    ),
                    // SettingsTile(
                    //   title: 'Logs do APP',
                    //   leading: Icon(Icons.bug_report),
                    //   onPressed: (a) async {
                    //     showCupertinoModalBottomSheet(
                    //         expand: false,
                    //         enableDrag: true,
                    //         bounce: true,
                    //         isDismissible: true,
                    //         context: context,
                    //         builder: (context) => LogsView());
                    //   },
                    // ),
                    // SettingsTile(
                    //   title: 'Instalar serviço de boletos offline',
                    //   subtitle: 'Necessário para gerar boletos sem internet',
                    //   leading: Icon(FeatherIcons.server),
                    //   onPressed: (a) async {
                    //     try {
                    //       if (await canLaunch(Constants.APP_SERVER_URL)) {
                    //         await launch(Constants.APP_SERVER_URL);
                    //       } else {
                    //         throw 'Não foi possível abrir o serviço de boletos offline';
                    //       }
                    //     } catch (e, stackTrace) {
                    // await Sentry.captureException(
                    //   e,
                    //   stackTrace: stackTrace,
                    // );
                    //       Get.snackbar('Ops',
                    //           'Erro ao instalar servidor (${e.toString()})',
                    //           backgroundColor: Colors.red,
                    //           colorText: Colors.white,
                    //           duration: Duration(seconds: 3),
                    //           margin: EdgeInsets.only(
                    //               top: 10, left: 10, right: 10));
                    //     }
                    //   },

                    SettingsTile(
                      title: Text('Consultar situação do CPF'),
                      leading: Icon(FeatherIcons.shieldOff),
                      onPressed: (a) async {
                        showCupertinoModalBottomSheet(
                            expand: false,
                            enableDrag: true,
                            barrierColor: Colors.black.withOpacity(0.5),
                            bounce: true,
                            isDismissible: true,
                            context: context,
                            builder: (context) => ConsultarSituacaoCPFWidget());
                      },
                    ),
                    SettingsTile(
                      title: Text('Remover conta do APP'),
                      leading: Icon(FeatherIcons.logOut),
                      onPressed: (a) async {
                        showCupertinoModalBottomSheet(
                            expand: false,
                            enableDrag: true,
                            barrierColor: Colors.black.withOpacity(0.5),
                            bounce: true,
                            isDismissible: true,
                            context: context,
                            builder: (context) => RemoveAccount());
                      },
                    ),
                    SettingsTile(
                      title: Text(''),
                      description: Text(''),
                    ),
                    SettingsTile(
                      title: Text(''),
                      description: Text(''),
                    ),
                  ]),
            ],
          ),
        ));
  }
}
