import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/filme.dart';

class FilmeDAO {
  static const String _tableName = 'filmes';

  Future<Database> getDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'filmes.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE $_tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            imagemUrl TEXT,
            titulo TEXT,
            genero TEXT,
            faixaEtaria TEXT,
            duracao INTEGER,
            pontuacao REAL,
            descricao TEXT,
            ano INTEGER
          )
        ''');
      },
    );
  }

  Future<int> insert(Filme filme) async {
    final db = await getDatabase();
    return db.insert(_tableName, filme.toMap());
  }

  Future<List<Filme>> getAll() async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(_tableName);

    return List.generate(maps.length, (i) {
      return Filme.fromMap(maps[i]);
    });
  }

  Future<int> delete(int id) async {
    final db = await getDatabase();
    return db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(Filme filme) async {
    final db = await getDatabase();
    return db.update(
      _tableName,
      filme.toMap(),
      where: 'id = ?',
      whereArgs: [filme.id],
    );
  }
}
