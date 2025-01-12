import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
//import 'package:flutter/services.dart';
//import 'package:shelfscout/database/profile_database.dart';
//import 'package:shelfscout/models/profile.dart';

class ProfileDatabase {
  static final ProfileDatabase instance = ProfileDatabase._init();
  static Database? _database;

  ProfileDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('profile.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
CREATE TABLE profile (
  id $idType,
  username $textType,
  welcomeMessage $textType,
  profileImage $textType,
  notes $textType,
  reviews $textType,
  email $textType,
  birthDate $textType,
  phoneNumber $textType
)
''');
  }

  Future<int> createProfile(Map<String, dynamic> profile) async {
    final db = await instance.database;
    return await db.insert('profile', profile);
  }

  Future<Map<String, dynamic>?> readProfile(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      'profile',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return maps.first;
    } else {
      return null;
    }
  }

  Future<int> updateProfile(int id, Map<String, dynamic> profile) async {
    final db = await instance.database;
    return await db.update(
      'profile',
      profile,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteProfile(int id) async {
    final db = await instance.database;
    return await db.delete(
      'profile',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}

// Διαβάζουμε τα δεδομένα από το JSON αρχείο
Future<Map<String, dynamic>> loadJsonData() async {
  String jsonString = await rootBundle.loadString('assets/data.json');
  Map<String, dynamic> jsonData = jsonDecode(jsonString);
  return jsonData;
}
