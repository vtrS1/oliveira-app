import 'package:get/get_connect/connect.dart';
import 'package:get_storage/get_storage.dart';
import 'package:oliveira_fotos/app/models/Vendedor.model.dart';
import 'package:oliveira_fotos/app/utils/consts.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class ProfileProvider extends GetConnect {
  GetStorage box = GetStorage();
  ProfileProvider() {
    httpClient.baseUrl = Constants.API_HOST;
  }

  Future<Vendedor> fetchProfile() async {
    Response res;
    try {
      res = await get('external/vendedor/' + box.read('cpf').toString());
      if (res.hasError) {
        await Sentry.captureException(
          res.bodyString,
          stackTrace: res.status,
        );
        return Future.error(res.body!);
      } else {
        Vendedor vendedor = Vendedor.fromJson(res.body!);
        await box.write('vendedor', vendedor.toString());
        return vendedor;
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

  Future<bool> existUser(String cpf) async {
    Response res;
    try {
      res = await get('external/vendedor/' + cpf);
      if (res.hasError) {
        await Sentry.captureException(
          res.bodyString,
          stackTrace: res.status,
        );
        return false;
      } else {
        Vendedor vendedor = Vendedor.fromJson(res.body!);
        await box.write('vendedor', vendedor.toJson());
        return true;
      }
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      print(e);
      return false;
    }
  }
}
