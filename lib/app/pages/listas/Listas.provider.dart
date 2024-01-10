import 'package:get/get_connect/connect.dart';
import 'package:get_storage/get_storage.dart';
import 'package:oliveira_fotos/app/models/Os.model.dart';
import 'package:oliveira_fotos/app/models/contato.model.dart';
import 'package:oliveira_fotos/app/repository/Contato.repository.dart';
import 'package:oliveira_fotos/app/repository/Os.repository.dart';
import 'package:oliveira_fotos/app/utils/consts.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class ListaProvider extends GetConnect {
  GetStorage box = new GetStorage();
  ListaProvider() {
    httpClient.baseUrl = Constants.API_HOST;
    httpClient.timeout = Duration(seconds: 45);
  }

  Future<List<Os>> fetchOs() async {
    Response res;
    try {
      res = await get('external/listas/vendedor/' + box.read('cpf').toString());
      print(res);
      if (res.hasError) {
        await Sentry.captureException(
          res.bodyString,
          stackTrace: res.status,
        );
        List<Os> listOs = await OsRepository().getAll();
        if (listOs.length != 0) {
          return listOs;
        }
        if (res.status.isNotFound) {
          return Future.error(res.statusCode!);
        } else {
          return Future.error(res.body);
        }
      } else {
        List<Os> listOs = await OsRepository().getAll();
        try {
          // Remove os serviços não executados
          List<Os> servicosNaoExecutados = await OsRepository().getByStatus(0);
          for (Os service in servicosNaoExecutados) {
            await ContatoRepository().deleteAllByOs(service.id!);
            await OsRepository().delete(service.id);
          }
        } catch (e, stackTrace) {
          await Sentry.captureException(
            e,
            stackTrace: stackTrace,
          );
          print(e);
          return listOs;
        }

        for (Map<String, dynamic> data in res.body) {
          try {
            Os os = Os.fromJson(data);
            List<Os> osDb =
                listOs.where((element) => element.id == os.id).toList();
            if (osDb.length == 0) {
              await OsRepository().insert(os);
              if (data['contatos'] != null) {
                await ContatoRepository().deleteAllByOs(os.id!);
                for (Map<String, dynamic> ctt in data['contatos']) {
                  Contato cttObj = Contato.fromWeb(ctt);
                  cttObj.os = os.id;
                  await ContatoRepository().insert(cttObj);
                }
              }
            } else if (osDb[0].status == 0) {
              await OsRepository().delete(osDb[0].id);
              await OsRepository().insert(os);
              if (data['contatos'] != null) {
                await ContatoRepository().deleteAllByOs(os.id!);
                for (Map<String, dynamic> ctt in data['contatos']) {
                  Contato cttObj = Contato.fromWeb(ctt);
                  cttObj.os = os.id;
                  await ContatoRepository().insert(cttObj);
                }
              }
            }
          } catch (e, stackTrace) {
            await Sentry.captureException(
              e,
              stackTrace: stackTrace,
            );
            // debugPrint(e.toString());
          }
        }
        return await OsRepository().getAll();
      }
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      print(e);
      return Future.error('Erro interno');
    }
  }
}
