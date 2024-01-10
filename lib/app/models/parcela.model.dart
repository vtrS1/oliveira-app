class Parcela {
  int? id;
  int? idBoleto;
  int? nossoNumero;
  int? os;
  int? parcela;
  String? cpf;
  String? rg;
  String? nome;
  String? valorEntrada;
  String? valorUnitario;
  String? dataInicial;
  String? dataNascimento;
  int? qtdParcela;
  int? idFormaPagamento;
  String? valor;

  Parcela(
      {this.id,
      this.idBoleto,
      this.nossoNumero,
      this.os,
      this.parcela,
      this.idFormaPagamento,
      this.valor,
      this.valorEntrada,
      this.valorUnitario,
      this.cpf,
      this.rg,
      this.nome,
      this.dataInicial,
      this.dataNascimento,
      this.qtdParcela});

  Parcela.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    os = json['os'];
    parcela = json['parcela'];
    idBoleto = json['id_boleto'];
    nossoNumero = json['nosso_numero'];
    qtdParcela = json['qtdParcela'];
    nome = json['nome'];
    cpf = json['cpf'];
    rg = json['rg'];
    valorEntrada = json['valorEntrada'];
    valorUnitario = json['valorUnitario'];
    dataInicial = json['dataInicial'];
    dataNascimento = json['dataNascimento'];
    idFormaPagamento = json['id_forma_pagamento'];
    valor = json['valor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['id_boleto'] = this.idBoleto;
    data['nosso_numero'] = this.nossoNumero;
    data['os'] = this.os;
    data['parcela'] = this.parcela;
    data['qtdParcela'] = this.qtdParcela;
    data['nome'] = this.nome;
    data['cpf'] = this.cpf;
    data['rg'] = this.rg;
    data['dataInicial'] = this.dataInicial;
    data['dataNascimento'] = this.dataNascimento;
    data['valorUnitario'] = this.valorUnitario!;
    data['valorEntrada'] = this.valorEntrada!;
    data['id_forma_pagamento'] = this.idFormaPagamento;
    data['valor'] = this.valor!;
    return data;
  }

  Map<String, dynamic> toDb() => {
        'parcela': this.parcela,
        'os': this.os,
        'id_boleto': this.idBoleto,
        'nosso_numero': this.nossoNumero,
        'id_forma_pagamento': this.idFormaPagamento,
        'valorEntrada': this.valorEntrada,
        'valorUnitario': this.valorUnitario,
        'dataInicial': this.dataInicial,
        'dataNascimento': this.dataNascimento,
        'nome': this.nome,
        'cpf': this.cpf,
        'rg': this.rg,
        'qtdParcela': this.qtdParcela,
        'valor': this.valor
      };
}
