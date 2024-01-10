import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:oliveira_fotos/app/pages/address/Address.view.dart';
import 'package:oliveira_fotos/app/pages/contacts/Contacts.view.dart';
import 'package:oliveira_fotos/app/pages/detail/camera/camera.binding.dart';
import 'package:oliveira_fotos/app/pages/detail/camera/camera.view.dart';
import 'package:oliveira_fotos/app/pages/detail/detail.view.dart';
import 'package:oliveira_fotos/app/pages/intro/Intro.view.dart';
import 'package:oliveira_fotos/app/pages/listas/Listas.binding.dart';
import 'package:oliveira_fotos/app/pages/listas/Listas.view.dart';
import 'package:oliveira_fotos/app/pages/login/login.view.dart';
import 'package:oliveira_fotos/app/pages/main.binding.dart';
import 'package:oliveira_fotos/app/pages/main.view.dart';
import 'package:oliveira_fotos/app/pages/os/Os.view.dart';
import 'package:oliveira_fotos/app/pages/os/os.binding.dart';
import 'package:oliveira_fotos/app/pages/partials/partialoffline.view.dart';
import 'package:oliveira_fotos/app/pages/partials/partials.binding.dart';
import 'package:oliveira_fotos/app/pages/partials/partials.view.dart';
import 'package:oliveira_fotos/app/pages/payment/payment.binding.dart';
import 'package:oliveira_fotos/app/pages/payment/payment.view.dart';
import 'package:oliveira_fotos/app/pages/profile/Profile.binding.dart';
import 'package:oliveira_fotos/app/pages/profile/Profile.view.dart';
import 'package:oliveira_fotos/app/pages/settings/Settings.binding.dart';
import 'package:oliveira_fotos/app/pages/settings/Settings.view.dart';
import 'package:oliveira_fotos/app/pages/upload/upload.binding.dart';
import 'package:oliveira_fotos/app/pages/upload/upload.view.dart';

// import 'app/pages/qr/qr.view.dart';

const String LOGIN_ROUTE = '/login';
const String DETAIL_ROUTE = '/detail';
const String CAMERA_ROUTE = '/camera';
const String REPORT_ROUTE = '/report';
const String SETTINGS_ROUTE = '/settings';
const String PREVIEW_ROUTE = '/preview';
const String ENVIAR_ROUTE = '/enviar';
const String LISTAS_ROUTE = '/listas';
const String PROFILE_ROUTE = '/profile';
const String OS_ROUTE = '/os';
const String PAYMENT_ROUTE = '/payment';
const String PARTIAL_ROUTE = '/partials';
const String PARTIAL_OFFLINE_ROUTE = '/partials-offline';
const String QR_ROUTE = '/qr';
const String MAIN_ROUTE = '/';
const String INTRO_ROUTE = '/intro';
const String ADDRESS_ROUTE = '/address';
const String CONTACTS_ROUTE = '/contacts';

var box = GetStorage();

class AppRoutes {
  String initial = box.read('cpf') == null ? LOGIN_ROUTE : MAIN_ROUTE;

  // AppRoutes() {
  //   if (initial == MAIN_ROUTE) {
  //     initial = INTRO_ROUTE;
  //   }
  // }

  List<GetPage> routes = [
    GetPage(name: MAIN_ROUTE, page: () => MainView(), binding: MainBinding()),
    GetPage(
      name: PROFILE_ROUTE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
        name: SETTINGS_ROUTE,
        page: () => SettingsView(),
        binding: SettingsBinding()),
    GetPage(name: LOGIN_ROUTE, page: () => LoginView()),
    GetPage(name: OS_ROUTE, page: () => OsView(), binding: OsViewBinding()),
    GetPage(
        name: ENVIAR_ROUTE, page: () => UploadView(), binding: UploadBinding()),
    GetPage(
        name: LISTAS_ROUTE, page: () => ListaView(), binding: ListasBinding()),
    GetPage(
      name: DETAIL_ROUTE,
      page: () => DetailView(),
    ),
    GetPage(
      name: ADDRESS_ROUTE,
      page: () => AddressView(),
    ),
    GetPage(
      name: CONTACTS_ROUTE,
      page: () => ContactsView(),
    ),

    GetPage(
      name: INTRO_ROUTE,
      page: () => IntroAppView(),
    ),
    GetPage(
        name: CAMERA_ROUTE, page: () => CameraView(), binding: CameraBinding()),
    GetPage(
        name: PAYMENT_ROUTE,
        page: () => PaymentView(),
        binding: PaymentBinding()),
    GetPage(
        name: PARTIAL_ROUTE,
        page: () => PartialView(),
        binding: PartialsViewBinding()),
    GetPage(
      name: PARTIAL_OFFLINE_ROUTE,
      page: () => PartialOfflineView(),
    ),
    // GetPage(name: QR_ROUTE, page: () => QRViewPage()),
    // GetPage(name: HOME_ROUTE, page: () => HomeView())
  ];
}
