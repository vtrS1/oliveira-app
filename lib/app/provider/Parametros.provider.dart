import 'package:get/get_connect/connect.dart';
import 'package:get_storage/get_storage.dart';
import 'package:oliveira_fotos/app/models/Parametro.model.dart';
import 'package:oliveira_fotos/app/repository/Parametro.repository.dart';
import 'package:oliveira_fotos/app/utils/consts.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class ParametroProvider extends GetConnect {
  GetStorage box = new GetStorage();
  ParametroProvider() {
    httpClient.baseUrl = Constants.API_HOST;
  }

  Future<List<Parametro>> fetchParametros() async {
    return await ParametrosRepository().getAll();
  }

  Future initParametros() async {
    Response res;
    try {
      res = await get(
          'external/boleto/app/parametros/rpqPoN96zjSKuT2UUwpOm0F7IE0FtXaV');
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
          Parametro parametro = Parametro.fromJson(item);
          await ParametrosRepository().insert(parametro);
        }

        return fetchParametros();
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
