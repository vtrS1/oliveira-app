import 'package:get/get_connect/connect.dart';
import 'package:get_storage/get_storage.dart';
import 'package:oliveira_fotos/app/models/Boleto.model.dart';
import 'package:oliveira_fotos/app/repository/Boleto.repository.dart';
import 'package:oliveira_fotos/app/utils/consts.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class OsProvider extends GetConnect {
  GetStorage box = new GetStorage();
  OsProvider() {
    httpClient.baseUrl = Constants.API_HOST;
    httpClient.timeout = Duration(seconds: 45);
  }

  Future<List<Boleto>?> offlineBills(Map data) async {
    Response res;
    try {
      res = await post('external/os/reservar-boleto', data);
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
        if (res.body is List) {
          await BoletoRepository().deleteAllByOs(data['os']);
          for (Map<String, dynamic> data in res.body) {
            Boleto boleto = Boleto.fromJson(data);
            await BoletoRepository().insert(boleto);
          }

          return await BoletoRepository().getByOs(data['os']);
        }
        if (res.body.containsKey('message')) {
          return Future.error(res.body['message']);
        } else {
          return Future.error(res.body);
        }
      }
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      return Future.error(e);
    }
  }
}
