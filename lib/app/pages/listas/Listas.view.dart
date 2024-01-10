import 'package:flare_loading/flare_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:oliveira_fotos/app/models/Os.model.dart';
import 'package:oliveira_fotos/app/pages/listas/Listas.controller.dart';
import 'package:oliveira_fotos/app/pages/listas/widget/Card.list.dart';
import 'package:oliveira_fotos/app/pages/os/Os.view.dart';
import 'package:oliveira_fotos/app/pages/settings/ReservListBills.view.dart';
import 'package:oliveira_fotos/app/pages/settings/Settings.controller.dart';
import 'package:oliveira_fotos/app/utils/consts.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:oliveira_fotos/app/widgets/SelectListOsType.widget.dart';

bool hasUpdate = false;

class ListaView extends StatelessWidget {
  final box = GetStorage();

  final ListaController listaController =
      Get.put<ListaController>(ListaController());
  final SettingsController settingsController =
      Get.put<SettingsController>(SettingsController());

  ListaView() {
    this.hasUpdateApp();
  }

  hasUpdateApp() async {
    hasUpdate = await settingsController.verifyUpdate();
  }

  noHasUpdate() {
    hasUpdate = false;
    listaController.update();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          title: Text('Serviços', style: Get.theme.appBarTheme.titleTextStyle),
          automaticallyImplyLeading: false,
          iconTheme: IconThemeData(color: Colors.black87),
          leadingWidth: 200,
          leading: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text((box.read('cpf') ?? ''),
                    style: Get.theme.appBarTheme.titleTextStyle),
                Text('APP v${Constants.APP_VERSION}',
                    style: Get.theme.appBarTheme.titleTextStyle),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: IconButton(
                  tooltip: 'Reservar boletos da lista',
                  onPressed: () async {
                    showCupertinoModalBottomSheet(
                        expand: false,
                        enableDrag: true,
                        barrierColor: Colors.black.withOpacity(0.5),
                        bounce: true,
                        isDismissible: true,
                        context: context,
                        builder: (context) => ReservListBillsWidget());
                  },
                  icon: Icon(FeatherIcons.creditCard),
                  color: Get.theme.appBarTheme.iconTheme?.color),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: IconButton(
                  tooltip: 'Atualizar lista de Os',
                  onPressed: () async {
                    hasUpdate = await settingsController.verifyUpdate();
                    Get.find<ListaController>().updateData();
                  },
                  icon: Icon(
                    FeatherIcons.refreshCcw,
                  ),
                  color: Get.theme.appBarTheme.iconTheme?.color),
            ),
          ],
        ),
        body: Container(
          child: GetBuilder<ListaController>(
            init: listaController,
            builder: (controller) {
              if (controller.isLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (controller.servicos.length == 0) {
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: buildFloatingSearchBar(context),
                      height: 80,
                    ),
                    !hasUpdate
                        ? SizedBox()
                        : updateAppCard(context, noHasUpdate),
                    Center(
                      child: FlareLoading(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.width * 0.5,
                        name: 'assets/empty_state.flr',
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
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      "Nenhum serviço ${box.read("listaStatus") != null ? "com o status " + box.read("listaStatus") : ""} encontrado.\n\nTente mudar o filtro (",
                                ),
                                TextSpan(
                                    text: "Clique no botão ",
                                    style: Get.textTheme.bodyText1!.copyWith(
                                        fontSize: 16, color: Colors.blue)),
                                WidgetSpan(
                                  child: Icon(Icons.menu, size: 25),
                                ),
                                TextSpan(
                                  text:
                                      ") para ver se achamos algum.\n\nEm último caso atualize a lista de serviços (",
                                ),
                                TextSpan(
                                    text: "Clique no botão ",
                                    style: Get.textTheme.bodyText1!.copyWith(
                                        fontSize: 16, color: Colors.blue)),
                                WidgetSpan(
                                  child: Icon(Icons.refresh, size: 25),
                                ),
                                TextSpan(
                                  text: ")",
                                ),
                              ],
                              style: Get.textTheme.bodyText1!
                                  .copyWith(fontSize: 18)),
                        ))
                  ],
                );
              }

              return Stack(fit: StackFit.expand, children: [
                Padding(
                    padding: const EdgeInsets.only(
                      top: 70.0,
                    ),
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemCount:
                            controller.servicos.length + (hasUpdate ? 1 : 0),
                        itemBuilder: (_, index) {
                          if (hasUpdate && index == 0) {
                            return updateAppCard(context, noHasUpdate);
                          }
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: CardList(
                                os: controller
                                    .servicos[index - (hasUpdate ? 1 : 0)]),
                          );
                        })),
                buildFloatingSearchBar(context),
              ]);
            },
          ),
        ));
  }

  Widget buildFloatingSearchBar(BuildContext context) {
    final isPortrait = true;

    return FloatingSearchBar(
      hint: 'Pesquise...',
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 500),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      elevation: 3,
      openAxisAlignment: 0.0,
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      automaticallyImplyBackButton: false,
      width: Get.width * 0.93,
      debounceDelay: const Duration(milliseconds: 300),
      onQueryChanged: (query) {
        Get.find<ListaController>().searchOs(query);
      },
      // Specify a custom transition to be used for
      // animating between opened and closed stated.
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ),
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
        FloatingSearchBarAction.icon(
            icon: Icon(Icons.menu),
            onTap: () {
              showCupertinoModalBottomSheet(
                expand: false,
                enableDrag: true,
                barrierColor: Colors.black.withOpacity(0.5),
                bounce: true,
                isDismissible: true,
                context: context,
                builder: (context) => SelectListOsType(),
              );
            })
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Material(
              color: Get.theme.scaffoldBackgroundColor,
              elevation: 4.0,
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: Get.find<ListaController>().servicosSearch.length,
                  itemBuilder: (_, index) {
                    Os os = Get.find<ListaController>().servicosSearch[index];
                    return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          isThreeLine: true,
                          onTap: () async {
                            if (os.status! == 0) {
                              await box.write('os', os);
                              showCupertinoModalBottomSheet(
                                  expand: false,
                                  enableDrag: true,
                                  barrierColor: Colors.black.withOpacity(0.5),
                                  bounce: true,
                                  isDismissible: true,
                                  context: context,
                                  builder: (context) => OsView());
                            } else {
                              Get.snackbar('Ops', 'Você ja finalizou essa OS',
                                  backgroundColor: Colors.orangeAccent,
                                  colorText: Colors.white,
                                  duration: Duration(seconds: 3),
                                  margin: EdgeInsets.only(
                                      top: 10, left: 10, right: 10));
                            }
                          },
                          title: Text(
                            'OS: ${os.id.toString()} - Nº ${os.fichasNumero} - ${os.pessoasNome}',
                            style:
                                Get.textTheme.bodyText1!.copyWith(fontSize: 16),
                          ),
                          subtitle: Text(
                            '${os.fullAddress()}',
                            style: Get.textTheme.bodyText1!.copyWith(
                                color: Get.textTheme.bodyText1!.color!
                                    .withOpacity(0.7)),
                          ),
                        ));
                  })),
        );
      },
    );
  }
}

ScrollView listaOs(List<Os> listOs) {
  return ListView.builder(
    physics: BouncingScrollPhysics(),
    itemCount: listOs.length,
    shrinkWrap: true,
    scrollDirection: Axis.vertical,
    itemBuilder: (context, index) => CardList(os: listOs[index]),
  );
}

Widget updateAppCard(BuildContext context, Function noHasUpdate) {
  return GestureDetector(
      onTap: () async {
        await Get.find<SettingsController>().updateApp();
        noHasUpdate();
      },
      child: Container(
        margin: EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10),
        width: Get.width,
        child: Card(
          color: Colors.green[400],
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.android, color: Colors.white, size: 50),
                Text(
                  'Atualização do APP disponível!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                Text(
                  'CLIQUE AQUI PARA ATUALIZAR',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey[100]),
                )
              ],
            ),
          ),
        ),
      ));
}
