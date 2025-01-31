import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'words.db');
    return openDatabase(path, onCreate: _onCreate, version: 1);
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE words(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        word TEXT,
        imageUrl TEXT
      )
    ''');
  }

  Future<void> insertWord(String word, String imageUrl) async {
    final db = await database;
    await db.insert(
      'words',
      {'word': word, 'imageUrl': imageUrl},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getWords() async {
    final db = await database;
    return await db.query('words');
  }

  Future<void> deleteAllWords() async {
    final db = await database;
    await db.delete('words');
  }
}

Future<void> addWordsToDatabase(
    List<String> words, List<String> imageUrls) async {
  final dbHelper = DatabaseHelper();

  for (int i = 0; i < words.length; i++) {
    await dbHelper.insertWord(words[i], imageUrls[i]);
  }
}

Future<void> fetchWords() async {
  final dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> wordsData = await dbHelper.getWords();

  for (var wordData in wordsData) {
    print('Word: ${wordData['word']}, Image URL: ${wordData['imageUrl']}');
  }
}
