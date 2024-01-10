import 'dart:async';
import 'package:oliveira_fotos/app/controllers/parametro.controller.dart';
import 'package:oliveira_fotos/app/models/Parametro.model.dart';
import 'package:oliveira_fotos/app/provider/Db.provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:oliveira_fotos/app/utils/consts.dart';

class ParametrosRepository {
  DBProvider _dbProvider = DBProvider.db;

  ParametrosRepository();

  FutureOr<Parametro?> getOne(int id) async {
    var res = await _dbProvider.selectById(Constants.DB_PARAMETROS, id);
    List<Parametro> playears = ParametrosController().dbToList(res);
    if (playears.length > 0) {
      return playears[0];
    }
    return null;
  }

  FutureOr<List<Parametro>> getAll() async {
    var res = await _dbProvider.selectAll(Constants.DB_PARAMETROS);
    return ParametrosController().dbToList(res);
  }

  Future<Map<String, dynamic>> toServer() async {
    var res = await _dbProvider.selectAll(Constants.DB_PARAMETROS);
    List<Parametro> p = ParametrosController().dbToList(res);
    Map<String, dynamic> parametros = {};
    for (var item in p) {
      parametros[item.subgrupo.toString()] = item.valor;
    }
    return parametros;
  }

  Future<List<Parametro>> getByOs(int os) async {
    var res = await _dbProvider.selectByOs(Constants.DB_PARAMETROS, os);
    return ParametrosController().dbToList(res);
  }

  FutureOr<bool> delete(int? imageId) async {
    try {
      await _dbProvider.deleteById(Constants.DB_PARAMETROS, imageId);
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

  Future<bool> deleteAllByOs(int os) async {
    try {
      await _dbProvider.deleteByOs(Constants.DB_PARAMETROS, os);
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
      await _dbProvider.deleteAll(Constants.DB_PARAMETROS);
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

  FutureOr<bool> insert(Parametro os) async {
    try {
      await _dbProvider.insert(Constants.DB_PARAMETROS, os);
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

  FutureOr<bool> updateOne(Parametro contato) async {
    try {
      await _dbProvider.update(Constants.DB_PARAMETROS, contato);
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
