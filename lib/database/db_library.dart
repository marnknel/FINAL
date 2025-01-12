import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;

  static Database? _database;

  DBHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'reviews.db');
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
     CREATE TABLE reviews(
       id INTEGER PRIMARY KEY AUTOINCREMENT,
       title TEXT,
       rating INTEGER,
       review TEXT,
       user TEXT,
       imagePath TEXT
     )
   ''');
  }

  Future<void> insertReview(Map<String, dynamic> review) async {
    final db = await database;
    await db.insert('reviews', review,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateReview(int id, Map<String, dynamic> review) async {
    final db = await database;
    await db.update('reviews', review, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteReview(int id) async {
    final db = await database;
    await db.delete('reviews', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getReviewsForUser(String user) async {
    final db = await database;
    return await db.query('reviews', where: 'user = ?', whereArgs: [user]);
  }

  Future<void> updateImagePath(int id, String imagePath) async {
    final db = await database;
    await db.update('reviews', {'imagePath': imagePath},
        where: 'id = ?', whereArgs: [id]);
  }
}
