import 'package:oliveira_fotos/app/models/Parametro.model.dart';

class ParametrosController {
  List<Parametro> dbToList(List<Map<dynamic, dynamic>> res) {
    List<Parametro> parametros = <Parametro>[];
    for (int i = 0; i < res.length; i++) {
      parametros.add(Parametro.fromJson(res[i] as Map<String, dynamic>));
    }
    return parametros;
  }
}
