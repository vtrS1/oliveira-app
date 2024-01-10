import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oliveira_fotos/app/pages/profile/Profile.controller.dart';

class SignaturePreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Minha assinatura',
          style: Get.theme.appBarTheme.titleTextStyle,
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () async {
              Get.back();
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: Container(
        child: Obx(() => Center(
                child: Image(
              image: NetworkImage(
                  Get.find<ProfileController>().vendedor.value.assinatura! +
                      '?uid=' +
                      new DateTime.now().toString()),
            ))),
      ),
    );
  }
}
