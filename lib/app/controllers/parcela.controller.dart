import 'package:oliveira_fotos/app/models/Parcela.model.dart';

class ParcelaController {
  List<Parcela> dbToList(List<Map<dynamic, dynamic>> res) {
    List<Parcela> parcelas = <Parcela>[];
    for (int i = 0; i < res.length; i++) {
      parcelas.add(Parcela.fromJson(res[i] as Map<String, dynamic>));
    }
    return parcelas;
  }
}
