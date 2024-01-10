class Parametro {
  int? id;
  String? grupo;
  String? subgrupo;
  String? valor;
  String? detalhe;
  int? status;
  String? updatedAt;
  String? createdAt;

  Parametro(
      {this.id,
      this.grupo,
      this.subgrupo,
      this.valor,
      this.detalhe,
      this.status,
      this.updatedAt,
      this.createdAt});

  Parametro.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    grupo = json['grupo'];
    subgrupo = json['subgrupo'];
    valor = json['valor'];
    detalhe = json['detalhe'];
    status = json['status'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['grupo'] = this.grupo;
    data['subgrupo'] = this.subgrupo;
    data['valor'] = this.valor;
    data['detalhe'] = this.detalhe;
    data['status'] = this.status;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    return data;
  }

  Map<String, dynamic> toDb() => {
        'id': this.id,
        'grupo': this.grupo,
        'subgrupo': this.subgrupo,
        'valor': this.valor,
        'detalhe': this.detalhe,
        'status': this.status,
        'updated_at': this.updatedAt,
        'created_at': this.createdAt,
      };
}
