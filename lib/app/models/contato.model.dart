class Contato {
  int? id;
  int? idContato;
  int? idPessoa;
  int? os;
  int? idTipoContato;
  String? contato;
  int? status;
  String? updatedAt;
  String? createdAt;
  String? tipoContatosNome;

  Contato(
      {this.id,
      this.idContato,
      this.idPessoa,
      this.idTipoContato,
      this.contato,
      this.status,
      this.updatedAt,
      this.createdAt,
      this.tipoContatosNome});

  Contato.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idPessoa = json['id_pessoa'];
    idContato = json['id_contato'];
    os = json['os'];
    idTipoContato = json['id_tipo_contato'];
    contato = json['contato'];
    status = json['status'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    tipoContatosNome = json['tipo_contatos_nome'];
  }

  Contato.fromWeb(Map<String, dynamic> json) {
    idPessoa = json['id_pessoa'];
    idContato = json['id'];
    os = json['os'];
    idTipoContato = json['id_tipo_contato'];
    contato = json['contato'] != null ? json['contato'] : null;
    status = json['status'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    tipoContatosNome = json['tipo_contatos_nome'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['id_contato'] = this.idContato;
    data['id_pessoa'] = this.idPessoa;
    data['id_tipo_contato'] = this.idTipoContato;
    data['contato'] = this.contato;
    data['status'] = this.status;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['tipo_contatos_nome'] = this.tipoContatosNome;
    return data;
  }

  Map<String, dynamic> toDb() => {
        'id_contato': this.idContato,
        'contato': this.contato,
        'id_tipo_contato': this.idTipoContato,
        'id_pessoa': this.idPessoa,
        'os': this.os,
        'status': this.status,
        'tipo_contatos_nome': this.tipoContatosNome
      };
}
