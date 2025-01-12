import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Επέκταση της βάσης δεδομένων με τον πίνακα για τα αγαπημένα βιβλία
  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'books.db');

    return await openDatabase(
      path,
      version: 3,
      onCreate: (db, version) async {
        // Δημιουργία του πίνακα για τις εικόνες βιβλίων
        await db.execute('''
        CREATE TABLE IF NOT EXISTS book_images (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          sectionIndex INTEGER,
          bookIndex INTEGER,
          imagePath TEXT
        )
      ''');

        // Δημιουργία του πίνακα για τα αγαπημένα βιβλία
        await db.execute('''
        CREATE TABLE IF NOT EXISTS favorite_books (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          bookTitle TEXT,
          imagePath TEXT
        )
      ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 3) {
          // Δημιουργία του πίνακα για τα αγαπημένα βιβλία αν δεν υπάρχει
          await db.execute('''
          CREATE TABLE IF NOT EXISTS favorite_books (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            bookTitle TEXT,
            imagePath TEXT
          )
        ''');
        }
      },
    );
  }

  // Μέθοδος για την προσθήκη βιβλίου στα αγαπημένα
  Future<void> insertFavoriteBook(String bookTitle, String imagePath) async {
    final db = await database;
    await db.insert(
      'favorite_books',
      {
        'bookTitle': bookTitle,
        'imagePath': imagePath,
      },
      conflictAlgorithm:
          ConflictAlgorithm.replace, // Αν υπάρχει ήδη, το αντικαθιστά
    );
  }

  // Μέθοδος για τη διαγραφή βιβλίου από τα αγαπημένα
  Future<void> deleteFavoriteBook(String imagePath) async {
    final db = await database;
    await db.delete(
      'favorite_books',
      where: 'imagePath = ?',
      whereArgs: [imagePath],
    );
  }

  Future<bool> isFavorite(String imagePath) async {
    final db = await database;
    final result = await db.query(
      'favorite_books',
      where: 'imagePath = ?',
      whereArgs: [imagePath],
    );
    return result.isNotEmpty; // Returns true if the book is favorited
  }

  // Μέθοδος για να επιστρέψουμε όλα τα αγαπημένα βιβλία (προαιρετικά για να τα δείξουμε στην οθόνη)
  Future<List<Map<String, dynamic>>> getAllFavorites() async {
    final db = await database;
    return await db.query('favorite_books');
  }

  Future<List<Map<String, dynamic>>> getAllImages() async {
    final db = await database; // Χρησιμοποιείς την μέθοδο `database` εδώ
    return await db.query('book_images'); // Ορθό το όνομα του πίνακα
  }

  Future<void> insertImage(
      int sectionIndex, int bookIndex, String imagePath) async {
    final db = await database;
    await db.insert(
      'book_images',
      {
        'sectionIndex': sectionIndex,
        'bookIndex': bookIndex,
        'imagePath': imagePath,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Νέα μέθοδος για διαγραφή συγκεκριμένης εικόνας
  Future<void> deleteImage(String imagePath) async {
    final db = await database;
    await db.delete(
      'book_images',
      where: 'imagePath = ?',
      whereArgs: [imagePath],
    );
  }

  // Νέα μέθοδος για διαγραφή ολόκληρου βιβλίου (με βάση το bookIndex)
  Future<void> deleteBook(int bookIndex) async {
    final db = await database;
    await db.delete(
      'book_images',
      where: 'bookIndex = ?',
      whereArgs: [bookIndex],
    );
  }
}
