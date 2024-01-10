import 'package:oliveira_fotos/app/models/Pessoa.model.dart';

class ResponsavelController {
  List<Responsaveis> dbToList(List<Map<dynamic, dynamic>> res) {
    List<Responsaveis> responsaveis = <Responsaveis>[];
    for (int i = 0; i < res.length; i++) {
      responsaveis.add(Responsaveis.fromJson(res[i] as Map<String, dynamic>));
    }
    return responsaveis;
  }
}
