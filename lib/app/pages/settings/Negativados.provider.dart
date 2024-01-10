import 'package:get/get_connect/connect.dart';
import 'package:get_storage/get_storage.dart';
import 'package:oliveira_fotos/app/models/Negativado.model.dart';
import 'package:oliveira_fotos/app/repository/Negativado.repository.dart';
import 'package:oliveira_fotos/app/utils/consts.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class NegativadosProvider extends GetConnect {
  GetStorage box = new GetStorage();
  NegativadosProvider() {
    httpClient.baseUrl = Constants.API_HOST;
    httpClient.timeout = Duration(seconds: 240);
  }

  Future<List<Negativado>> fetchNegativados() async {
    return await NegativadoRepository().getAll();
  }

  Future initNegativados() async {
    Response res;
    try {
      res = await get('external/negativados/${Constants.OTK_KEY}');
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
        await NegativadoRepository().deleteAll();

        for (Map<String, dynamic> data in res.body) {
          try {
            Negativado negativado = Negativado.fromJson(data);
            await NegativadoRepository().insert(negativado);
          } catch (e, stackTrace) {
            await Sentry.captureException(
              e,
              stackTrace: stackTrace,
            );
            print(e.toString() + 'BBB');
          }
        }

        List<Negativado> negativados = await NegativadoRepository().getAll();
        return negativados;
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
