import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:oliveira_fotos/app/models/Boleto.model.dart';
import 'package:oliveira_fotos/app/models/FormaPagamento.model.dart';
import 'package:oliveira_fotos/app/models/Os.model.dart';
import 'package:oliveira_fotos/app/models/Parcela.model.dart';
import 'package:oliveira_fotos/app/pages/listas/Listas.controller.dart';
import 'package:oliveira_fotos/app/pages/payment/payment.provider.dart';
import 'package:oliveira_fotos/app/pages/upload/upload.controller.dart';
import 'package:oliveira_fotos/app/repository/Boleto.repository.dart';
import 'package:oliveira_fotos/app/repository/FormaPagamento.repository.dart';
import 'package:oliveira_fotos/app/repository/Os.repository.dart';
import 'package:oliveira_fotos/app/repository/Parcela.repository.dart';
import 'package:oliveira_fotos/app/utils/consts.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

extension NumberParsing on String {
  double? parseFloat() {
    String value = this;
    value = value.replaceAll(".", "");
    value = value.replaceAll(",", ".");
    value = value.replaceAll("R\$", "");
    try {
      return double.parse(value);
    } catch (e, stackTrace) {
      Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }
}

class PaymentController extends GetxController
    with StateMixin<List<FormaPagamento>> {
  List<FormaPagamento> formasPagamentos = <FormaPagamento>[];
  GetStorage box = GetStorage();
  Os? os = GetStorage().read('os');

  final formKey = new GlobalKey<FormState>();

  final TextEditingController inputNomeSacado = new TextEditingController();
  final TextEditingController inputCPFSacado = new TextEditingController();
  final TextEditingController inputRGSacado = new TextEditingController();

  final TextEditingController inputQtdParcela =
      new TextEditingController(text: '1');
  final inputValorUnitario = MoneyMaskedTextController(
      leftSymbol: 'R\$ ', initialValue: 0); // new TextEditingController();
  final inputValorEntrada =
      new MoneyMaskedTextController(leftSymbol: 'R\$ ', initialValue: 0);
  int inputFormaPagamento = 1;
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  static PaymentController get to => Get.find();

  DateTime dateInitial = DateTime.now();
  DateTime dateNascimentoSacado = DateTime.now();
  DateTime lastDate = DateTime.now();
  DateTime dateInitialParcel = DateTime.now().add(Duration(days: 30));

  List<Parcela> parcelas = <Parcela>[];
  List<Boleto>? boletos;
  bool isValidCpf = true;

  @override
  void onInit() {
    super.onInit();
    change(null, status: RxStatus.loading());
    ParcelaRepository()
        .getByOs(this.os!.id!)
        .then((value) => this.parcelas = value)
        .then((value) => PaymentProvider().fetchFormaPagamentos().then((resp) {
              if (resp.isBlank!) {
                change(resp, status: RxStatus.empty());
              } else {
                this.formasPagamentos = resp;
                change(resp, status: RxStatus.success());
              }
            }, onError: (err) {
              change(
                null,
                status: RxStatus.error(err.toString()),
              );
            }));
  }

  bool isEntradaValid() {
    double? entrada = inputValorEntrada.text.parseFloat();
    double? unitario = inputValorUnitario.text.parseFloat();

    if (entrada! > unitario!) return false;
    return true;
  }

  bool isValidValueParcel() {
    double? entrada = inputValorEntrada.text.parseFloat();
    double? unitario = inputValorUnitario.text.parseFloat();

    if (unitario! - entrada! == Constants.VALOR_MIN_PARCELA) return false;
    return true;
  }

  Future<List<FormaPagamento>> getFormaPagamentoEntrada() async {
    List<FormaPagamento> formas = await FormaPagamentoRepository().getAll();
    formas = formas.where((element) => element.entrada == 1).toList();
    return formas;
  }

  List<Parcela> getParcelasBoletos() {
    return this.parcelas.where((element) => element.idBoleto != null).toList();
  }

  // Retorna uma lista de boletos disponível para usar quando ofline,
  // desde que tenham sido reservados
  Future<List<Boleto>> getBoletosDisponiveis() async {
    return await BoletoRepository().getByOs(os!.id!);
  }

  Future<Boleto?> getFirstBoletoDisponivel() async {
    List<Boleto> boletosDisponiveis = await this.getBoletosDisponiveis();
    List<Parcela> boletoParcela = [];
    // Metodo de pagamento é boleto e a OS tem boletos offline
    if (boletosDisponiveis.length > 0) {
      List<Parcela> parcelasBoleto = this.getParcelasBoletos();
      // Buscar por código de boleto disponível
      for (Boleto boleto in boletosDisponiveis) {
        boletoParcela = parcelasBoleto
            .where((element) => element.idBoleto == boleto.id)
            .toList();
        // Existe código de boleto dispoível
        if (boletoParcela.length == 0) {
          return boleto;
        }
      }
    }
    return null;
  }

  // Seleciona a forma de pagamento da parcela selecionada,
  // Retorna um boolean
  Future<bool> setFormaPagamentoParcela(
      FormaPagamento accepted, int idxParcela) async {
    // Método de pagamento não é boleto
    if (accepted.id! != Constants.ID_BOLETO) {
      this.parcelas[idxParcela].idBoleto = null;
      this.parcelas[idxParcela].idFormaPagamento = accepted.id!;
    }
    // Método de pagamento via boleto
    else {
      List<Boleto> boletosDisponiveis = await this.getBoletosDisponiveis();
      if (boletosDisponiveis.length > 0) {
        Boleto? boleto = await this.getFirstBoletoDisponivel();
        // Essa parcela não pode usar boleto, pois não tem mais códigos disponíveis
        if (boleto != null) {
          this.parcelas[idxParcela].idBoleto = boleto.id;
          this.parcelas[idxParcela].nossoNumero = boleto.nossoNumero;
          this.parcelas[idxParcela].idFormaPagamento = accepted.id!;
        } else {
          Get.snackbar('Aviso', '',
              snackPosition: SnackPosition.TOP,
              duration: Duration(seconds: 7),
              margin: EdgeInsets.all(20),
              backgroundColor: Colors.amber[800],
              colorText: Colors.white,
              messageText: Text(
                'Você gerou a numeração de boletos para usar em locais onde não há acesso à internet. No momento você já usou os ${boletosDisponiveis.length} números de boletos com as outras parcelas e não é possível adicionar mais uma com essa forma de pagamento.',
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
              ),
              icon: Icon(Icons.warning));
          return false;
        }
      }
      // Método de pagamento via boleto
      // mas os boletos serão gerados durante o envio da OS
      else {
        this.parcelas[idxParcela].idFormaPagamento = accepted.id!;
      }
    }
    return true;
  }

  Future<void> gerarParcelas() async {
    List<Boleto> boletos = await this.getBoletosDisponiveis();
    double? entrada = inputValorEntrada.text.parseFloat();
    double? unitario = inputValorUnitario.text.parseFloat();
    if (isEntradaValid()) {
      if (isValidValueParcel()) {
        List<double> valorParcelas =
            formatMoney(unitario! - entrada!, int.parse(inputQtdParcela.text));
        this.parcelas = [];
        for (int i = 1; i <= int.parse(inputQtdParcela.text); i++) {
          this.parcelas.add(new Parcela(
              valor: valorParcelas[i].toString(),
              parcela: i,
              idBoleto: boletos.length >= i ? boletos[i - 1].id : null,
              nossoNumero:
                  boletos.length >= i ? boletos[i - 1].nossoNumero : null,
              os: this.os!.id!,
              idFormaPagamento: inputFormaPagamento == Constants.ID_BOLETO
                  ? boletos.length >= i
                      ? inputFormaPagamento
                      : boletos.length == 0
                          ? inputFormaPagamento
                          : 6
                  : inputFormaPagamento,
              nome: this.inputNomeSacado.text,
              cpf: this.inputCPFSacado.text,
              rg: this.inputRGSacado.text,
              qtdParcela: int.parse(this.inputQtdParcela.text),
              valorEntrada: this.inputValorEntrada.text,
              dataInicial: this.dateInitialParcel.toString(),
              dataNascimento: this.dateNascimentoSacado.toString(),
              valorUnitario: this.inputValorUnitario.text));
        }
      } else {
        if (int.parse(inputQtdParcela.text) > 0) {
          Get.snackbar(
              'Aviso', 'O final é muito baixo e não pode ser parcelado');
        }
        this.parcelas = [];
      }
      if (entrada! > 0) {
        this.parcelas.add(new Parcela(
            valor: this.inputValorEntrada.text.parseFloat().toString(),
            parcela: 0,
            os: this.os!.id!,
            idFormaPagamento: 6,
            nome: this.inputNomeSacado.text,
            cpf: this.inputCPFSacado.text,
            rg: this.inputRGSacado.text,
            dataInicial: this.dateInitialParcel.toString(),
            dataNascimento: this.dateNascimentoSacado.toString(),
            qtdParcela: int.parse(this.inputQtdParcela.text),
            valorEntrada: this.inputValorEntrada.text,
            valorUnitario: this.inputValorUnitario.text));
      }
    } else {
      Get.snackbar('Aviso',
          'O valor da entrada não pode ser maior que o valor unitário');
      this.parcelas = [];
    }
    this.parcelas.sort((a, b) => a.parcela!.compareTo(b.parcela!));
  }

  String getNameFromIdFormaPagamento(int id) {
    try {
      FormaPagamento forma =
          this.formasPagamentos.firstWhere((element) => element.id == id);
      return forma.nome!;
    } catch (e, stackTrace) {
      Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      return '';
    }
  }

  Future finalizarVenda(BuildContext ctt) async {
    List<Parcela> parcelaBoleto = this
        .parcelas
        .where((element) => element.idFormaPagamento == Constants.ID_BOLETO)
        .toList();
    List<Boleto> ls = await BoletoRepository().getByOs(os!.id!);
    if (parcelaBoleto.length > ls.length && ls.length > 0) {
      Get.snackbar('Aviso', '',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 7),
          margin: EdgeInsets.all(20),
          backgroundColor: Colors.amber[800],
          colorText: Colors.white,
          messageText: Text(
            'Você gerou a numeração de boletos para usar em locais onde não há acesso à internet. No momento você pode no maximo cadastrar ${ls.length} parcelas com o pagamento via Boleto Bancário e você está tentando cadastrar ${parcelaBoleto.length}.',
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
          ),
          icon: Icon(Icons.warning));
    } else if (isEntradaValid()) {
      if (this.isValidCpf != true) {
        Get.snackbar('Aviso', '',
            snackPosition: SnackPosition.TOP,
            duration: Duration(seconds: 7),
            margin: EdgeInsets.all(20),
            backgroundColor: Colors.red[800],
            colorText: Colors.white,
            messageText: Text(
              'Foram encontradas restrições de venda para esse CPF no sistema, uma nova venda não será liberada enquanto a pendência não for resolvida com o setor financeiro.',
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
            ),
            icon: Icon(Icons.warning));
      } else if (!CPFValidator.isValid(this.parcelas.first.cpf)) {
        Get.snackbar('Aviso', '',
            snackPosition: SnackPosition.TOP,
            duration: Duration(seconds: 7),
            margin: EdgeInsets.all(20),
            backgroundColor: Colors.blue[800],
            colorText: Colors.white,
            messageText: Text(
              'Digite um CPF válido',
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
            ),
            icon: Icon(Icons.warning));
      } else if (this.parcelas.length > 0) {
        await ParcelaRepository().deleteAllByOs(this.os!.id!);
        for (Parcela parcela in this.parcelas) {
          await ParcelaRepository().insert(parcela);
        }
        this.parcelas = await ParcelaRepository().getByOs(this.os!.id!);
        await OsRepository().updateStatus(this.os!.id!, 1);
        await Get.find<UploadViewController>().syncOneService(this.os!);
        Get.find<ListaController>().updateData();
        Navigator.pop(ctt);
      } else {
        Get.snackbar(
            'Aviso', 'Nenhuma parcela encontrada, clique em "Gerar parcelas"');
      }
    } else {
      Get.snackbar('Aviso',
          'O valor da entrada não pode ser maior que o valor unitário');
    }
  }

