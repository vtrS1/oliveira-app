import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:oliveira_fotos/app/models/Estado.model.dart';
import 'package:oliveira_fotos/app/models/Os.model.dart';
import 'package:oliveira_fotos/app/repository/Estado.repository.dart';
import 'package:oliveira_fotos/app/repository/Os.repository.dart';
import 'package:search_cep/search_cep.dart';

class AddressController extends GetxController {
  final formKey = new GlobalKey<FormState>();
  late final Os os;

  final TextEditingController inputTelefoneSacado = new TextEditingController();
  final TextEditingController inputEmailSacado = new TextEditingController();
  final TextEditingController inputCEPSacado = new TextEditingController();
  final TextEditingController inputEstadoSacado = new TextEditingController();
  final TextEditingController inputCidadeSacado = new TextEditingController();
  final TextEditingController inputBairroSacado = new TextEditingController();
  final TextEditingController inputLogradouroSacado =
      new TextEditingController();
  final TextEditingController inputNumeroSacado = new TextEditingController();
  final TextEditingController inputComplementoSacado =
      new TextEditingController();

  static AddressController get to => Get.find();
  List<Estado> estados = [];
  Estado estadoSelecionado = new Estado()..nome = 'Amazonas';
  bool hasNumber = true;
  String tipoLogradouro = 'Rua';

  List<String> tipoDeLogradouro = [
    'Rua',
    'Avenida',
    'Residencial',
    'Aeroporto',
    'Alameda',
    'Área',
    'Campo',
    'Chácara',
    'Colônia',
    'Condomínio',
    'Conjunto',
    'Distrito',
    'Esplanada',
    'Estação',
    'Estrada',
    'Favela',
    'Feira',
    'Jardim',
    'Ladeira',
    'Lago',
    'Lagoa',
    'Largo',
    'Loteamento',
    'Morro',
    'Núcleo',
    'Parque',
    'Passarela',
    'Pátio',
    'Praça',
    'Quadra',
    'Recanto',
    'Rodovia',
    'Setor',
    'Sítio',
    'Travessa',
    'Trecho',
    'Trevo',
    'Vale',
    'Vereda',
    'Via',
    'Viaduto',
    'Viela',
    'Vila'
  ];

  @override
  void onInit() {
    super.onInit();
    this.os = Get.arguments;
    this.inputEstadoSacado.text = this.os.endEstadosNome ?? '';
    this.inputCidadeSacado.text = this.os.endCidadesNome ?? '';
    this.inputBairroSacado.text = this.os.endBairrosNome ?? '';
    this.inputLogradouroSacado.text = this.os.pessoasLogradouro ?? '';
    this.inputNumeroSacado.text = this.os.pessoasNumero ?? '';
    this.inputCEPSacado.text = this.os.pessoasCep ?? '';
    this.inputComplementoSacado.text = this.os.pessoasReferencia ?? '';
    this.fetchEstados();
  }

  Future fetchEstados() async {
    List<Estado> estados = await EstadosRepository().getAll();
    this.estados = estados;
    this.update();
  }

  setEstado(Estado? estado) {
    this.estadoSelecionado = estado!;
    this.update();
  }

  setLogradouro(String? tipo) {
    this.tipoLogradouro = tipo!;
    this.update();
  }

  updateOsAddress() async {
    if (formKey.currentState != null) {
      if (formKey.currentState!.validate()) {
        EasyLoading.show(
          status: 'Atualizando endereço',
          dismissOnTap: false,
          maskType: EasyLoadingMaskType.black,
        );
        os.endBairrosNome = inputBairroSacado.text;
        os.endCidadesNome = inputCidadeSacado.text;
        os.endEstadosNome = estadoSelecionado.nome;
        os.pessoasLogradouro = inputLogradouroSacado.text;
        os.pessoasNumero = inputNumeroSacado.text;
        os.pessoasReferencia = inputComplementoSacado.text;
        os.pessoasCep = inputCEPSacado.text;
        await OsRepository().updateOne(os);
        await GetStorage().write(os.id.toString() + '-hasEditAddress', true);
        EasyLoading.dismiss();

        // Get.offAndToNamed('/os/detail', arguments: os);
      } else {
        EasyLoading.showError('Preencha todos os campos');
      }
    } else {
      EasyLoading.showError('Ocorreu um erro, tente novamente mais tarde');
    }
  }

  changeHasNumber(bool val) {
    hasNumber = val;
    this.update();
  }

  fetchCEP() async {
    try {
      EasyLoading.show(
        status: 'Buscando endereço',
        dismissOnTap: false,
        maskType: EasyLoadingMaskType.black,
      );
      final viaCepSearchCep = ViaCepSearchCep();
      final infoCepJSON = await viaCepSearchCep.searchInfoByCep(
        cep: inputCEPSacado.text,
        returnType: SearchInfoType.json,
      );

      infoCepJSON.fold(
          (error) => {EasyLoading.showError(error.toString())},
          (data) => {
                inputEstadoSacado.text = data.uf ?? '',
                inputCidadeSacado.text = data.localidade ?? '',
                inputBairroSacado.text = data.bairro ?? '',
                inputLogradouroSacado.text = data.logradouro ?? '',
                inputComplementoSacado.text = data.complemento ?? '',
              });
    } catch (e) {
      debugPrint(e.toString());
      EasyLoading.showError('Ocorreu um erro, tente novamente mais tarde');
    } finally {
      EasyLoading.dismiss();
      this.update();
    }
  }
}
