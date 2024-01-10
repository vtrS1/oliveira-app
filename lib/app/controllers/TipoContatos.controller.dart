import 'package:oliveira_fotos/app/models/Tipocontato.model.dart';

class TipoContatosController {
  List<TipoContato> dbToList(List<Map<dynamic, dynamic>> res) {
    List<TipoContato> tipoContatos = <TipoContato>[];
    for (int i = 0; i < res.length; i++) {
      tipoContatos.add(TipoContato.fromJson(res[i] as Map<String, dynamic>));
    }
    return tipoContatos;
  }
}
