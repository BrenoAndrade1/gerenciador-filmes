import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../model/filme.dart';
import '../db/filme_dao.dart';
import 'filme_form.dart';
import 'filme_detail.dart';

class FilmesListScreen extends StatefulWidget {
  @override
  _FilmesListScreenState createState() => _FilmesListScreenState();
}

class _FilmesListScreenState extends State<FilmesListScreen> {
  final FilmeDAO _dao = FilmeDAO();
  List<Filme> _filmes = [];

  @override
  void initState() {
    super.initState();
    _carregarFilmes();
  }

  Future<void> _carregarFilmes() async {
    final filmes = await _dao.getAll();
    setState(() {
      _filmes = filmes;
    });
  }

  void _mostrarOpcoes(Filme filme) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: [
          ListTile(
            leading: Icon(Icons.visibility),
            title: Text('Exibir Dados'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FilmeDetailScreen(filme: filme),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Alterar'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FilmeFormScreen(filme: filme),
                ),
              ).then((_) => _carregarFilmes());
            },
          ),
        ],
      ),
    );
  }

  void _mostrarAlertaGrupo() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Nome do Grupo'),
        content: Text('Grupo: ADS - Flutter 2025'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          )
        ],
      ),
    );
  }

  void _removerFilme(int id) async {
    await _dao.delete(id);
    _carregarFilmes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filmes'),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: _mostrarAlertaGrupo,
          )
        ],
      ),
      body: ListView.builder(
        itemCount: _filmes.length,
        itemBuilder: (context, index) {
          final filme = _filmes[index];
          return Dismissible(
            key: Key(filme.id.toString()),
            background: Container(color: Colors.red),
            direction: DismissDirection.startToEnd,
            onDismissed: (direction) => _removerFilme(filme.id!),
            child: ListTile(
              leading: Image.network(
                filme.imagemUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              title: Text(filme.titulo),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${filme.genero} - ${filme.ano}'),
                  RatingBarIndicator(
                    rating: filme.pontuacao,
                    itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
                    itemCount: 5,
                    itemSize: 20,
                    direction: Axis.horizontal,
                  ),
                ],
              ),
              onTap: () => _mostrarOpcoes(filme),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => FilmeFormScreen()),
          );
          _carregarFilmes();
        },
      ),
    );
  }
}
