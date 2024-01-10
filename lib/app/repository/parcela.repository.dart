import 'dart:async';
import 'package:oliveira_fotos/app/controllers/Parcela.controller.dart';
import 'package:oliveira_fotos/app/models/Parcela.model.dart';
import 'package:oliveira_fotos/app/provider/Db.provider.dart';
import 'package:oliveira_fotos/app/utils/consts.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class ParcelaRepository {
  DBProvider _dbProvider = DBProvider.db;

  ParcelaRepository();

  FutureOr<Parcela?> getOne(int id) async {
    var res = await _dbProvider.selectById(Constants.DB_PARCELAS, id);
    List<Parcela> playears = ParcelaController().dbToList(res);
    if (playears.length > 0) {
      return playears[0];
    }
    return null;
  }

  FutureOr<List<Parcela>> getAll() async {
    var res = await _dbProvider.selectAll(Constants.DB_PARCELAS);
    return ParcelaController().dbToList(res);
  }

  Future<List<Parcela>> getByOs(int os) async {
    var res = await _dbProvider.selectByOs(Constants.DB_PARCELAS, os);
    print(res);
    return ParcelaController().dbToList(res);
  }

  FutureOr<bool> delete(int? imageId) async {
    try {
      await _dbProvider.deleteById(Constants.DB_PARCELAS, imageId);
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

  FutureOr<bool> deleteAllByOs(int os) async {
    try {
      await _dbProvider.deleteByOs(Constants.DB_PARCELAS, os);
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
      await _dbProvider.deleteAll(Constants.DB_PARCELAS);
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

  FutureOr<bool> updateOne(Parcela parcela) async {
    try {
      await _dbProvider.update(Constants.DB_PARCELAS, parcela);
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

  FutureOr<bool> insert(Parcela os) async {
    try {
      await _dbProvider.insert(Constants.DB_PARCELAS, os);
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
