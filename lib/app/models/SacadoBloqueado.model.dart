class SacadoBloqueado {
  int? id;
  int? idSacado;
  int? idVenda;
  int? bloqueado;
  String? dataInclusao;
  String? dataExecucao;
  String? obs;
  int? status;
  String? createdAt;
  String? updatedAt;

  SacadoBloqueado(
      {this.id,
      this.idSacado,
      this.idVenda,
      this.bloqueado,
      this.dataInclusao,
      this.dataExecucao,
      this.obs,
      this.status,
      this.createdAt,
      this.updatedAt});

  SacadoBloqueado.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idSacado = json['id_sacado'];
    idVenda = json['id_venda'];
    bloqueado = json['bloqueado'];
    dataInclusao = json['data_inclusao'];
    dataExecucao = json['data_execucao'];
    obs = json['obs'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['id_sacado'] = this.idSacado;
    data['id_venda'] = this.idVenda;
    data['bloqueado'] = this.bloqueado;
    data['data_inclusao'] = this.dataInclusao;
    data['data_execucao'] = this.dataExecucao;
    data['obs'] = this.obs;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
