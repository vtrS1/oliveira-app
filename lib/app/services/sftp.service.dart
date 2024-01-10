// import 'package:oliveira_fotos/app/utils/consts.dart';
// import 'package:ssh/ssh.dart';

// class SftpService {
//   SSHClient client = new SSHClient(
//     host: Constants.FTP_HOST,
//     port: 22, //Constants.FTP_PORT,
//     username: Constants.FTP_USER,
//     passwordOrKey: Constants.FTP_PASS,
//   );

//   String status = "";
//   String statusSftp = "";

//   Future connect() async {
//     this.status = await client.connect();
//     if (this.status != "session_connected") {
//       print("FuncConnect: SSH não conectado");
//     }
//   }

//   Future connectSftp() async {
//     if (this.status == "session_connected") {
//       this.statusSftp = await client.connectSFTP();
//     } else {
//       print("FuncConnectSFTP: SSH não conectado");
//     }
//   }

//   Future upload(String filePath,
//       {String dirPath = ".", bool debug = false}) async {
//     await client.sftpUpload(
//       path: filePath,
//       toPath: dirPath,
//       callback: (progress) {
//         if (debug) print(progress); // read upload progress
//       },
//     );
//   }

//   Future createDir(String dirName) async {
//     return await client.sftpMkdir(dirName);
//   }

//   Future execute(String command) async {
//     return await client.execute(command);
//   }

//   Future close() async {
//     if (this.status == 'session_connected') {
//       await client.disconnect();
//     }
//     if (this.statusSftp == 'session_connected') {
//       await client.disconnectSFTP();
//     }
//   }
// }
