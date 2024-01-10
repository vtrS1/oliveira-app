class Negativado {
  int? id;
  String? cpf;

  Negativado({this.id, this.cpf});

  Negativado.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cpf = json['cpf'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cpf'] = this.cpf;
    return data;
  }

  Map<String, dynamic> toDb() => {'id': this.id, 'cpf': this.cpf};
}
