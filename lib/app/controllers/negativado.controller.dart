import 'package:oliveira_fotos/app/models/Negativado.model.dart';

class NegativadoController {
  List<Negativado> dbToList(List<Map<dynamic, dynamic>> res) {
    List<Negativado> negativados = <Negativado>[];
    for (int i = 0; i < res.length; i++) {
      negativados.add(Negativado.fromJson(res[i] as Map<String, dynamic>));
    }
    return negativados;
  }
}
