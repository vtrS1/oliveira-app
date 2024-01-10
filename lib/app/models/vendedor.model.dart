class Vendedor {
  int? id;
  String? nome;
  String? cpf;
  String? rg;
  String? dataNascimento;
  String? obs;
  String? cep;
  int? idPais;
  int? idEstado;
  int? idCidade;
  int? idBairro;
  String? logradouro;
  String? complemento;
  String? numero;
  String? referencia;
  String? assinatura;
  String? assinaturaTestemunha;
  int? status;
  String? updatedAt;
  String? createdAt;

  Vendedor(
      {this.id,
      this.nome,
      this.cpf,
      this.rg,
      this.dataNascimento,
      this.obs,
      this.cep,
      this.idPais,
      this.idEstado,
      this.idCidade,
      this.idBairro,
      this.logradouro,
      this.complemento,
      this.numero,
      this.referencia,
      this.assinatura,
      this.assinaturaTestemunha,
      this.status,
      this.updatedAt,
      this.createdAt});

  Vendedor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    cpf = json['cpf'];
    rg = json['rg'];
    dataNascimento = json['data_nascimento'];
    obs = json['obs'];
    cep = json['cep'];
    idPais = json['id_pais'];
    idEstado = json['id_estado'];
    idCidade = json['id_cidade'];
    idBairro = json['id_bairro'];
    logradouro = json['logradouro'];
    complemento = json['complemento'];
    numero = json['numero'];
    referencia = json['referencia'];
    assinatura = json['assinatura'];
    assinaturaTestemunha = json['assinatura_testemunha'];
    status = json['status'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toOfflineBill() => {
        'id': this.id,
        'nome': this.nome,
      };

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['cpf'] = this.cpf;
    data['rg'] = this.rg;
    data['data_nascimento'] = this.dataNascimento;
    data['obs'] = this.obs;
    data['cep'] = this.cep;
    data['id_pais'] = this.idPais;
    data['id_estado'] = this.idEstado;
    data['id_cidade'] = this.idCidade;
    data['id_bairro'] = this.idBairro;
    data['logradouro'] = this.logradouro;
    data['complemento'] = this.complemento;
    data['numero'] = this.numero;
    data['referencia'] = this.referencia;
    data['assinatura'] = this.assinatura;
    data['assinatura_testemunha'] = this.assinaturaTestemunha;
    data['status'] = this.status;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    return data;
  }
}
