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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Selecione o motivo',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  SizedBox(
                    height: 20,
                  ),
                  ListTile(
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
                  ListTile(
                    onTap: () {
                      update('Retorno');
                      Navigator.of(context).pop();
                    },
                    trailing: Icon(Icons.restore_rounded),
                    title: Text(
                      'Retorno',
                      style: GoogleFonts.lato(fontWeight: FontWeight.w500),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      update('Outro');
                      Navigator.of(context).pop();
                    },
                    trailing: Icon(Icons.textsms_outlined),
                    title: Text(
                      'Outro',
                      style: GoogleFonts.lato(fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ));
  }
}
