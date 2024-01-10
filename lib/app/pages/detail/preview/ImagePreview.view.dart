import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oliveira_fotos/app/models/Image.model.dart';
import 'package:oliveira_fotos/app/repository/Image.repository.dart';

class ImagePreview extends StatefulWidget {
  final ImageModel image;
  final bool signature;

  ImagePreview(this.image, {this.signature = false});

  @override
  _ImagePreviewState createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          widget.signature ? Colors.white : Get.theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Imagem',
          style: Get.theme.appBarTheme.titleTextStyle,
        ),
        centerTitle: true,
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 10),
              child: IconButton(
                onPressed: () async {
                  await ImageRepository().delete(widget.image.id);
                  await File(widget.image.src!).delete();
                  Navigator.pop(context);
                },
                icon: Icon(Icons.delete),
                color: Colors.redAccent[200],
              ))
        ],
      ),
      body: Container(
        child: Center(
          child: Image.file(File(widget.image.src!)),
        ),
      ),
    );
  }
}
