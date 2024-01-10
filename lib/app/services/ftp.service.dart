// import 'dart:io';
// import 'package:intl/intl.dart';
// import 'package:ftpconnect/ftpconnect.dart';
// import 'package:oliveira_fotos/app/models/image.model.dart';
// import 'package:oliveira_fotos/app/utils/consts.dart';

// class FtpService {
//   String year;
//   String month;
//   String day;

//   FTPConnect ftpConnect;

//   FtpService() {
//     this.year = getCurrentYear();
//     this.month = getCurrentMonth();
//     this.day = getCurrentDay();
//     this.ftpConnect = FTPConnect(Constants.FTP_HOST,
//         user: Constants.FTP_USER,
//         pass: Constants.FTP_PASS,
//         port: Constants.FTP_PORT,
//         timeout: 30,
//         debug: false);
//   }

//   Future connect() async {
//     await ftpConnect.connect();
//   }

//   Future upload(ImageModel image) async {
//     File file = File(image.src);

//     try {
//       print("-> Fazendo upload - ${image.src}");
//       //await changeDir('/${image.tipo}-${image.contrato}-${image.numero}');
//       await ftpConnect.uploadFileWithRetry(file, pRetryCount: 3);
//       //await changeDir('/');
//       return true;
//     } catch (e, stackTrace) {
      //  await Sentry.captureException(
      //   e,
      //   stackTrace: stackTrace,
      // );
//       return false;
//     }
//   }

//   createDirUpload() async {
//     await createDir('$year');
//     await createDir('$year/$month');
//     await createDir('$year/$month/$day');
//   }

//   createDir(String dirName) async {
//     await ftpConnect.createFolderIfNotExist(dirName);
//   }

//   changeDir(String dir) async {
//     ftpConnect.changeDirectory(dir);
//   }

//   rename(String original, String newName) async {
//     await ftpConnect.rename(original, newName);
//   }

//   String getCurrentMonth() {
//     final DateTime now = DateTime.now();
//     final DateFormat formatter = DateFormat('MM');
//     return formatter.format(now);
//   }

//   String getCurrentDay() {
//     final DateTime now = DateTime.now();
//     final DateFormat formatter = DateFormat('dd');
//     return formatter.format(now);
//   }

//   String getCurrentYear() {
//     final DateTime now = DateTime.now();
//     final DateFormat formatter = DateFormat('yyyy');
//     return formatter.format(now);
//   }

//   Future disconnect() async {
//     await ftpConnect.disconnect();
//   }
// }
