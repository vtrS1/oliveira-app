import 'package:oliveira_fotos/app/models/Cidade.model.dart';

class CidadesController {
  List<Cidade> dbToList(List<Map<dynamic, dynamic>> res) {
    List<Cidade> cidades = <Cidade>[];
    for (int i = 0; i < res.length; i++) {
      cidades.add(Cidade.fromJson(res[i] as Map<String, dynamic>));
    }
    return cidades;
  }
}
