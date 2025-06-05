import 'package:flutter/material.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import '../model/filme.dart';
import '../db/filme_dao.dart';

class FilmeFormScreen extends StatefulWidget {
  final Filme? filme;

  FilmeFormScreen({this.filme});

  @override
  _FilmeFormScreenState createState() => _FilmeFormScreenState();
}

class _FilmeFormScreenState extends State<FilmeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dao = FilmeDAO();

  final _urlController = TextEditingController();
  final _tituloController = TextEditingController();
  final _generoController = TextEditingController();
  final _duracaoController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _anoController = TextEditingController();

  String _faixaEtaria = 'Livre';
  double _pontuacao = 0;

  final List<String> _faixas = ['Livre', '10', '12', '14', '16', '18'];

  @override
  void initState() {
    super.initState();
    if (widget.filme != null) {
      _urlController.text = widget.filme!.imagemUrl;
      _tituloController.text = widget.filme!.titulo;
      _generoController.text = widget.filme!.genero;
      _faixaEtaria = widget.filme!.faixaEtaria;
      _duracaoController.text = widget.filme!.duracao.toString();
      _pontuacao = widget.filme!.pontuacao;
      _descricaoController.text = widget.filme!.descricao;
      _anoController.text = widget.filme!.ano.toString();
    }
  }

  void _salvar() async {
    if (_formKey.currentState!.validate()) {
      final filme = Filme(
        id: widget.filme?.id,
        imagemUrl: _urlController.text,
        titulo: _tituloController.text,
        genero: _generoController.text,
        faixaEtaria: _faixaEtaria,
        duracao: int.tryParse(_duracaoController.text) ?? 0,
        pontuacao: _pontuacao,
        descricao: _descricaoController.text,
        ano: int.tryParse(_anoController.text) ?? 0,
      );

      if (widget.filme == null) {
        await _dao.insert(filme);
      } else {
        await _dao.update(filme);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.filme == null ? 'Cadastrar Filme' : 'Editar Filme'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _urlController,
                decoration: InputDecoration(labelText: 'URL da Imagem'),
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                controller: _tituloController,
                decoration: InputDecoration(labelText: 'Título'),
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                controller: _generoController,
                decoration: InputDecoration(labelText: 'Gênero'),
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              DropdownButtonFormField(
                value: _faixaEtaria,
                decoration: InputDecoration(labelText: 'Faixa Etária'),
                items: _faixas
                    .map((e) => DropdownMenuItem(child: Text(e), value: e))
                    .toList(),
                onChanged: (value) => setState(() => _faixaEtaria = value.toString()),
              ),
              TextFormField(
                controller: _duracaoController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Duração (min)'),
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                controller: _anoController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Ano'),
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              SizedBox(height: 16),
              Text('Pontuação (0 a 5):'),
              SmoothStarRating(
                allowHalfRating: false,
                starCount: 5,
                rating: _pontuacao,
                size: 32.0,
                onRatingChanged: (double rating) { // <--- ALTERADO DE 'onRated' PARA 'onRatingChanged'
                  setState(() {
                    _pontuacao = rating;
                  });
                },
                color: Colors.amber,
                borderColor: Colors.grey,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descricaoController,
                decoration: InputDecoration(labelText: 'Descrição'),
                maxLines: 4,
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _salvar,
                child: Text('Salvar'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
