class Estado {
  late int id;
  int? idPais;
  late String nome;
  String? sigla;
  int? status;
  String? updatedAt;
  String? createdAt;

  Estado();

  Estado.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idPais = json['id_pais'];
    nome = json['nome'];
    sigla = json['sigla'];
    status = json['status'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['id_pais'] = this.idPais;
    data['nome'] = this.nome;
    data['sigla'] = this.sigla;
    data['status'] = this.status;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    return data;
  }

  Map<String, dynamic> toDb() => {
        'id': this.id,
        'nome': this.nome,
        'sigla': this.sigla,
      };
}
