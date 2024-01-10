import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class TextDivider extends StatelessWidget {
  final String title;

  TextDivider({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 20, bottom: 10),
        child: Text(
          title,
          style: GoogleFonts.lato(
              color: Get.textTheme.bodyText2!.color, fontSize: 16),
        ));
  }
}
