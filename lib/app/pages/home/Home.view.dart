// import 'package:custom_navigation_bar/custom_navigation_bar.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:oliveira_fotos/app/pages/home/Home.controller.dart';
// import 'package:oliveira_fotos/app/pages/listas/Listas.controller.dart';
// import 'package:oliveira_fotos/app/pages/listas/Listas.view.dart';
// import 'package:oliveira_fotos/app/pages/profile/Profile.view.dart';
// import 'package:oliveira_fotos/app/pages/qr/qr.view.dart';
// import 'package:oliveira_fotos/app/pages/settings/Settings.view.dart';
// import 'package:oliveira_fotos/app/pages/upload/upload.view.dart';

// class HomeView extends StatefulWidget {
//   @override
//   _HomeViewState createState() => _HomeViewState();
// }

// class _HomeViewState extends State<HomeView> {
//   HomeController homeController = Get.put<HomeController>(HomeController());
//   ListaController listaController = Get.put<ListaController>(ListaController());
//   PageController pageController = new PageController(initialPage: 0);
//   int currentIndex = 0;

//   Widget buildOriginDesign() {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12.0),
//       child: CustomNavigationBar(
//         iconSize: 30.0,
//         selectedColor: Colors.white,
//         elevation: 2.0,
//         isFloating: true,
//         borderRadius: Radius.circular(10),
//         blurEffect: false,
//         strokeColor: Colors.white,
//         unSelectedColor: Color(0xff6c788a),
//         backgroundColor: Color(0xff040307),
//         items: [
//           CustomNavigationBarItem(
//             icon: Icon(Icons.list),
//           ),
//           CustomNavigationBarItem(
//             icon: Icon(Icons.upload_file),
//           ),
//           CustomNavigationBarItem(
//             icon: Icon(Icons.person),
//           ),
//           CustomNavigationBarItem(
//             icon: Icon(Icons.settings),
//           ),
//         ],
//         currentIndex: currentIndex,
//         onTap: (index) {
//           setState(() {
//             currentIndex = index;
//             pageController.jumpToPage(index);
//           });
//         },
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFEFEFF4),
//       bottomNavigationBar: buildOriginDesign(),
//       body: PageView(
//         controller: pageController,
//         physics: NeverScrollableScrollPhysics(),
//         children: [ListaView(), UploadView(), ProfileView(), SettingsView()],
//       ),
//     );
//   }
// }
