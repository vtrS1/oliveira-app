import 'package:get/get_connect/connect.dart';
import 'package:get_storage/get_storage.dart';
import 'package:oliveira_fotos/app/models/Tipocontato.model.dart';
import 'package:oliveira_fotos/app/repository/TipoContato.repository.dart';
import 'package:oliveira_fotos/app/utils/consts.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class TipoContatosProvider extends GetConnect {
  GetStorage box = new GetStorage();
  TipoContatosProvider() {
    httpClient.baseUrl = Constants.API_HOST;
  }

  Future<List<TipoContato>> fetchTipoContatos() async {
    return await TipoContatosRepository().getAll();
  }

  Future initTiposContatos() async {
    Response res;
    try {
      res = await get('external/tipos/contatos');
      if (res.hasError) {
        await Sentry.captureException(
          res.bodyString,
          stackTrace: res.status,
        );
        if (res.status.isNotFound) {
          return Future.error(res.statusCode!);
        } else {
          return Future.error(res.body);
        }
      } else {
        for (var item in res.body) {
          TipoContato data = TipoContato.fromJson(item);
          await TipoContatosRepository().insert(data);
        }

        return fetchTipoContatos();
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
