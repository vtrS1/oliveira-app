import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:oliveira_fotos/app/models/Image.model.dart';
import 'package:oliveira_fotos/app/models/Detail.model.dart';
import 'package:oliveira_fotos/app/models/Os.model.dart';
import 'package:oliveira_fotos/app/repository/Image.repository.dart';
import 'package:oliveira_fotos/app/utils/consts.dart';

class DetailController extends GetxController {
  DetailModel detail = new DetailModel();
  GetStorage box = GetStorage();
  List<ImageModel> assinatura = <ImageModel>[];
  List<ImageModel> rg = <ImageModel>[];
  List<ImageModel> cpf = <ImageModel>[];
  List<ImageModel> compResidencia = <ImageModel>[];
  List<ImageModel> assinaturaDigital = <ImageModel>[];
  List<ImageModel> assinaturaDigitalT1 = <ImageModel>[];
  List<ImageModel> assinaturaDigitalT2 = <ImageModel>[];
  TextEditingController contratoController = new TextEditingController();
  TextEditingController numeroController = new TextEditingController();
  TextEditingController nomeT1Controller = new TextEditingController();
  TextEditingController nomeT2Controller = new TextEditingController();
  bool contratoValido = true;
  bool formularioValido = false;
  int minContratoLenght = 4;
  Os? os;

  @override
  void onInit() {
    super.onInit();
    this.os = box.read('os');
    this.contratoController =
        new TextEditingController(text: this.os!.fichasContrato!.toString());
    this.numeroController =
        new TextEditingController(text: this.os!.fichasNumero!.toString());
  }

  @override
  void onReady() {
    super.onReady();
    this.fetchImages();
  }

  Future<void> updateValues() async {
    if (contratoController.value.text.length >= minContratoLenght &&
        numeroController.value.text.length > 0) {
      await box.write('contrato', contratoController.value.text);
      await box.write('numero', numeroController.value.text);
      contratoValido = true;
    } else {
      contratoValido = false;
    }
    update();
  }

  String? validarFormulario() {
    updateValues();
    if (assinatura.length == 0 && assinaturaDigital.length == 0)
      return 'É necessário adicionar pelo menos uma assinatura, seja ela em foto ou digital.';
    if (cpf.length == 0)
      return 'É necessário adicionar pelo menos uma foto do CPF';
    if (rg.length == 0)
      return 'É necessário adicionar pelo menos uma foto do RG';
    // Assinatura é necessário pelo menos uma
    // Comprovante de residencia não é obrigatório
    // if (compResidencia.length == 0) return false;
    // if (assinaturaDigital.length == 0) return false;
    // if (contratoController.value.text.length < minContratoLenght) return false;
    // if (numeroController.value.text.length == 0) return false;
    return null;
  }

  void setContrato(int contrato) {
    this.detail.setContrato(contrato);
    update();
  }

  void setNomeT1(String nome) {
    this.nomeT1Controller.text = nome;
  }

  void setNomeT2(String nome) {
    this.nomeT2Controller.text = nome;
  }

  void setNumero(int numero) {
    this.detail.setNumero(numero);
    update();
  }

  Future fetchImages() async {
    if (this.os!.fichasContrato != null && this.os!.fichasNumero != null) {
      await this.fetchAssinaturas();
      await this.fetchAssinaturaDigital();
      await this.fetchAssinaturaDigitalT1();
      await this.fetchAssinaturaDigitalT2();
      await this.fetchCpf();
      await this.fetchRG();
      await this.fetchCompResidencia();
      update();
    }
  }

  Future<List<ImageModel>> fetchAssinaturas() async {
    this.assinatura = await ImageRepository().getByContratoNumeroTipoTipoImagem(
      this.os!.fichasContrato,
      this.os!.fichasNumero,
      this.os!.tiposNome,
      Constants.TIPO_ASSINATURA,
    );
    return this.assinatura;
  }

  Future<List<ImageModel>> fetchAssinaturaDigital() async {
    this.assinaturaDigital =
        await ImageRepository().getByContratoNumeroTipoTipoImagem(
      this.os!.fichasContrato,
      this.os!.fichasNumero,
      this.os!.tiposNome,
      Constants.TIPO_ASSINATURA_DIGITAL,
    );
    return this.assinaturaDigital;
  }

  Future<List<ImageModel>> fetchAssinaturaDigitalT1() async {
    this.assinaturaDigitalT1 =
        await ImageRepository().getByContratoNumeroTipoTipoImagem(
      this.os!.fichasContrato,
      this.os!.fichasNumero,
      this.os!.tiposNome,
      Constants.TIPO_ASSINATURA_DIGITAL_T1,
    );
    return this.assinaturaDigitalT1;
  }

  Future<List<ImageModel>> fetchAssinaturaDigitalT2() async {
    this.assinaturaDigitalT2 =
        await ImageRepository().getByContratoNumeroTipoTipoImagem(
      this.os!.fichasContrato,
      this.os!.fichasNumero,
      this.os!.tiposNome,
      Constants.TIPO_ASSINATURA_DIGITAL_T2,
    );
    return this.assinaturaDigitalT2;
  }

  Future cleanData() async {
    if (this.os != null) {
      await ImageRepository().deleteByContratoNumeroTipo(
          this.os!.fichasContrato, this.os!.fichasNumero, this.os!.tiposNome!);
    }
  }

  Future<List<ImageModel>> fetchCpf() async {
    this.cpf = await ImageRepository().getByContratoNumeroTipoTipoImagem(
        this.os!.fichasContrato,
        this.os!.fichasNumero,
        this.os!.tiposNome,
        Constants.TIPO_CPF);
    return this.cpf;
  }

  Future<List<ImageModel>> fetchRG() async {
    this.rg = await ImageRepository().getByContratoNumeroTipoTipoImagem(
        this.os!.fichasContrato,
        this.os!.fichasNumero,
        this.os!.tiposNome,
        Constants.TIPO_RG);
    print(this.rg);
    return this.rg;
  }

  Future<List<ImageModel>> fetchCompResidencia() async {
    this.compResidencia = await ImageRepository()
        .getByContratoNumeroTipoTipoImagem(
            this.os!.fichasContrato,
            this.os!.fichasNumero,
            this.os!.tiposNome,
            Constants.TIPO_COMP_RESIDENCIA);
    return this.compResidencia;
  }
}
