class FormaPagamento {
  int? id;
  int? entrada;
  String? nome;
  int? parcela;
  int? status;
  String? updatedAt;
  String? createdAt;

  FormaPagamento(
      {this.id,
      this.entrada,
      this.nome,
      this.parcela,
      this.status,
      this.updatedAt,
      this.createdAt});

  FormaPagamento.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    entrada = json['entrada'];
    nome = json['nome'];
    parcela = json['parcela'];
    status = json['status'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['entrada'] = this.entrada;
    data['nome'] = this.nome;
    data['parcela'] = this.parcela;
    data['status'] = this.status;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    return data;
  }

  Map<String, dynamic> toDb() => {
        'id': this.id,
        'entrada': this.entrada,
        'nome': this.nome,
        'parcela': this.parcela,
        'status': this.status,
      };
}
