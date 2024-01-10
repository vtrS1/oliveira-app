import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oliveira_fotos/app/models/Os.model.dart';

class CardList extends StatelessWidget {
  final Os os;
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  CardList({required this.os});

  Color getColorByStatus(int status) {
    if (status == 1) return Colors.blue[200]!;
    if (status == 2) return Colors.green[200]!;
    if (status == 3) return Colors.red[200]!;
    return Color(0xFFe8e5f3);
  }

  @override
  Widget build(BuildContext context) {
    return new Card(
      borderOnForeground: false,
      margin: EdgeInsets.all(10),
      color: getColorByStatus(os.status!),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Lista ' + os.listasId.toString(),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(
                  dateFormat
                          .format(DateTime.parse(os.listasDataInicio!))
                          .toString() +
                      ' - ' +
                      dateFormat
                          .format(DateTime.parse(os.listasDataConclusao!))
                          .toString(),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                Text('OS ' + os.id.toString(),
                    style: TextStyle(fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 15.0, right: 15, bottom: 10, top: 10),
            child: Text(
              os.pessoasNome!,
              style: TextStyle(fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 15.0, right: 15, bottom: 10, top: 10),
            child: Text(os.address(),
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w500)),
          ),
          statusOs(os)
        ],
      ),
    );
  }
}

Widget statusOs(Os os) {
  if (os.status == 1)
    Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text('Serviço finalizado e não sincronizado'.toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
    );
  if (os.status == 3)
    return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
            'Serviço finalizado e com erros na sincronização'.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)));
  if (os.status == 2)
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Serviço finalizado e sincronizado'.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
        Container(
          padding: EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8), color: Colors.green[600]),
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.credit_card, color: Colors.white),
              SizedBox(
                width: 10,
              ),
              Text('Ver boletos'.toUpperCase(),
                  style: TextStyle(color: Colors.white))
            ],
          ),
        ),
      ],
    );
  return SizedBox();
}
