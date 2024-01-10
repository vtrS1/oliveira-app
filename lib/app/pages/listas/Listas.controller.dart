import 'package:get/get.dart';
import 'package:oliveira_fotos/App.routes.dart';
import 'package:oliveira_fotos/app/models/Os.model.dart';
import 'package:oliveira_fotos/app/pages/listas/Listas.provider.dart';
import 'package:oliveira_fotos/app/repository/Os.repository.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';

class ListaController extends GetxController {
  bool isLoading = false;
  bool isEmpty = false;
  bool isError = false;
  bool isCompleted = false;
  List<Os> servicosSearch = <Os>[];
  List<Os> servicos = <Os>[];
  List<Os> servicosFinalizados = <Os>[];
  List<Os> servicosSincronizados = <Os>[];
  static ListaController get to => Get.find();
  // RefreshController refreshController =
  //     RefreshController(initialRefresh: false);

  ListaController() {
    this.updateData();
  }
  Future searchOs(String query) async {
    servicosSearch = await OsRepository().search(query);
    print(servicosSearch.length);
    update();
  }

  Future<void> updateData() async {
    this.isLoading = true;
    update();
    try {
      List<Os> resp = await ListaProvider().fetchOs();

      if (resp.length == 0) {
        resp = await this.updateOfflineData();
      }
      if (resp.length == 0) {
        this.isEmpty = false;
      }
      this.isLoading = false;
      update();

      this.servicos = resp;
      this.isCompleted = true;
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      this.isError = true;
      this.isLoading = false;
      this.isCompleted = true;
    } finally {
      update();
    }
  }

  Future filterList() async {
    String listaStatus =
        box.read('listaStatus') != null ? box.read('listaStatus') : 'TODOS';
    List<Os> resp = await this.updateOfflineData();

    if (resp.length == 0) {
      this.isEmpty = false;
    } else if (listaStatus == 'AGUARDANDO') {
      resp = resp.where((element) => element.status == 0).toList();
    } else if (listaStatus == 'FINALIZADOS') {
      resp = resp
          .where((element) =>
              element.status == 1 || element.status == 4 || element.status == 3)
          .toList();
    } else if (listaStatus == 'ENVIADOS') {
      resp = resp.where((element) => element.status == 2).toList();
    } else {
      resp.sort((a, b) => a.status! - b.status!);
    }
    this.servicos = resp;
    update();
  }

  Future<List<Os>> updateOfflineData() async {
    return await OsRepository().getAll();
  }
}
