import 'package:dio/dio.dart';
import 'package:oliveira_fotos/app/utils/consts.dart';

class Connection {
  static const String ApiUrl = Constants.UPLOAD_HOST;

  Future get(String url, {bool debug = false, bool body = false}) async {
    var result = await Dio().get('$ApiUrl$url');
    if (debug) errors(result, body: body);
    if (validCode(result.statusCode)) return result;
    return null;
  }

  Future getWithOutToken(String url,
      {bool debug = false, bool body = false}) async {
    var result = await Dio().get('$ApiUrl$url');
    if (debug) errors(result, body: body);
    if (validCode(result.statusCode)) return result;
    return null;
  }

  Future getStatusCode(String url,
      {bool debug = false, bool body = false}) async {
    var result = await Dio().get('$ApiUrl$url');
    if (debug) errors(result, body: body);
    return validCode(result.statusCode);
  }

  Future post(String url, Map data,
      {bool debug = false, bool body = false}) async {
    var result = await Dio().post('$ApiUrl$url');
    if (debug) errors(result, body: body);
    if (validCode(result.statusCode)) return result;

    return null;
  }

  Future postWithOutToken(String url, Map data,
      {bool debug = false, bool body = false}) async {
    var result = await Dio().post('$ApiUrl$url', data: data);
    print(result.data);
    if (debug) errors(result, body: body);
    //if (validCode(result.statusCode))
    return result;
  }

  Future<Response> postSimple(String url, dynamic data,
      {bool debug = false, bool body = false}) async {
    Response result = await Dio().post(url, data: data);
    print(result.data);
    if (debug) errors(result, body: body);
    //if (validCode(result.statusCode))
    return result;
  }

  Future delete(String url, {bool debug = false, bool body = false}) async {
    var result = await Dio().delete('$ApiUrl$url');
    if (debug) errors(result, body: body);
    if (validCode(result.statusCode)) return result;
    return null;
  }

  bool validCode(int? statusCode) {
    if (statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  void errors(result, {bool body = false}) {
    print("REQUEST -->");
    print(result.request.baseUrl);
    print(result.request.headers);
    print(result.request.data);
    print("RESPONSE -->");
    print(result.statusCode);
    print(result.statusMessage);
    if (body) print(result.data);
  }
}
