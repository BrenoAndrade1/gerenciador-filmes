import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../model/filme.dart';

class FilmeDetailScreen extends StatelessWidget {
  final Filme filme;

  FilmeDetailScreen({required this.filme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Filme'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                filme.imagemUrl,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16),
            Text('Título: ${filme.titulo}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Gênero: ${filme.genero}'),
            Text('Faixa Etária: ${filme.faixaEtaria}'),
            Text('Duração: ${filme.duracao} minutos'),
            Text('Ano: ${filme.ano}'),
            SizedBox(height: 8),
            Row(
              children: [
                Text('Pontuação: ', style: TextStyle(fontWeight: FontWeight.bold)),
                RatingBarIndicator(
                  rating: filme.pontuacao,
                  itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
                  itemCount: 5,
                  itemSize: 20,
                  direction: Axis.horizontal,
                ),
              ],
            ),
            SizedBox(height: 16),
            Text('Descrição:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text(filme.descricao),
          ],
        ),
      ),
    );
  }
}
