import 'package:flutter/material.dart';

class ErrorMessageWidget extends StatelessWidget {
  final String message;

  ErrorMessageWidget({this.message = 'Ocorreu um erro'});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset('assets/cancel.png'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20,
                color: Colors.black87,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400),
          ),
        )
      ],
    ));
  }
}
