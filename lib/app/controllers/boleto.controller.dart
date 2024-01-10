import 'package:oliveira_fotos/app/models/Boleto.model.dart';

class BoletoController {
  List<Boleto> dbToList(List<Map<dynamic, dynamic>> res) {
    List<Boleto> boletos = <Boleto>[];
    for (int i = 0; i < res.length; i++) {
      boletos.add(Boleto.fromJson(res[i] as Map<String, dynamic>));
    }
    return boletos;
  }
}
