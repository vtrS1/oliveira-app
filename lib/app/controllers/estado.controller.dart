import 'package:oliveira_fotos/app/models/Estado.model.dart';

class EstadosController {
  List<Estado> dbToList(List<Map<dynamic, dynamic>> res) {
    List<Estado> estados = <Estado>[];
    for (int i = 0; i < res.length; i++) {
      estados.add(Estado.fromJson(res[i] as Map<String, dynamic>));
    }
    return estados;
  }
}
