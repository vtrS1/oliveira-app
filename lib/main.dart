import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:oliveira_fotos/App.routes.dart';
import 'package:oliveira_fotos/app/services/theme.service.dart';
import 'package:oliveira_fotos/app/utils/theme.dart';
import 'app/provider/Db.provider.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting('pt_BR');
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await GetStorage.init();
  DBProvider dbProvider = DBProvider.db;
  // await dbProvider.resetDb();
  await dbProvider.initDB();
  await dbProvider.initTables(2);
  GetStorage box = GetStorage();
  await box.writeIfNull('isDarkMode', false);
  await box.writeIfNull('hasShowIntro', false);

  AppRoutes _appRoutes = new AppRoutes();

  // await SentryFlutter.init((options) {
  //   options.dsn =
  //       'https://4f4b414eb4084f799e5690a3daf0a80e@o1051658.ingest.sentry.io/6034787';
  // },
  //     appRunner: () =>
  runApp(Phoenix(
      child: GetMaterialApp(
    locale: Locale('pt', 'BR'),
    debugShowCheckedModeBanner: false,
    theme: Themes.light,
    darkTheme: Themes.dark,
    themeMode: ThemeService().theme,
    initialRoute: _appRoutes.initial,
    getPages: _appRoutes.routes,
    builder: EasyLoading.init(),
    // navigatorObservers: [
    //   SentryNavigatorObserver(),
    // ],
  ))); //);
}
