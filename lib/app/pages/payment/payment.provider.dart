import 'package:get/get_connect/connect.dart';
import 'package:get_storage/get_storage.dart';
import 'package:oliveira_fotos/app/models/Cidade.model.dart';
import 'package:oliveira_fotos/app/models/Estado.model.dart';
import 'package:oliveira_fotos/app/models/FormaPagamento.model.dart';
import 'package:oliveira_fotos/app/models/Parametro.model.dart';
import 'package:oliveira_fotos/app/models/Vendedor.model.dart';
import 'package:oliveira_fotos/app/repository/Cidade.repository.dart';
import 'package:oliveira_fotos/app/repository/Estado.repository.dart';
import 'package:oliveira_fotos/app/repository/FormaPagamento.repository.dart';
import 'package:oliveira_fotos/app/utils/consts.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class PaymentProvider extends GetConnect {
  GetStorage box = new GetStorage();
  PaymentProvider() {
    httpClient.baseUrl = Constants.API_HOST;
  }

  Future<List<FormaPagamento>> fetchFormaPagamentos() async {
    return await FormaPagamentoRepository().getAll();
  }

  Future initFormasPagamentos() async {
    Response res;
    try {
      res = await get('external/forma-pagamentos?todos=1');
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
        await FormaPagamentoRepository().deleteAll();
        for (Map<String, dynamic> data in res.body) {
          try {
            FormaPagamento formaPagamento = FormaPagamento.fromJson(data);
            await FormaPagamentoRepository().insert(formaPagamento);
          } catch (e, stackTrace) {
            await Sentry.captureException(
              e,
              stackTrace: stackTrace,
            );
            print(e);
          }
        }

        List<FormaPagamento> formaPagamentos =
            await FormaPagamentoRepository().getAll();
        return formaPagamentos;
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

  Future initEstados() async {
    Response res;
    try {
      res = await get('external/estados');
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
        await EstadosRepository().deleteAll();
        for (Map<String, dynamic> data in res.body) {
          try {
            Estado estado = Estado.fromJson(data);
            await EstadosRepository().insert(estado);
          } catch (e, stackTrace) {
            await Sentry.captureException(
              e,
              stackTrace: stackTrace,
            );
            print(e);
          }
        }

        List<Estado> formaPagamentos = await EstadosRepository().getAll();
        return formaPagamentos;
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

  Future initCidades() async {
    Response res;
    try {
      res = await get('external/cidades');
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
        await CidadesRepository().deleteAll();
        for (Map<String, dynamic> data in res.body) {
          try {
            Cidade cidade = Cidade.fromJson(data);
            await CidadesRepository().insert(cidade);
          } catch (e, stackTrace) {
            await Sentry.captureException(
              e,
              stackTrace: stackTrace,
            );
            print(e);
          }
        }

        List<Cidade> cidades = await CidadesRepository().getAll();
        return cidades;
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

  Future checkCPF(String cpf) async {
    Response res;
    try {
      res = await get('external/sacado/cpf/$cpf');
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
        for (Map<String, dynamic> _ in res.body) {
          return true;
        }
        return false;
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

  Future fetchParametros() async {
    Response res;
    try {
      res = await get(
          'external/boleto/parametros/rpqPoN96zjSKuT2UUwpOm0F7IE0FtXaV');
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
        Parametro parametro = Parametro.fromJson(res.body);
        box.write('parametros', parametro.toJson());
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

  Parametro? getParametros() {
    var parametrosJson = box.read('parametros');
    if (parametrosJson != null) {
      return Parametro.fromJson(parametrosJson);
    }
    return null;
  }

  Vendedor? getVendedor() {
    var vendedorJson = box.read('vendedor');
    if (vendedorJson != null) {
      return Vendedor.fromJson(vendedorJson);
    }
    return null;
  }
}
