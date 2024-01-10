import 'package:get/get_connect/connect.dart';
import 'package:get_storage/get_storage.dart';
import 'package:oliveira_fotos/app/models/Boleto.model.dart';
import 'package:oliveira_fotos/app/utils/consts.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class PartialsProvider extends GetConnect {
  GetStorage box = new GetStorage();
  PartialsProvider() {
    httpClient.baseUrl = Constants.API_HOST;
  }

  Future<List<Boleto>> fetchPartials(String os) async {
    Response res;
    try {
      res = await get('external/venda/boletos/' + os);
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
        List<Boleto> boletos = [];
        for (Map<String, dynamic> data in res.body) {
          boletos.add(Boleto.fromJson(data));
        }

        return boletos;
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
