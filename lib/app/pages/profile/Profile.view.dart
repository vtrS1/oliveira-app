import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oliveira_fotos/app/pages/profile/Profile.controller.dart';
import 'package:oliveira_fotos/app/pages/signature/SignaturePreview.view.dart';
import 'package:oliveira_fotos/app/pages/signature/SignaturePreviewTestemunha.view.dart';
import 'package:oliveira_fotos/app/pages/signature/SignatureTestemunha.view.dart';
import 'package:oliveira_fotos/app/pages/signature/signatureVendedor.view.dart';

class ProfileView extends StatelessWidget {
  final ProfileController controller =
      Get.put<ProfileController>(ProfileController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Meu perfil', style: Get.theme.appBarTheme.titleTextStyle),
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Colors.black87),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
                onPressed: () async {
                  await Get.find<ProfileController>().fetchProfile();
                },
                icon: Icon(FeatherIcons.refreshCcw)),
          )
        ],
      ),
      body: Center(
        child: Obx(() {
          if (Get.find<ProfileController>().isCompleted.value) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: MediaQuery.of(context).size.width * 0.18,
                    child: Icon(
                      FeatherIcons.user,
                      size: MediaQuery.of(context).size.width * 0.16,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(Get.find<ProfileController>().vendedor.value.nome ?? '',
                    style: GoogleFonts.lato(
                        fontSize: 24, fontWeight: FontWeight.w600)),
                Text(Get.find<ProfileController>().vendedor.value.cpf ?? '',
                    style: GoogleFonts.lato(
                        fontSize: 20, fontWeight: FontWeight.w300)),
                SizedBox(
                  height: 10,
                ),
                Get.find<ProfileController>().vendedor.value.assinatura != null
                    ? GestureDetector(
                        onTap: () async {
                          Get.to(() => SignaturePreview());
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.blue[500],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Ver assinatura (Vendedor)',
                                  style: Get.textTheme.bodyText1!.copyWith(
                                      fontSize: 18, color: Colors.white)),
                              Icon(Icons.gesture,
                                  color: Colors.white, size: 30),
                            ],
                          ),
                        ),
                      )
                    : SizedBox(),
                SizedBox(
                  height: 10,
                ),
                Get.find<ProfileController>()
                            .vendedor
                            .value
                            .assinaturaTestemunha !=
                        null
                    ? GestureDetector(
                        onTap: () async {
                          Get.to(() => SignaturePreviewTestemunha());
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.blue[500],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Ver assinatura (Testemunha)',
                                  style: Get.textTheme.bodyText1!.copyWith(
                                      fontSize: 18, color: Colors.white)),
                              Icon(Icons.gesture,
                                  color: Colors.white, size: 30),
                            ],
                          ),
                        ),
                      )
                    : SizedBox(),
                SizedBox(
                  height: 10,
                ),
                Divider(),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () async {
                    // print(box.read('vendedor'));
                    Get.to(() => SignatureVendedorView())!.then((value) =>
                        Get.find<ProfileController>().fetchProfile());
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.green[500],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Cadastrar assinaura (Vendedor)',
                            style: Get.textTheme.bodyText1!
                                .copyWith(fontSize: 18, color: Colors.white)),
                        Icon(Icons.brush, color: Colors.white, size: 30),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () async {
                    // print(box.read('vendedor'));
                    Get.to(() => SignatureTestemunhaView())!.then((value) =>
                        Get.find<ProfileController>().fetchProfile());
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.green[500],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Cadastrar assinatura (Testemunha)',
                            style: Get.textTheme.bodyText1!
                                .copyWith(fontSize: 18, color: Colors.white)),
                        Icon(Icons.brush, color: Colors.white, size: 30),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            );
          }
          if (Get.find<ProfileController>().isCompleted.value) {
            return Text('Ocorreu um erro');
          }
          return Center(child: CircularProgressIndicator());
        }),
      ),
    ));
  }
}
