// external/forma-pagamentos

import 'dart:async';
import 'package:oliveira_fotos/app/controllers/Negativado.controller.dart';
import 'package:oliveira_fotos/app/models/Negativado.model.dart';
import 'package:oliveira_fotos/app/provider/Db.provider.dart';
import 'package:oliveira_fotos/app/utils/consts.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class NegativadoRepository {
  DBProvider _dbProvider = DBProvider.db;

  NegativadoRepository();

  FutureOr<List<Negativado>> search(String cpf) async {
    var res = await _dbProvider.selectByCpf(Constants.DB_NEGATIVADOS, cpf);
    List<Negativado> negativados = NegativadoController().dbToList(res);
    return negativados;
  }

  FutureOr<Negativado?> getOne(int id) async {
    var res = await _dbProvider.selectById(Constants.DB_NEGATIVADOS, id);
    List<Negativado> negativados = NegativadoController().dbToList(res);
    if (negativados.length > 0) {
      return negativados[0];
    }
    return null;
  }

  FutureOr<List<Negativado>> getAll() async {
    var res = await _dbProvider.selectAll(Constants.DB_NEGATIVADOS);
    return NegativadoController().dbToList(res);
  }

  FutureOr<bool> delete(int? imageId) async {
    try {
      await _dbProvider.deleteById(Constants.DB_NEGATIVADOS, imageId);
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
      await _dbProvider.deleteAll(Constants.DB_NEGATIVADOS);
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

  FutureOr<bool> insert(Negativado os) async {
    try {
      await _dbProvider.insert(Constants.DB_NEGATIVADOS, os);
      return true;
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      print(e.toString() + 'AAA');
      return false;
    }
  }
}
