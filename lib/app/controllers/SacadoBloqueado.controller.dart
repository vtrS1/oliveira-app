import 'package:oliveira_fotos/app/models/SacadoBloqueado.model.dart';

class SacadoBloqueadoController {
  List<SacadoBloqueado> dbToList(List<Map<dynamic, dynamic>> res) {
    List<SacadoBloqueado> sacadoBloqueados = <SacadoBloqueado>[];
    for (int i = 0; i < res.length; i++) {
      sacadoBloqueados
          .add(SacadoBloqueado.fromJson(res[i] as Map<String, dynamic>));
    }
    return sacadoBloqueados;
  }
}
