import 'package:flutter/material.dart';
import 'pesquisar_apps/pesquisar_apps.dart';

void main() {
  runApp(const ButiaAppsApp());
}

class ButiaAppsApp extends StatelessWidget {
  const ButiaAppsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Butiáapps',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: const PesquisarAppsPage(),
    );
  }
}