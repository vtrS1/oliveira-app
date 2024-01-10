// external/forma-pagamentos

import 'dart:async';
import 'package:oliveira_fotos/app/controllers/Responsavel.controller.dart';
import 'package:oliveira_fotos/app/models/Pessoa.model.dart';
import 'package:oliveira_fotos/app/provider/Db.provider.dart';
import 'package:oliveira_fotos/app/utils/consts.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class ResponsavelRepository {
  DBProvider _dbProvider = DBProvider.db;

  ResponsavelRepository();

  FutureOr<Responsaveis?> getOne(int id) async {
    var res = await _dbProvider.selectById(Constants.DB_RESPONSAVEL, id);
    List<Responsaveis> playears = ResponsavelController().dbToList(res);
    if (playears.length > 0) {
      return playears[0];
    }
    return null;
  }

  FutureOr<List<Responsaveis>> getAll() async {
    var res = await _dbProvider.selectAll(Constants.DB_RESPONSAVEL);
    return ResponsavelController().dbToList(res);
  }

  Future<List<Responsaveis>> getByOs(int os) async {
    var res = await _dbProvider.selectByOs(Constants.DB_RESPONSAVEL, os);
    return ResponsavelController().dbToList(res);
  }

  FutureOr<bool> delete(int? imageId) async {
    try {
      await _dbProvider.deleteById(Constants.DB_RESPONSAVEL, imageId);
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
      await _dbProvider.deleteByOs(Constants.DB_RESPONSAVEL, os);
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
      await _dbProvider.deleteAll(Constants.DB_RESPONSAVEL);
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

  FutureOr<bool> insert(Responsaveis os) async {
    try {
      await _dbProvider.insert(Constants.DB_RESPONSAVEL, os);
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
