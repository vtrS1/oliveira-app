import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset('assets/empty.png'),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              "Nenhuma OS disponível,\ntente novamente mais tarde",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.black87,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400),
            ))
      ],
    ));
  }
}
