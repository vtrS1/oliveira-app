class Constants {
  static const String DB_IMAGES = 'images';
  static const String DB_OS = 'os';
  static const String DB_CONTATOS = 'contatos';
  static const String DB_CONTATOS_UPDATE = 'contatos_update';
  static const String DB_FORMA_PAGAMENTOS = 'forma_pagamentos';
  static const String DB_PARCELAS = 'parcelas';
  static const String DB_BOLETOS = 'boletos';
  static const String DB_RESPONSAVEL = 'responsaveis';
  static const String DB_NEGATIVADOS = 'negativados';
  static const String DB_ESTADOS = 'estados';
  static const String DB_CIDADES = 'cidades';
  static const String DB_ENDERECOS = 'enderecos';
  static const String DB_PARAMETROS = 'enderecos';
  static const String DB_TIPO_CONTATOS = 'tipo_contatos';

  static const String KIT = 'kit';
  static const String ALBUM = 'album';

  static const String TIPO_ASSINATURA = 'assinatura';
  static const String TIPO_RG = 'rg';
  static const String TIPO_CPF = 'cpf';
  static const String TIPO_COMP_RESIDENCIA = 'comp.Residência';
  static const String TIPO_ASSINATURA_DIGITAL = 'assinaturaDigital';
  static const String TIPO_ASSINATURA_DIGITAL_T1 =
      'assinaturaDigitalTestemunha1';
  static const String TIPO_ASSINATURA_DIGITAL_T2 =
      'assinaturaDigitalTestemunha2';

  // Prod
  static const String API_HOST = 'https://oliveira.anc-app.xyz/';
  static const String WS_HOST = 'oliveira.anc-app.xyz';
  static const String API_HOST_SYNC =
      'https://ancweb.com.br/oliveira/oneSync.php';

  // Homo
  // static const String API_HOST = 'http://anc-app.xyz:3334/';
  // static const String WS_HOST = 'anc-app.xyz:3334';

  // Dev
  // static const String API_HOST_SYNC =
  //     'http://192.168.25.6/oliveira/oneSyncDev.php';
  // static const String API_HOST = 'http://192.168.25.6:3333/';
  // static const String WS_HOST = '192.168.25.6';

  static const String UPLOAD_HOST = 'http://ancweb.com.br/oliveira/';

  static const double VALOR_MIN_PARCELA = 0;
  static const String APP_VERSION = '1.71';

  static const int ID_BOLETO = 1;

  static const String OTK_KEY = 'JPANCOLIVEIRAAPP';

  static const String APP_SERVER_URL =
      'https://play.google.com/store/apps/details?id=com.sylkat.apache&hl=pt_BR&gl=BR';
  static const String APP_BOLETO_RENDER = UPLOAD_HOST + 'boleto.zip';
  static const String APP_PLAYLIST_HELP =
      'https://youtube.com/playlist?list=PLv0olcjQKnbQJcFWEzO9Wa2br9n-2k6dh';
}

List<double> formatMoney(double valor, int qtd) {
  List<double> valores = [];
  if (qtd > 0) {
    int valorInteiro = valor ~/ qtd;
    double resto = valor - (qtd * valorInteiro);
    for (int i = 0; i <= qtd; i++) {
      valores.add(double.parse(valorInteiro.toString()));
    }
    valores[valores.length - 1] =
        (valorInteiro + double.parse(resto.toStringAsFixed(2)));
  }
  return valores;
}
