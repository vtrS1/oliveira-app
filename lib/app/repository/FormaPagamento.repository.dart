// external/forma-pagamentos

import 'dart:async';
import 'package:oliveira_fotos/app/controllers/FormaPagamento.controller.dart';
import 'package:oliveira_fotos/app/models/FormaPagamento.model.dart';
import 'package:oliveira_fotos/app/provider/Db.provider.dart';
import 'package:oliveira_fotos/app/utils/consts.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class FormaPagamentoRepository {
  DBProvider _dbProvider = DBProvider.db;

  FormaPagamentoRepository();

  FutureOr<FormaPagamento?> getOne(int id) async {
    var res = await _dbProvider.selectById(Constants.DB_FORMA_PAGAMENTOS, id);
    List<FormaPagamento> playears = FormaPagamentoController().dbToList(res);
    if (playears.length > 0) {
      return playears[0];
    }
    return null;
  }

  FutureOr<List<FormaPagamento>> getAll() async {
    var res = await _dbProvider.selectAll(Constants.DB_FORMA_PAGAMENTOS);
    return FormaPagamentoController().dbToList(res);
  }

  FutureOr<bool> delete(int? imageId) async {
    try {
      await _dbProvider.deleteById(Constants.DB_FORMA_PAGAMENTOS, imageId);
      return true;
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      print(e);
      return false;
    }
  }

  FutureOr<bool> deleteAll() async {
    print("Deletando tudo");
    try {
      await _dbProvider.deleteAll(Constants.DB_FORMA_PAGAMENTOS);
      return true;
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      print(e);
      return false;
    }
  }

  FutureOr<bool> insert(FormaPagamento os) async {
    try {
      await _dbProvider.insert(Constants.DB_FORMA_PAGAMENTOS, os);
      return true;
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
