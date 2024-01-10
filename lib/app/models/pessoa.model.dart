class Responsaveis {
  int? id;
  int? os;
  String? nome;
  String? tipoPessoa;
  String? cpf;
  String? dataNascimento;
  String? comissao;
  String? obs;
  String? cep;
  int? idPais;
  int? idEstado;
  int? idCidade;
  int? idBairro;
  String? logradouro;
  String? complemento;
  int? status;
  String? updatedAt;
  String? createdAt;
  int? numero;
  String? referencia;

  Responsaveis(
      {this.id,
      this.os,
      this.nome,
      this.tipoPessoa,
      this.cpf,
      this.dataNascimento,
      this.comissao,
      this.obs,
      this.cep,
      this.idPais,
      this.idEstado,
      this.idCidade,
      this.idBairro,
      this.logradouro,
      this.complemento,
      this.status,
      this.updatedAt,
      this.createdAt,
      this.numero,
      this.referencia});

  Responsaveis.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    os = json['os'] ?? 0;
    nome = json['nome'];
    tipoPessoa = json['tipo_pessoa'];
    cpf = json['cpf'];
    dataNascimento = json['data_nascimento'];
    comissao = json['comissao'];
    obs = json['obs'];
    cep = json['cep'];
    idPais = json['id_pais'];
    idEstado = json['id_estado'];
    idCidade = json['id_cidade'];
    idBairro = json['id_bairro'];
    logradouro = json['logradouro'];
    complemento = json['complemento'];
    status = json['status'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    numero = json['numero'];
    referencia = json['referencia'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['os'] = this.os;
    data['nome'] = this.nome;
    data['tipo_pessoa'] = this.tipoPessoa;
    data['cpf'] = this.cpf;
    data['data_nascimento'] = this.dataNascimento;
    data['comissao'] = this.comissao;
    data['obs'] = this.obs;
    data['cep'] = this.cep;
    data['id_pais'] = this.idPais;
    data['id_estado'] = this.idEstado;
    data['id_cidade'] = this.idCidade;
    data['id_bairro'] = this.idBairro;
    data['logradouro'] = this.logradouro;
    data['complemento'] = this.complemento;
    data['status'] = this.status;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['numero'] = this.numero;
    data['referencia'] = this.referencia;
    return data;
  }

  Map<String, dynamic> toDb() => {
        'id': this.id,
        'os': this.os,
        'nome': this.nome,
        'cpf': this.cpf,
        'cep': this.cep,
        'logradouro': this.logradouro,
        'numero': this.numero,
        'referencia': this.referencia
      };
}
