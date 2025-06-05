import 'package:flutter/material.dart';
import 'screens/filmes_list.dart';

void main() {
  runApp(FilmesApp());
}

class FilmesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro de Filmes',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity, // <--- Linha corrigida aqui
      ),
      debugShowCheckedModeBanner: false,
      home: FilmesListScreen(),
    );
  }
}
adicionando main.dart
