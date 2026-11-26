import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:catalogo_mobile/main.dart';
import 'package:catalogo_mobile/widgets/butia_header.dart';

void main() {
  testWidgets('ButiaAppsApp renders mobile layout with bottom nav and logo', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ButiaAppsApp());

    // Verifica que a logo e o nome estão no cabeçalho superior
    expect(find.byType(ButiaLogo), findsOneWidget);
    expect(find.text('Butiápps'), findsOneWidget);

    // Verifica a navbar inferior com Aplicativos e Desenvolvedores
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('Aplicativos'), findsWidgets);
    expect(find.text('Desenvolvedores'), findsOneWidget);

    // Verifica a barra de pesquisa, botão de ordenação e dropdown de precificação
    expect(find.byType(SearchBar), findsOneWidget);
    expect(find.text('Ordenar (Nota)'), findsOneWidget);
    expect(find.text('Precificação (Todas)'), findsOneWidget);

    // Alterna ordenação para Nome
    await tester.tap(find.text('Ordenar (Nota)'));
    await tester.pump();
    expect(find.text('Ordenar (Nome)'), findsOneWidget);
  });
}
