class TipoContato {
  int? id;
  String? nome;
  String? mascara;
  int? status;
  String? updatedAt;
  String? createdAt;

  TipoContato(
      {this.id,
      this.nome,
      this.mascara,
      this.status,
      this.updatedAt,
      this.createdAt});

  TipoContato.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    mascara = json['mascara'];
    status = json['status'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['mascara'] = this.mascara;
    data['status'] = this.status;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    return data;
  }

  Map<String, dynamic> toDb() => {
        'id': this.id,
        'nome': this.nome,
        'mascara': this.mascara,
        'status': this.status,
        'updated_at': this.updatedAt,
        'created_at': this.createdAt
      };
}
