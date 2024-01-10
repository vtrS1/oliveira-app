import 'package:flutter/material.dart';

class BtnHome extends StatelessWidget {
  final String title;
  final Function function;
  final Color color;
  final double height;

  BtnHome(
      {required this.title,
      required this.function,
      required this.color,
      this.height = 80.0});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(10),
        height: height,
        width: MediaQuery.of(context).size.width,
        decoration:
            BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
        child: TextButton(
          child: Text(title.toUpperCase(),
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 25,
                  color: Colors.white)),
          onPressed: function as void Function()?,
        ));
  }
}
