import 'dart:async';
import 'package:oliveira_fotos/app/controllers/TipoContatos.controller.dart';
import 'package:oliveira_fotos/app/models/Tipocontato.model.dart';
import 'package:oliveira_fotos/app/provider/Db.provider.dart';
import 'package:oliveira_fotos/app/utils/consts.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class TipoContatosRepository {
  DBProvider _dbProvider = DBProvider.db;

  TipoContatosRepository();

  FutureOr<TipoContato?> getOne(int id) async {
    var res = await _dbProvider.selectById(Constants.DB_TIPO_CONTATOS, id);
    List<TipoContato> playears = TipoContatosController().dbToList(res);
    if (playears.length > 0) {
      return playears[0];
    }
    return null;
  }

  FutureOr<List<TipoContato>> getAll() async {
    var res = await _dbProvider.selectAll(Constants.DB_TIPO_CONTATOS);
    return TipoContatosController().dbToList(res);
  }

  Future<List<TipoContato>> getByOs(int os) async {
    var res = await _dbProvider.selectByOs(Constants.DB_TIPO_CONTATOS, os);
    return TipoContatosController().dbToList(res);
  }

  FutureOr<bool> delete(int? imageId) async {
    try {
      await _dbProvider.deleteById(Constants.DB_TIPO_CONTATOS, imageId);
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
      await _dbProvider.deleteByOs(Constants.DB_TIPO_CONTATOS, os);
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
      await _dbProvider.deleteAll(Constants.DB_TIPO_CONTATOS);
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

  FutureOr<bool> insert(TipoContato os) async {
    try {
      await _dbProvider.insert(Constants.DB_TIPO_CONTATOS, os);
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

  FutureOr<bool> updateOne(TipoContato contato) async {
    try {
      await _dbProvider.update(Constants.DB_TIPO_CONTATOS, contato);
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
