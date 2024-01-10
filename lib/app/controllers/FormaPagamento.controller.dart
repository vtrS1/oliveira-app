import 'package:oliveira_fotos/app/models/FormaPagamento.model.dart';

class FormaPagamentoController {
  List<FormaPagamento> dbToList(List<Map<dynamic, dynamic>> res) {
    List<FormaPagamento> formaPagamentos = <FormaPagamento>[];
    for (int i = 0; i < res.length; i++) {
      formaPagamentos
          .add(FormaPagamento.fromJson(res[i] as Map<String, dynamic>));
    }
    return formaPagamentos;
  }
}
