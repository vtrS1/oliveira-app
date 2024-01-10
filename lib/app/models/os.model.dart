class Os {
  int? id;
  int? listasId;
  String? listasDataInicio;
  String? listasDataConclusao;
  int? listasIdVendedor;
  int? pessoasId;
  String? pessoasNome;
  String? testemunha1Nome;
  String? testemunha2Nome;
  String? pessoasLogradouro;
  String? pessoasNumero;
  String? pessoasReferencia;
  String? pessoasCep;
  String? pessoasNomePai;
  String? pessoasNomeMae;
  String? endEstadosNome;
  String? endCidadesNome;
  String? endBairrosNome;
  int? fichasId;
  String? fichasContrato;
  String? fichasNumero;
  int? fichasQtdFoto;
  String? instituicoesNome;
  String? instituicoesLogradouro;
  String? instituicoesCep;
  String? tiposNome;
  String? obs;
  String? motivo;
  int? status;

  Os(
      {this.id,
      this.listasId,
      this.listasDataInicio,
      this.listasDataConclusao,
      this.listasIdVendedor,
      this.pessoasId,
      this.pessoasNome,
      this.testemunha1Nome,
      this.testemunha2Nome,
      this.pessoasLogradouro,
      this.pessoasNumero,
      this.pessoasReferencia,
      this.pessoasCep,
      this.pessoasNomePai,
      this.pessoasNomeMae,
      this.endEstadosNome,
      this.endCidadesNome,
      this.endBairrosNome,
      this.fichasId,
      this.fichasContrato,
      this.fichasNumero,
      this.fichasQtdFoto,
      this.instituicoesNome,
      this.instituicoesLogradouro,
      this.instituicoesCep,
      this.tiposNome});

  Os.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    listasId = json['listas_id'];
    listasDataInicio = json['listas_data_inicio'];
    listasDataConclusao = json['listas_data_conclusao'];
    listasIdVendedor = json['listas_id_vendedor'];
    pessoasId = json['pessoas_id'];
    pessoasNome = json['pessoas_nome'];
    testemunha1Nome = json['testemunha1_nome'];
    testemunha2Nome = json['testemunha2_nome'];
    pessoasLogradouro = json['pessoas_logradouro'];
    pessoasNumero = json['pessoas_numero'];
    pessoasReferencia = json['pessoas_referencia'];
    pessoasCep = json['pessoas_cep'];
    pessoasNomePai = json['pessoas_nome_pai'];
    pessoasNomeMae = json['pessoas_nome_mae'];
    endEstadosNome = json['end_estados_nome'];
    endCidadesNome = json['end_cidades_nome'];
    endBairrosNome = json['end_bairros_nome'];
    fichasId = json['fichas_id'];
    fichasContrato = json['fichas_contrato'];
    fichasNumero = json['fichas_numero'];
    fichasQtdFoto = json['fichas_qtd_foto'];
    instituicoesNome = json['instituicoes_nome'];
    instituicoesLogradouro = json['instituicoes_logradouro'];
    instituicoesCep = json['instituicoes_cep'];
    tiposNome = json['tipos_nome'];
    status = json['status'];
    obs = json['obs'];
    motivo = json['motivo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['listas_id'] = this.listasId;
    data['listas_data_inicio'] = this.listasDataInicio;
    data['listas_data_conclusao'] = this.listasDataConclusao;
    data['listas_id_vendedor'] = this.listasIdVendedor;
    data['pessoas_id'] = this.pessoasId;
    data['pessoas_nome'] = this.pessoasNome;
    data['testemunha1_nome'] = this.testemunha1Nome;
    data['testemunha2_nome'] = this.testemunha2Nome;
    data['pessoas_logradouro'] = this.pessoasLogradouro;
    data['pessoas_numero'] = this.pessoasNumero;
    data['pessoas_referencia'] = this.pessoasReferencia;
    data['pessoas_cep'] = this.pessoasCep;
    data['pessoas_nome_pai'] = this.pessoasNomePai;
    data['pessoas_nome_mae'] = this.pessoasNomeMae;
    data['end_estados_nome'] = this.endEstadosNome;
    data['end_cidades_nome'] = this.endCidadesNome;
    data['end_bairros_nome'] = this.endBairrosNome;
    data['fichas_id'] = this.fichasId;
    data['fichas_contrato'] = this.fichasContrato;
    data['fichas_numero'] = this.fichasNumero;
    data['fichas_qtd_foto'] = this.fichasQtdFoto;
    data['instituicoes_nome'] = this.instituicoesNome;
    data['instituicoes_logradouro'] = this.instituicoesLogradouro;
    data['instituicoes_cep'] = this.instituicoesCep;
    data['tipos_nome'] = this.tiposNome;
    data['status'] = this.status;
    data['obs'] = this.obs;
    data['motivo'] = this.motivo;

    return data;
  }

  Map<String, dynamic> toReservBillJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['os'] = this.id;
    data['id_vendedor'] = this.listasIdVendedor;
    data['id_ficha'] = this.fichasId;
    return data;
  }

  Map<String, dynamic> toOfflineBill() => {
        'id': this.id,
        'nome': this.pessoasNome,
        'cpf': this.pessoasCep,
        'logradouro': this.addressOfflineBill(),
        'cep': this.pessoasCep,
        'cidade': this.endCidadesNome,
        'estado': this.endEstadosNome,
        'bairro': this.endBairrosNome,
        'contrato': this.fichasContrato,
        'numeroFicha': this.fichasNumero,
      };

  Map<String, dynamic> toDb() => {
        'id': this.id,
        'listas_id': this.listasId,
        'listas_data_inicio': this.listasDataInicio,
        'listas_data_conclusao': this.listasDataConclusao,
        'listas_id_vendedor': this.listasIdVendedor,
        'pessoas_id': this.pessoasId,
        'pessoas_nome': this.pessoasNome,
        'testemunha1_nome': this.testemunha1Nome,
        'testemunha2_nome': this.testemunha2Nome,
        'pessoas_nome_pai': this.pessoasNomePai ?? ' ',
        'pessoas_nome_mae': this.pessoasNomeMae ?? ' ',
        'pessoas_logradouro': this.pessoasLogradouro,
        'pessoas_numero': this.pessoasNumero,
        'pessoas_referencia': this.pessoasReferencia,
        'pessoas_cep': this.pessoasCep,
        'end_estados_nome': this.endEstadosNome,
        'end_cidades_nome': this.endCidadesNome,
        'end_bairros_nome': this.endBairrosNome,
        'fichas_id': this.fichasId,
        'fichas_contrato': this.fichasContrato,
        'fichas_numero': this.fichasNumero,
        'fichas_qtd_foto': this.fichasQtdFoto,
        'instituicoes_nome': this.instituicoesNome,
        'instituicoes_logradouro': this.instituicoesLogradouro,
        'instituicoes_cep': this.instituicoesCep,
        'tipos_nome': this.tiposNome,
        'obs': this.obs,
        'motivo': this.motivo,
        'status': this.status ?? 0
      };

  String addressOfflineBill() {
    return '${pessoasLogradouro ?? ""} ${pessoasNumero ?? ""} - ${endBairrosNome ?? ""}';
  }

  String address() {
    return '${pessoasLogradouro ?? ''} ${pessoasNumero ?? ''} - ${endBairrosNome ?? ''} - ${endCidadesNome ?? ''} - ${endEstadosNome ?? ''}';
  }

  String fullAddress() {
    return 'Logradouro: ${pessoasLogradouro != null ? pessoasLogradouro : ''} \nNº: ${pessoasNumero != null ? pessoasNumero : ''} \nReferência: ${pessoasReferencia != null ? pessoasReferencia : ''} \nBairro: ${endBairrosNome != null ? endBairrosNome : ''} \nCidade: ${endCidadesNome != null ? endCidadesNome : ''} \nEstado: ${endEstadosNome != null ? endEstadosNome : ''} \nCEP: ${pessoasCep != null ? pessoasCep : ''}';
  }
}
