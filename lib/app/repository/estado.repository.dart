// external/forma-pagamentos

import 'dart:async';
import 'package:oliveira_fotos/app/controllers/Estado.controller.dart';
import 'package:oliveira_fotos/app/models/Estado.model.dart';
import 'package:oliveira_fotos/app/provider/Db.provider.dart';
import 'package:oliveira_fotos/app/utils/consts.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class EstadosRepository {
  DBProvider _dbProvider = DBProvider.db;

  EstadosRepository();

  FutureOr<Estado?> getOne(int id) async {
    var res = await _dbProvider.selectById(Constants.DB_ESTADOS, id);
    List<Estado> playears = EstadosController().dbToList(res);
    if (playears.length > 0) {
      return playears[0];
    }
    return null;
  }

  FutureOr<List<Estado>> getAll() async {
    var res = await _dbProvider.selectAll(Constants.DB_ESTADOS);
    return EstadosController().dbToList(res);
  }

  FutureOr<bool> delete(int? imageId) async {
    try {
      await _dbProvider.deleteById(Constants.DB_ESTADOS, imageId);
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
      await _dbProvider.deleteAll(Constants.DB_ESTADOS);
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

  FutureOr<bool> insert(Estado os) async {
    try {
      await _dbProvider.insert(Constants.DB_ESTADOS, os);
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
