import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:t3_pais/database/model/pais_model.dart';

class PaisHelper {
  static final PaisHelper _instance = PaisHelper._internal();
  static Database? _database;

  PaisHelper._internal();

  factory PaisHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDb();
    return _database!;
  }

  Future<Database> initDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "pais_database.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int newVersion) async {
        await db.execute('''
      CREATE TABLE pais(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        capital TEXT,
        populacao INTEGER,
        sigla TEXT,
        continente TEXT,
        regime_politico TEXT,
        bandeira TEXT  -- Nova coluna adicionada
      )
    ''');
      },
    );
  }

  Future<int> CreatePais(Pais pais) async {
    Database db = await database;
    return await db.insert('pais', pais.toMap());
  }

  Future<List<Pais>> getPaises() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('pais');
    return List.generate(maps.length, (i) => Pais.fromMap(maps[i]));
  }

  Future<int> updatePais(Pais pais) async {
    Database db = await database;
    return await db.update(
      'pais',
      pais.toMap(),
      where: 'id = ?',
      whereArgs: [pais.id],
    );
  }

  Future<int> deletePais(int id) async {
    Database db = await database;
    return await db.delete('pais', where: 'id = ?', whereArgs: [id]);
  }
}
