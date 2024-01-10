import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectMotivoWidget extends StatelessWidget {
  final Function update;

  SelectMotivoWidget({required this.update});
  @override
  Widget build(BuildContext context) {
    return BottomSheet(
        onClosing: () {},
        builder: (context) => Container(
              padding: EdgeInsets.all(15),
              child: ListView.builder(
                itemBuilder: (context, index) => ListTile(
                  onTap: () {
                    update('Recusado');
                    Navigator.of(context).pop();
                  },
                  trailing: Icon(Icons.not_interested),
                  title: Text(
                    'Recusado',
                    style: GoogleFonts.lato(fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ));
  }
}
