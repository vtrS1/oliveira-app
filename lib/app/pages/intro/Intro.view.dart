import 'package:flare_loading/flare_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:oliveira_fotos/App.routes.dart';
import 'package:oliveira_fotos/app/models/Vendedor.model.dart';
import 'package:oliveira_fotos/app/pages/intro/fullimage.view.dart';
import 'package:oliveira_fotos/app/pages/settings/Settings.controller.dart';

class IntroAppView extends StatefulWidget {
  static const TextStyle goldcoinGreyStyle = TextStyle(
      color: Colors.grey,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      fontFamily: "Product Sans");

  static const TextStyle goldCoinWhiteStyle = TextStyle(
      color: Colors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      fontFamily: "Product Sans");

  static const TextStyle greyStyle =
      TextStyle(fontSize: 40.0, color: Colors.grey, fontFamily: "Product Sans");
  static const TextStyle whiteStyle = TextStyle(
      fontSize: 40.0, color: Colors.white, fontFamily: "Product Sans");

  static const TextStyle boldStyle = TextStyle(
    fontSize: 40.0,
    color: Colors.black,
    fontFamily: "Product Sans",
    fontWeight: FontWeight.bold,
  );

  static const TextStyle descriptionGreyStyle = TextStyle(
    color: Colors.grey,
    fontSize: 24.0,
    fontFamily: "Product Sans",
  );

  static const TextStyle descriptionWhiteStyle = TextStyle(
    color: Colors.white,
    fontSize: 20.0,
    fontFamily: "Product Sans",
  );

  @override
  _IntroAppViewState createState() => _IntroAppViewState();
}

class _IntroAppViewState extends State<IntroAppView> {
  GetStorage box = GetStorage();
  late Vendedor vendedor;

  @override
  initState() {
    super.initState();
    var data = box.read("vendedor");
    if (data != null) {
      vendedor = new Vendedor();
      vendedor = Vendedor.fromJson(data);
    } else {
      vendedor = new Vendedor();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          body: LiquidSwipe(
            pages: getPages(context, vendedor),
            enableLoop: false,
            fullTransitionValue: 300,
            waveType: WaveType.liquidReveal,
            positionSlideIcon: 0.5,
            enableSideReveal: true,
          ),
        ),
      ),
    );
  }
}

List<Widget> getPages(BuildContext context, Vendedor vendedor) {
  return [
    Container(
      color: Colors.white,
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Olá ${vendedor.id == null ? 'vendedor(a)' : vendedor.nome}",
                  style: IntroAppView.boldStyle,
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  '''Atualizamos algumas coisas por aqui, avance para conhecer as novidades''',
                  style: IntroAppView.descriptionGreyStyle,
                ),
                Center(
                  child: FlareLoading(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.width * 0.5,
                    name: 'assets/swipeleft.flr',
                    loopAnimation: 'Animations',
                    isLoading: true,
                    onSuccess: (_) {
                      print('Finished');
                    },
                    onError: (err, stack) {
                      print(err);
                    },
                  ),
                )
              ])),
    ),
    Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Color(0xFFdcf4ee),
      child: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(height: 10),
              Center(
                child: Text(
                  "Veja somente o que interessa".toUpperCase(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      fontSize: 20, color: Color(0xFF23232c)),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 10.0),
                width: MediaQuery.of(context).size.width,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                child: GestureDetector(
                  onTap: () {
                    Get.to(FullImageView(imageUrl: 'assets/news/news1.gif'));
                  },
                  child: Image.asset(
                    'assets/news/news1.gif',
                  ),
                ),
              ),
              Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.5,
                  ),
                  margin: EdgeInsets.all(30),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    color: Color(0xFF23232c),
                  ),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      "Agora você pode filtrar as Os pelo status",
                      textAlign: TextAlign.center,
                      style: IntroAppView.boldStyle
                          .copyWith(fontSize: 34, color: Colors.white),
                    ),
                    Text(
                      '(Clique no vídeo para ver em tela cheia)',
                      style: IntroAppView.descriptionGreyStyle
                          .copyWith(fontSize: 18, color: Colors.grey[200]),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Center(
                      child: FlareLoading(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.width * 0.14,
                        name: 'assets/swipeleft.flr',
                        loopAnimation: 'Animations',
                        isLoading: true,
                        onSuccess: (_) {
                          print('Finished');
                        },
                        onError: (err, stack) {
                          print(err);
                        },
                      ),
                    )
                  ]))
            ]),
      ),
    ),
    Container(
        color: Color(0xFFf8efd2),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SizedBox(height: 10),
                Center(
                  child: Text(
                    "Consulte Irregularidades".toUpperCase(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        fontSize: 20, color: Color(0xFF23232c)),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10.0),
                  width: MediaQuery.of(context).size.width,
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.45,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Get.to(FullImageView(imageUrl: 'assets/news/news2.gif'));
                    },
                    child: Image.asset(
                      'assets/news/news2.gif',
                    ),
                  ),
                ),
                Container(
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      color: Color(0xFF23232c),
                    ),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        "Consulte se há alguma restrição para o CPF do sacado",
                        textAlign: TextAlign.center,
                        style: IntroAppView.boldStyle
                            .copyWith(fontSize: 34, color: Colors.white),
                      ),
                      Text(
                        "Se houver alguma restrição a venda não será liberada. Você pode consultar como mostrado no vídeo ou na tela de pagamento.",
                        textAlign: TextAlign.center,
                        style: IntroAppView.boldStyle.copyWith(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w300),
                      ),
                      Text(
                        '\n(Clique no vídeo para ver em tela cheia)',
                        style: IntroAppView.descriptionGreyStyle
                            .copyWith(fontSize: 18, color: Colors.grey[200]),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        height: 80,
                        margin: const EdgeInsets.symmetric(vertical: 20.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            try {
                              await SettingsController().updateFormaPagamento();
                              await box.write('hasShowIntro', true);
                            } catch (e) {
                              print(e);
                            } finally {
                              Get.offAllNamed(MAIN_ROUTE);
                            }
                          },
                          autofocus: true,
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Color(0xFF005ede)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ))),
                          child: Center(
                              child: Text(
                            'Ir para os serviços'.toUpperCase(),
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 16),
                          )),
                        ),
                      ),
                    ]))
              ]),
        )),
  ];
}
