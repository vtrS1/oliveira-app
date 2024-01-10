import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:oliveira_fotos/app/pages/settings/Settings.controller.dart';

class MainController extends GetxController {
  RxInt currentIndex = 0.obs;

  Rx<PageController> pageController =
      new PageController(initialPage: 0, keepPage: true).obs;

  setCurrent(int current) {
    this.currentIndex.value = current;
    this.pageController.value.jumpToPage(current);
    update();
  }

  @override
  void onInit() {
    super.onInit();
    // new SettingsController().updateFormaPagamento();
  }
}
