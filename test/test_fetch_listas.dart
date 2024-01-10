import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oliveira_fotos/app/pages/listas/Listas.view.dart';

Future<void> _createWidget(WidgetTester tester) async {
  await tester.pumpWidget(ListaView());
}

void main() {
  testWidgets('Testando recuperação de listas do vendedor',
      (WidgetTester tester) async {
    await _createWidget(tester);

    expect(find.byKey(Key('item_lista')), findsWidgets);
  });
}
