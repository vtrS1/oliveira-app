import 'package:oliveira_fotos/app/models/Os.model.dart';

class OsController {
  List<Os> dbToList(List<Map<dynamic, dynamic>> res) {
    List<Os> images = <Os>[];
    for (int i = 0; i < res.length; i++) {
      images.add(Os.fromJson(res[i] as Map<String, dynamic>));
    }
    return images;
  }
}
