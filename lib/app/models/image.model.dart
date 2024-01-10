// To parse this JSON data, do
//
//     final imageModel = imageModelFromJson(jsonString);

import 'dart:convert';

ImageModel imageModelFromJson(String str) =>
    ImageModel.fromJson(json.decode(str));

String imageModelToJson(ImageModel data) => json.encode(data.toJson());

class ImageModel {
  ImageModel({
    this.id,
    this.contrato,
    this.idListaAluno,
    this.idFicha,
    this.numero,
    this.tipo,
    this.tipoImagem,
    this.src,
    this.status,
  });

  int? id;
  String? contrato;
  int? idListaAluno;
  int? idFicha;
  String? numero;
  String? tipo;
  String? tipoImagem;
  String? src;
  int? status = 0;

  factory ImageModel.fromJson(Map<String, dynamic> json) => ImageModel(
        id: json["id"],
        contrato: json["contrato"],
        idListaAluno: json["id_lista_aluno"],
        idFicha: json["id_ficha"],
        numero: json["numero"],
        tipo: json["tipo"],
        tipoImagem: json["tipo_imagem"],
        src: json["src"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "contrato": contrato,
        "id_lista_aluno": idListaAluno,
        "id_ficha": idFicha,
        "numero": numero,
        "tipo": tipo,
        "tipo_imagem": tipoImagem,
        "src": src,
        "status": status,
      };

  Map<String, dynamic> toDb() => {
        "id_lista_aluno": idListaAluno,
        "id_ficha": idFicha,
        "contrato": contrato,
        "numero": numero,
        "tipo": tipo,
        "tipo_imagem": tipoImagem,
        "src": src,
        "status": status,
      };
}
