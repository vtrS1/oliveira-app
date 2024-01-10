import 'dart:async';

import 'package:oliveira_fotos/app/controllers/Image.controller.dart';
import 'package:oliveira_fotos/app/models/Image.model.dart';
import 'package:oliveira_fotos/app/provider/Db.provider.dart';
import 'package:oliveira_fotos/app/utils/consts.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class ImageRepository {
  DBProvider _dbProvider = DBProvider.db;

  ImageRepository();

  FutureOr<ImageModel?> getOne(int id) async {
    var res = await _dbProvider.selectById(Constants.DB_IMAGES, id);
    List<ImageModel> playears = ImageController().dbToList(res);
    if (playears.length > 0) {
      return playears[0];
    }
    return null;
  }

  FutureOr<List<ImageModel>> getAll() async {
    var res = await _dbProvider.selectAll(Constants.DB_IMAGES);
    return ImageController().dbToList(res);
  }

  Future<List<ImageModel>> getByOs(int os) async {
    var res = await _dbProvider.selectImagesByOs(Constants.DB_IMAGES, os);
    return ImageController().dbToList(res);
  }

  FutureOr<List<ImageModel>> getByContrato(int id, String tipo) async {
    var res = await _dbProvider.selectByContrato(Constants.DB_IMAGES, id, tipo);
    return ImageController().dbToList(res);
  }

  FutureOr<List<ImageModel>> getByContratoNumeroTipoTipoImagem(
      String? contrato, String? numero, String? tipo, String tipoImagem) async {
    var res = await _dbProvider.selectByContratoNumeroTipoTipoImagem(
        Constants.DB_IMAGES, contrato, numero, tipo, tipoImagem);
    return ImageController().dbToList(res);
  }

  FutureOr<List<ImageModel>> getByContratoNumeroTipo(
      int contrato, int numero, String tipo) async {
    var res = await _dbProvider.selectByContratoNumeroTipo(
        Constants.DB_IMAGES, contrato, numero, tipo);
    return ImageController().dbToList(res);
  }

  FutureOr<List<ImageModel>> getContratosValidos() async {
    var res = await _dbProvider.selectContratosValidos(Constants.DB_IMAGES);
    return ImageController().dbToList(res);
  }

  FutureOr<List<ImageModel>> getByTipo(String tipo) async {
    var res = await _dbProvider.selectByTipo(Constants.DB_IMAGES, tipo);
    return ImageController().dbToList(res);
  }

  FutureOr<bool> delete(int? imageId) async {
    try {
      await _dbProvider.deleteById(Constants.DB_IMAGES, imageId);
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
          Constants.DB_IMAGES, contrato, numero, tipo);
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

  FutureOr<bool> deleteImageByOs(
    int os,
  ) async {
    try {
      await _dbProvider.deleteByIdListaAluno(Constants.DB_IMAGES, os);
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
          Constants.DB_IMAGES, contrato, numero, tipo, tipoImagem);
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
      await _dbProvider.deleteAll(Constants.DB_IMAGES);
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

  FutureOr<bool> updateOne(ImageModel image) async {
    try {
      await _dbProvider.update(Constants.DB_IMAGES, image);
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

  FutureOr<bool> insert(ImageModel image) async {
    try {
      await _dbProvider.insert(Constants.DB_IMAGES, image);
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
