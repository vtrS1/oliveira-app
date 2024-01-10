import 'package:flutter/material.dart';

class FullImageView extends StatefulWidget {
  final String imageUrl;
  FullImageView({Key? key, required this.imageUrl}) : super(key: key);

  @override
  _FullImageViewState createState() => _FullImageViewState();
}

class _FullImageViewState extends State<FullImageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text('Novidade', style: TextStyle(color: Colors.black)),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Image.asset(widget.imageUrl, fit: BoxFit.cover)),
        ));
  }
}
