import 'package:oliveira_fotos/app/models/contato.model.dart';

class ContatoController {
  List<Contato> dbToList(List<Map<dynamic, dynamic>> res) {
    List<Contato> contatos = <Contato>[];
    for (int i = 0; i < res.length; i++) {
      contatos.add(Contato.fromJson(res[i] as Map<String, dynamic>));
    }
    return contatos;
  }
}
