import 'package:flutter/material.dart';
import 'package:veiculos/pages/veiculos/veiculos.page.dart';

void main() {
  runApp(VeiculosApp());
}

class VeiculosApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro de Veículos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: VeiculosPage(),
    );
  }
}