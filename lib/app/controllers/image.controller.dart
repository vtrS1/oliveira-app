import 'package:oliveira_fotos/app/models/Image.model.dart';

class ImageController {
  List<ImageModel> dbToList(List<Map<dynamic, dynamic>> res) {
    List<ImageModel> images = <ImageModel>[];
    for (int i = 0; i < res.length; i++) {
      images.add(ImageModel.fromJson(res[i] as Map<String, dynamic>));
    }
    return images;
  }
}
