import 'dart:async';
import 'package:oliveira_fotos/app/controllers/Os.controller.dart';
import 'package:oliveira_fotos/app/models/Os.model.dart';
import 'package:oliveira_fotos/app/provider/Db.provider.dart';
import 'package:oliveira_fotos/app/utils/consts.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class OsRepository {
  DBProvider _dbProvider = DBProvider.db;

  OsRepository();

  FutureOr<Os?> getOne(int id) async {
    var res = await _dbProvider.selectById(Constants.DB_OS, id);
    List<Os> playears = OsController().dbToList(res);
    if (playears.length > 0) {
      return playears[0];
    }
    return null;
  }

  FutureOr<List<Os>> getAll() async {
    var res = await _dbProvider.selectAll(Constants.DB_OS);
    return OsController().dbToList(res);
  }

  FutureOr<List<Os>> getByContrato(int id, String tipo) async {
    var res = await _dbProvider.selectByContrato(Constants.DB_OS, id, tipo);
    return OsController().dbToList(res);
  }

  FutureOr<List<Os>> getByLista(int id) async {
    var res = await _dbProvider.selectByLista(Constants.DB_OS, id);
    return OsController().dbToList(res);
  }

  FutureOr<List<Os>> getByContratoNumeroTipo(
      int contrato, String numero, String tipo) async {
    var res = await _dbProvider.selectOsByContratoNumeroTipo(
        Constants.DB_OS, contrato, numero, tipo);
    return OsController().dbToList(res);
  }

  FutureOr<List<Os>> getContratosValidos() async {
    var res = await _dbProvider.selectContratosValidos(Constants.DB_OS);
    return OsController().dbToList(res);
  }

  FutureOr<List<Os>> getByTipo(String tipo) async {
    var res = await _dbProvider.selectByTipo(Constants.DB_OS, tipo);
    return OsController().dbToList(res);
  }

  Future<List<Os>> search(String key) async {
    var res = await _dbProvider.searchOs(Constants.DB_OS, key);
    return OsController().dbToList(res);
  }

  Future<List<Os>> getByStatus(int status) async {
    var res = await _dbProvider.selectByStatus(Constants.DB_OS, status);
    return OsController().dbToList(res);
  }

  FutureOr<bool> delete(int? imageId) async {
    try {
      await _dbProvider.deleteById(Constants.DB_OS, imageId);
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

  FutureOr<bool> deleteByContratoNumeroTipo(
      String? contrato, String? numero, String tipo) async {
    try {
      await _dbProvider.deleteByContratoNumeroAndTipo(
          Constants.DB_OS, contrato, numero, tipo);
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

  FutureOr<bool> deleteByContratoNumeroTipoTipoImagem(
      String? contrato, String? numero, String? tipo, String tipoImagem) async {
    try {
      await _dbProvider.deleteByContratoNumeroTipoAndTipoImagem(
          Constants.DB_OS, contrato, numero, tipo, tipoImagem);
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
      await _dbProvider.deleteAll(Constants.DB_OS);
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

  FutureOr<bool> deleteByStatus(int status) async {
    try {
      await _dbProvider.deleteByStatus(Constants.DB_OS, status);
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

  FutureOr<bool> updateOne(Os image) async {
    try {
      await _dbProvider.update(Constants.DB_OS, image);
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

  FutureOr<bool> updateStatus(int id, int status) async {
    try {
      await _dbProvider.updateStatus(Constants.DB_OS, id, status);
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

  FutureOr<bool> insert(Os os) async {
    try {
      await _dbProvider.insert(Constants.DB_OS, os);
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
