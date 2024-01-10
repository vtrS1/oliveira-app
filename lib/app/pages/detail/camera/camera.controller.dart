import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:oliveira_fotos/app/models/Image.model.dart';
import 'package:oliveira_fotos/app/models/Os.model.dart';
import 'package:oliveira_fotos/app/repository/Image.repository.dart';
import 'package:oliveira_fotos/app/utils/consts.dart';

class CameraController extends GetxController {
  List<ImageModel> assinatura = <ImageModel>[];
  List<ImageModel> rg = <ImageModel>[];
  List<ImageModel> cpf = <ImageModel>[];
  List<ImageModel> compResidencia = <ImageModel>[];
  GetStorage box = GetStorage();
  ImageModel image = new ImageModel();

  CameraController() {
    Os? aluno = box.read<Os>('os');
    image.contrato = aluno!.fichasContrato!;
    image.numero = aluno.fichasNumero!;
    image.tipo = aluno.tiposNome!;
    image.tipoImagem = box.read('tipo_imagem');
  }

  Future fetchImages() async {
    await this.fetchAssinaturas();
    await this.fetchCpf();
    await this.fetchRG();
    await this.fetchCompResidencia();
  }

  Future<List<ImageModel>> fetchAssinaturas() async {
    this.assinatura = await ImageRepository().getByContratoNumeroTipoTipoImagem(
        image.contrato, image.numero, image.tipo, Constants.TIPO_ASSINATURA);
    return this.assinatura;
  }

  Future<List<ImageModel>> fetchCpf() async {
    this.cpf = await ImageRepository().getByContratoNumeroTipoTipoImagem(
        image.contrato, image.numero, image.tipo, Constants.TIPO_CPF);

    return this.cpf;
  }

  Future<List<ImageModel>> fetchRG() async {
    this.rg = await ImageRepository().getByContratoNumeroTipoTipoImagem(
        image.contrato, image.numero, image.tipo, Constants.TIPO_RG);

    return this.rg;
  }

  Future<List<ImageModel>> fetchCompResidencia() async {
    this.compResidencia = await ImageRepository()
        .getByContratoNumeroTipoTipoImagem(image.contrato, image.numero,
            image.tipo, Constants.TIPO_COMP_RESIDENCIA);

    return this.compResidencia;
  }
}
