// external/forma-pagamentos

import 'dart:async';
import 'package:oliveira_fotos/app/controllers/Cidade.controller.dart';
import 'package:oliveira_fotos/app/models/Cidade.model.dart';
import 'package:oliveira_fotos/app/provider/Db.provider.dart';
import 'package:oliveira_fotos/app/utils/consts.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class CidadesRepository {
  DBProvider _dbProvider = DBProvider.db;

  CidadesRepository();

  FutureOr<Cidade?> getOne(int id) async {
    var res = await _dbProvider.selectById(Constants.DB_CIDADES, id);
    List<Cidade> playears = CidadesController().dbToList(res);
    if (playears.length > 0) {
      return playears[0];
    }
    return null;
  }

  FutureOr<List<Cidade>> getAll() async {
    var res = await _dbProvider.selectAll(Constants.DB_CIDADES);
    return CidadesController().dbToList(res);
  }

  FutureOr<bool> delete(int? imageId) async {
    try {
      await _dbProvider.deleteById(Constants.DB_CIDADES, imageId);
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
      await _dbProvider.deleteAll(Constants.DB_CIDADES);
      return true;
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      print(e.toString());
      return false;
    }
  }

  FutureOr<bool> insert(Cidade os) async {
    try {
      await _dbProvider.insert(Constants.DB_CIDADES, os);
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
