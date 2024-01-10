class Cidade {
  late int id;
  late int idEstado;
  late String nome;
  int? status;
  String? updatedAt;
  String? createdAt;

  Cidade();

  Cidade.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idEstado = json['id_estado'];
    nome = json['nome'];
    status = json['status'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['id_estado'] = this.idEstado;
    data['nome'] = this.nome;
    data['status'] = this.status;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    return data;
  }

  Map<String, dynamic> toDb() => {
        'id': this.id,
        'id_estado': this.idEstado,
        'nome': this.nome,
      };
}
