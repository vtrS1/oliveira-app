import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> sairSalvarModal(
    BuildContext context, Function sairSemSalvar, Function sairSalvar) async {
  return showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
          title: Text(
            'Você ainda não salvou esse conteúdo',
            style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400),
          ),
          actions: [
            CupertinoActionSheetAction(
                child: Text('Sair sem salvar'),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            CupertinoActionSheetAction(
                child: Text('Salvar e sair'),
                onPressed: () {
                  sairSalvar();
                  Navigator.of(context).pop();
                }),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: const Text('Cancelar'),
            // isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
          )));
}
