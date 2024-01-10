class Boleto {
  int? parcela;
  int? idVenda;
  int? os;
  int? id;
  int? nossoNumero;
  int? idVendaParcela;
  String? dataVencimento;
  int? valor;
  int? status;
  String? url;

  Boleto(
      {this.parcela,
      this.idVenda,
      this.idVendaParcela,
      this.dataVencimento,
      this.valor,
      this.status,
      this.url});

  Boleto.fromJson(Map<String, dynamic> json) {
    parcela = json['parcela'];
    idVenda = json['id_venda'];
    dataVencimento = json['data_vencimento'];
    os = json['os'];
    id = json['id'];
    nossoNumero = json['nosso_numero'];
    idVendaParcela = json['id_venda_parcela'];
    valor = json['valor'];
    status = json['status'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['parcela'] = this.parcela;
    data['id_venda'] = this.idVenda;
    data['data_vencimento'] = this.dataVencimento;
    data['valor'] = this.valor;
    data['nosso_numero'] = this.nossoNumero;
    data['status'] = this.status;
    data['url'] = this.url;
    return data;
  }

  Map<String, dynamic> toDb() => {
        'id_venda': this.idVenda,
        'os': this.os,
        'id': this.id,
        'nosso_numero': this.nossoNumero,
        'id_venda_parcela': this.idVendaParcela
      };
}
