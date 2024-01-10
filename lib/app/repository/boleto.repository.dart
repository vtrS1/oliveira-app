import 'dart:async';
import 'package:oliveira_fotos/app/controllers/Boleto.controller.dart';
import 'package:oliveira_fotos/app/models/Boleto.model.dart';
import 'package:oliveira_fotos/app/provider/Db.provider.dart';
import 'package:oliveira_fotos/app/utils/consts.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class BoletoRepository {
  DBProvider _dbProvider = DBProvider.db;

  BoletoRepository();

  Future<Boleto?> getOne(int id) async {
    var res = await _dbProvider.selectById(Constants.DB_BOLETOS, id);
    List playears = BoletoController().dbToList(res);
    if (playears.length > 0) {
      return playears[0];
    }
    return null;
  }

  Future<List<Boleto>> getAll() async {
    var res = await _dbProvider.selectAll(Constants.DB_BOLETOS);
    return BoletoController().dbToList(res);
  }

  Future<List<Boleto>> getByOs(int os) async {
    var res = await _dbProvider.selectByOs(Constants.DB_BOLETOS, os);
    return BoletoController().dbToList(res);
  }

  Future<bool> delete(int? imageId) async {
    try {
      await _dbProvider.deleteById(Constants.DB_BOLETOS, imageId);
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
      await _dbProvider.deleteByOs(Constants.DB_BOLETOS, os);
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

  Future<bool> deleteAll() async {
    print("Deletando tudo");
    try {
      await _dbProvider.deleteAll(Constants.DB_BOLETOS);
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

  Future<bool> insert(Boleto boleto) async {
    try {
      await _dbProvider.insert(Constants.DB_BOLETOS, boleto);
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
