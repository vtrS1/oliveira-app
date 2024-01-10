import 'dart:async';
import 'package:oliveira_fotos/app/controllers/Contato.controller.dart';
import 'package:oliveira_fotos/app/models/contato.model.dart';
import 'package:oliveira_fotos/app/provider/Db.provider.dart';
import 'package:oliveira_fotos/app/utils/consts.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class ContatoRepository {
  DBProvider _dbProvider = DBProvider.db;

  ContatoRepository();

  FutureOr<Contato?> getOne(int id) async {
    var res = await _dbProvider.selectById(Constants.DB_CONTATOS, id);
    List<Contato> playears = ContatoController().dbToList(res);
    if (playears.length > 0) {
      return playears[0];
    }
    return null;
  }

  FutureOr<List<Contato>> getAll() async {
    var res = await _dbProvider.selectAll(Constants.DB_CONTATOS);
    return ContatoController().dbToList(res);
  }

  Future<List<Contato>> getByOs(int os) async {
    var res = await _dbProvider.selectByOs(Constants.DB_CONTATOS, os);
    return ContatoController().dbToList(res);
  }

  FutureOr<bool> delete(int? imageId) async {
    try {
      await _dbProvider.deleteById(Constants.DB_CONTATOS, imageId);
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
      await _dbProvider.deleteByOs(Constants.DB_CONTATOS, os);
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
      await _dbProvider.deleteAll(Constants.DB_CONTATOS);
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

  FutureOr<bool> insert(Contato os) async {
    try {
      await _dbProvider.insert(Constants.DB_CONTATOS, os);
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

  FutureOr<bool> updateOne(Contato contato) async {
    try {
      await _dbProvider.update(Constants.DB_CONTATOS, contato);
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
