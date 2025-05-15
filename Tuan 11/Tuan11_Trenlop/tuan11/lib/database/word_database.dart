import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/word.dart';

class WordDatabase {
  static Database? _database;

  static Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'words.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE words (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            word TEXT,
            meaning TEXT
          )
        ''');
      },
    );
  }

  static Future<Database> getDb() async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  static Future<void> insertWord(Word word) async {
    final db = await getDb();
    await db.insert(
      'words',
      word.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Word>> getAllWords() async {
    final db = await getDb();
    final maps = await db.query('words');
    return maps.map((map) => Word.fromMap(map)).toList();
  }
}