  Future<bool> checkCpf(String cpf) async {
    if (CPFValidator.isValid(cpf)) {
      try {
        EasyLoading.show(
          status: 'Buscando informações...',
          dismissOnTap: false,
          maskType: EasyLoadingMaskType.black,
        );
        var isNotValid = await PaymentProvider().checkCPF(cpf);
        EasyLoading.dismiss();
        if (isNotValid == true) {
          this.inputCPFSacado.clear();
          this.isValidCpf = false;
          Get.snackbar('Aviso', '',
              snackPosition: SnackPosition.TOP,
              duration: Duration(seconds: 7),
              margin: EdgeInsets.all(20),
              backgroundColor: Colors.red[800],
              colorText: Colors.white,
              messageText: Text(
                'Foram encontradas restrições de venda para esse CPF no sistema, uma nova venda não será liberada enquanto a pendência não for resolvida com o setor financeiro.',
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
              ),
              icon: Icon(Icons.warning));
          return false;
        } else {
          this.isValidCpf = true;
          Get.snackbar('Aviso', '',
              snackPosition: SnackPosition.TOP,
              duration: Duration(seconds: 3),
              margin: EdgeInsets.all(20),
              backgroundColor: Colors.green[800],
              colorText: Colors.white,
              messageText: Text(
                'Não foram econtradas restrições para esse CPF. Venda liberada.',
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
              ),
              icon: Icon(Icons.check));
          return true;
        }
      } catch (e, stackTrace) {
        await Sentry.captureException(
          e,
          stackTrace: stackTrace,
        );
        EasyLoading.dismiss();
        this.isValidCpf = true;
        EasyLoading.showError(
            'Não foi possível checar se há pendencias nesse CPF, a venda está liberada nesse primeiro momento.',
            dismissOnTap: false,
            duration: Duration(seconds: 3));
        return true;
      }
    } else {
      Get.snackbar('Aviso', '',
          snackPosition: SnackPosition.TOP,
          duration: Duration(seconds: 7),
          margin: EdgeInsets.all(20),
          backgroundColor: Colors.blue[800],
          colorText: Colors.white,
          messageText: Text(
            'Digite um CPF válido',
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
          ),
          icon: Icon(Icons.warning));
      return false;
    }
  }
}
