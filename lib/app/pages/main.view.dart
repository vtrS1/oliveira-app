import 'package:flutter/material.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:get/get.dart';
import 'package:oliveira_fotos/app/pages/listas/Listas.view.dart';
import 'package:oliveira_fotos/app/pages/main.controller.dart';
import 'package:oliveira_fotos/app/pages/profile/Profile.view.dart';
import 'package:oliveira_fotos/app/pages/settings/Settings.view.dart';
import 'package:oliveira_fotos/app/pages/upload/upload.view.dart';

class MainView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        bottomNavigationBar: Obx(() => DotNavigationBar(
              currentIndex: Get.find<MainController>().currentIndex.value,
              onTap: (current) {
                Get.find<MainController>().setCurrent(current);
              },
              dotIndicatorColor: Colors.black,
              // enableFloatingNavBar: false,
              unselectedItemColor: Colors.black,
              items: [
                DotNavigationBarItem(
                  icon: Icon(Icons.home),
                  selectedColor: Colors.blue,
                ),

                /// Likes
                DotNavigationBarItem(
                  icon: Icon(Icons.sync),
                  selectedColor: Colors.pink,
                ),

                /// Search
                DotNavigationBarItem(
                  icon: Icon(Icons.person),
                  selectedColor: Colors.orange,
                ),

                /// Profile
                DotNavigationBarItem(
                  icon: Icon(Icons.settings),
                  selectedColor: Colors.teal,
                ),
              ],
            )),
        body: WillPopScope(
          onWillPop: () async => false,
          child: Obx(() => Container(
                  child: PageView(
                controller: Get.find<MainController>().pageController.value,
                physics: NeverScrollableScrollPhysics(),
                onPageChanged: Get.find<MainController>().setCurrent,
                children: [
                  ListaView(),
                  UploadView(),
                  ProfileView(),
                  SettingsView()
                ],
              ))),
        ));
  }
}
