import 'package:flutter/material.dart';

class Themes {
  static final light = ThemeData.light().copyWith(
      backgroundColor: Color(0xFFEFEFF4),
      scaffoldBackgroundColor: Color(0xFFEFEFF4),
      cardColor: Colors.grey[600],
      appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFFEFEFF4),
          titleTextStyle: TextStyle(color: Colors.black, fontFamily: 'Poppins'),
          elevation: 0,
          actionsIconTheme: IconThemeData(color: Colors.black),
          iconTheme: IconThemeData(color: Colors.black)));
  static final dark = ThemeData.dark().copyWith(
      backgroundColor: Colors.black,
      scaffoldBackgroundColor: Colors.black,
      cardColor: Colors.white,
      textTheme: TextTheme(bodyText1: TextStyle(color: Colors.white)),
      appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          titleTextStyle: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
          elevation: 0,
          actionsIconTheme: IconThemeData(color: Colors.white),
          iconTheme: IconThemeData(color: Colors.white)));
}
