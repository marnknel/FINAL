import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  static Database? _database;

  factory DBHelper() => _instance;

  DBHelper._internal();

  // Get database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  // Initialize database with error handling
  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'signup.db');
    return await openDatabase(
      path,
      version: 3, // Incremented version for the update
      onCreate: (db, version) async {
        // Create users table
        await db.execute('''
            CREATE TABLE users (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              first_name TEXT NOT NULL,
              last_name TEXT NOT NULL,
              email TEXT NOT NULL UNIQUE,
              birth_date TEXT NOT NULL,
              phone_number TEXT NOT NULL,
              password TEXT NOT NULL
            )
          ''');

        // Create notes table
        await db.execute('''
            CREATE TABLE notes (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              user_id INTEGER NOT NULL,
              title TEXT NOT NULL,
              content TEXT NOT NULL,
              date_created TEXT NOT NULL,
              FOREIGN KEY(user_id) REFERENCES users(id)
            )
          ''');
        // Create reviews table
        await db.execute('''
            CREATE TABLE reviews (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              user_id INTEGER NOT NULL,
              rating INTEGER NOT NULL,
              review_text TEXT,
              date_created TEXT NOT NULL,
              FOREIGN KEY(user_id) REFERENCES users(id)
            )
          ''');
        // Στο onCreate, προσθέστε:
        await db.execute('''
  CREATE TABLE book_info (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    title TEXT NOT NULL,
    summary TEXT,
    authors TEXT NOT NULL,
    category TEXT NOT NULL,
    isbn TEXT UNIQUE NOT NULL,
    language TEXT NOT NULL,
    total_pages INTEGER NOT NULL,
    current_page INTEGER DEFAULT 0,
    rating INTEGER CHECK(rating BETWEEN 1 AND 5),
    is_favorite BOOLEAN NOT NULL DEFAULT 0,
    cover_image TEXT,
    FOREIGN KEY(user_id) REFERENCES users(id)
  )
''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 4) {
          // Add reviews table if upgrading from version 3 to 4
          await db.execute('''
            CREATE TABLE reviews (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              user_id INTEGER NOT NULL,
              rating INTEGER NOT NULL,
              review_text TEXT,
              date_created TEXT NOT NULL,
              FOREIGN KEY(user_id) REFERENCES users(id)
            )
          ''');
        }

        // Στο onUpgrade, προσθέστε:
        if (oldVersion < 4) {
          await db.execute('''
    CREATE TABLE book_info (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL,
      title TEXT NOT NULL,
      summary TEXT,
      authors TEXT NOT NULL,
      category TEXT NOT NULL,
      isbn TEXT UNIQUE NOT NULL,
      language TEXT NOT NULL,
      total_pages INTEGER NOT NULL,
      current_page INTEGER DEFAULT 0,
      rating INTEGER CHECK(rating BETWEEN 1 AND 5),
      is_favorite BOOLEAN NOT NULL DEFAULT 0,
      cover_image TEXT,
      FOREIGN KEY(user_id) REFERENCES users(id)
    )
  ''');
        }
      },

      ///
      ///
    );
  }

  // Insert a user
  Future<bool> insertUser(String firstName, String lastName, String email,
      String birthDate, String phoneNumber, String password) async {
    final db = await database;

    // Check if any field is empty
    if (firstName.isEmpty ||
        lastName.isEmpty ||
        email.isEmpty ||
        birthDate.isEmpty ||
        phoneNumber.isEmpty ||
        password.isEmpty) {
      return false; // Return false if any field is empty
    }

    // Check if user with the same email already exists
    final existingUser = await getUserByEmail(email);
    if (existingUser != null) {
      return false; // Return false if email is already taken
    }

    // Create a map with the user data
    Map<String, dynamic> user = {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'birth_date': birthDate,
      'phone_number': phoneNumber,
      'password': password,
    };

    try {
      await db.insert('users', user);
      return true; // Return true if insertion is successful
    } catch (e) {
      print("Error inserting user: $e");
      return false; // Return false if there's an error during insert
    }
  }

  // Get all users
  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;
    return await db.query('users');
  }

  Future<int?> getUserId() async {
    final db = await database;
    final result = await db.query(
      'users',
      columns: ['id'], // Πάρτε μόνο την στήλη 'id'
      limit: 1, // Παίρνετε μόνο το πρώτο χρήστη
    );

    if (result.isNotEmpty) {
      return result.first['id'] as int?;
    }
    return null; // Επιστρέφει null αν δεν βρει χρήστη
  }

  // Insert a note
  Future<bool> insertNote(
      int userId, String title, String content, String dateCreated) async {
    final db = await database;

    // Create a map with the note data
    Map<String, dynamic> note = {
      'user_id': userId,
      'title': title,
      'content': content,
      'date_created': dateCreated,
    };

    try {
      await db.insert('notes', note);
      return true; // Return true if insertion is successful
    } catch (e) {
      print("Error inserting note: $e");
      return false; // Return false if there's an error during insert
    }
  }

  // Get all notes for a specific user
  Future<List<Map<String, dynamic>>> getNotesByUserId(int userId) async {
    final db = await database;
    return await db.query(
      'notes',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  // Delete a note by its ID
  Future<int> deleteNoteById(int noteId) async {
    final db = await database;
    return await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [noteId],
    );
  }

  // Method to update a note
  Future<bool> updateNote(
      int noteId, String title, String content, String dateCreated) async {
    final db = await database;

    // Create a map for updating the note fields
    Map<String, dynamic> updatedNote = {
      'title': title,
      'content': content,
      'date_created': dateCreated,
    };

    try {
      // Update the note data where the note ID matches
      int updatedRows = await db.update(
        'notes',
        updatedNote,
        where: 'id = ?',
        whereArgs: [noteId],
      );

      return updatedRows > 0; // Return true if the update was successful
    } catch (e) {
      print("Error updating note: $e");
      return false; // Return false if update fails
    }
  }

  // Check if user with the same email already exists
  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty ? result.first : null;
  }

  // Delete all users (for testing)
  Future<int> deleteAllUsers() async {
    final db = await database;
    return await db.delete('users');
  }

  // Validate user by email and password
  Future<bool> validateUser(String email, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    return result.isNotEmpty;
  }

  // Check if user with the same email and phone number exists
  Future<bool> checkUserExists(String email, String phone) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ? AND phone_number = ?',
      whereArgs: [email, phone],
    );
    return result.isNotEmpty;
  }

  // Update user's password based on email and phone number
  Future<bool> updateUserPassword(
      String email, String phone, String newPassword) async {
    final db = await database;

    int updatedRows = await db.update(
      'users',
      {'password': newPassword},
      where: 'email = ? AND phone_number = ?',
      whereArgs: [email, phone],
    );

    return updatedRows > 0;
  }

  // Method to update user data
  Future<bool> updateUserData(Map<String, String> updateData) async {
    final db = await database;

    Map<String, dynamic> updatedUser = {
      'first_name': updateData['firstName'],
      'last_name': updateData['lastName'],
      'email': updateData['email'],
      'birth_date': updateData['birthDate'],
      'phone_number': updateData['phoneNumber'],
      'password': updateData['password'],
    };

    try {
      int updatedRows = await db.update(
        'users',
        updatedUser,
        where: 'email = ?',
        whereArgs: [updateData['email']],
      );

      return updatedRows > 0;
    } catch (e) {
      print("Error updating user data: $e");
      return false;
    }
  }

  // Method to get all user data
  Future<Map<String, String?>> getUserData() async {
    final db = await database;
    final result = await db.query('users');

    if (result.isNotEmpty) {
      final user = result.first;
      return {
        'firstName': user['first_name'] as String?,
        'lastName': user['last_name'] as String?,
        'email': user['email'] as String?,
        'birthDate': user['birth_date'] as String?,
        'phoneNumber': user['phone_number'] as String?,
        'password': user['password'] as String?,
      };
    }

    return {
      'firstName': null,
      'lastName': null,
      'email': null,
      'birthDate': null,
      'phoneNumber': null,
      'password': null,
    };
  }

// Insert a review with rating
  Future<bool> insertReview(int userId, String title, String content,
      int rating, String dateCreated) async {
    final db = await database;

    // Create a map with the note data
    Map<String, dynamic> review = {
      'user_id': userId,
      'title': title,
      'content': content,
      'rating': rating,
      'date_created': dateCreated,
    };

    try {
      await db.insert('reviews', review);
      return true; // Return true if insertion is successful
    } catch (e) {
      print("Error inserting review: $e");
      return false; // Return false if there's an error during insert
    }
  }

// Update a review with rating
  Future<bool> updateReview(int noteId, String title, String content,
      int rating, String dateCreated) async {
    final db = await database;

    // Create a map for updating the note fields
    Map<String, dynamic> updatedReview = {
      'title': title,
      'content': content,
      'rating': rating,
      'date_created': dateCreated,
    };

    try {
      int updatedRows = await db.update(
        'reviews',
        updatedReview,
        where: 'id = ?',
        whereArgs: [noteId],
      );

      return updatedRows > 0; // Return true if the update was successful
    } catch (e) {
      print("Error updating review: $e");
      return false; // Return false if update fails
    }
  }

  Future<bool> insertBook(
      int userId,
      String title,
      String summary,
      String authors,
      String category,
      String isbn,
      String language,
      int totalPages,
      {String? coverImage}) async {
    final db = await database;

    Map<String, dynamic> book = {
      'user_id': userId,
      'title': title,
      'summary': summary,
      'authors': authors,
      'category': category,
      'isbn': isbn,
      'language': language,
      'total_pages': totalPages,
      'cover_image': coverImage,
    };

    try {
      await db.insert('book_info', book);
      return true;
    } catch (e) {
      print("Error inserting book: $e");
      return false;
    }
  }

  Future<bool> updateBook(
      int bookId,
      String title,
      String summary,
      String authors,
      String category,
      String isbn,
      String language,
      int totalPages,
      int currentPage,
      int rating,
      bool isFavorite,
      {String? coverImage}) async {
    final db = await database;

    Map<String, dynamic> updatedBook = {
      'title': title,
      'summary': summary,
      'authors': authors,
      'category': category,
      'isbn': isbn,
      'language': language,
      'total_pages': totalPages,
      'current_page': currentPage,
      'rating': rating,
      'is_favorite': isFavorite ? 1 : 0,
      'cover_image': coverImage,
    };

    try {
      int updatedRows = await db.update(
        'book_info',
        updatedBook,
        where: 'id = ?',
        whereArgs: [bookId],
      );
      return updatedRows > 0;
    } catch (e) {
      print("Error updating book: $e");
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getBooksByUserId(int userId) async {
    final db = await database;
    return await db.query(
      'book_info',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  Future<void> insertSampleBooks(int userId) async {
    final books = [
      {
        'title': 'The Great Gatsby',
        'summary': 'A novel about the American dream and its disillusionment.',
        'authors': 'F. Scott Fitzgerald',
        'category': 'Classic',
        'isbn': '9780743273565',
        'language': 'English',
        'totalPages': 180,
        'coverImage': 'assets/images/The_great_gatsby.png',
      },
      {
        'title': '1984',
        'summary': 'A dystopian novel about totalitarianism and surveillance.',
        'authors': 'George Orwell',
        'category': 'Dystopian',
        'isbn': '9780451524935',
        'language': 'English',
        'totalPages': 328,
        'coverImage': 'assets/images/1984.png',
      },
      {
        'title': 'To Kill a Mockingbird',
        'summary': 'A novel about racial injustice in the American South.',
        'authors': 'Harper Lee',
        'category': 'Classic',
        'isbn': '9780061120084',
        'language': 'English',
        'totalPages': 324,
        'coverImage': 'assets/images/to_kill_mocking_bird.png',
      },
      {
        'title': 'The Catcher in the Rye',
        'summary': 'A story about teenage rebellion and alienation.',
        'authors': 'J.D. Salinger',
        'category': 'Fiction',
        'isbn': '9780316769488',
        'language': 'English',
        'totalPages': 277,
        'coverImage': 'assets/images/the_catcher_in_the_Rye.png',
      },
      {
        'title': 'Brave New World',
        'summary':
            'A novel that explores the dangers of a controlled, genetically engineered society.',
        'authors': 'Aldous Huxley',
        'category': 'Science Fiction',
        'isbn': '9780060850524',
        'language': 'English',
        'totalPages': 311,
        'coverImage': 'assets/images/brave_new_worls.png',
      },
      {
        'title': 'Moby Dick',
        'summary':
            'The journey of Captain Ahab to hunt down the elusive white whale.',
        'authors': 'Herman Melville',
        'category': 'Adventure',
        'isbn': '9781503280786',
        'language': 'English',
        'totalPages': 585,
        'coverImage': 'assets/images/Moby_dick.png',
      },
      {
        'title': 'The Hobbit',
        'summary':
            'The adventures of Bilbo Baggins as he journeys to reclaim a treasure.',
        'authors': 'J.R.R. Tolkien',
        'category': 'Fantasy',
        'isbn': '9780345339683',
        'language': 'English',
        'totalPages': 310,
        'coverImage': 'assets/images/the_hobbit.png',
      },
      {
        'title': 'Pride and Prejudice',
        'summary':
            'A story about love, reputation, and class in 19th-century England.',
        'authors': 'Jane Austen',
        'category': 'Romance',
        'isbn': '9780141439518',
        'language': 'English',
        'totalPages': 279,
        'coverImage': 'assets/images/pride_and_predutist.png',
      },
      {
        'title': 'The Lord of the Rings: The Fellowship of the Ring',
        'summary':
            'The first book in a fantasy trilogy about the journey to destroy a powerful ring.',
        'authors': 'J.R.R. Tolkien',
        'category': 'Fantasy',
        'isbn': '9780261103573',
        'language': 'English',
        'totalPages': 423,
        'coverImage': 'lord_of_the_rings.png',
      },
      {
        'title': 'The Diary of a Young Girl',
        'summary':
            'The poignant account of Anne Frank’s life during the Holocaust.',
        'authors': 'Anne Frank',
        'category': 'Biography',
        'isbn': '9780553296983',
        'language': 'English',
        'totalPages': 283,
        'coverImage': 'assets/images/anna_frank.png',
      },
    ];

    for (var book in books) {
      await insertBook(
        userId,
        book['title'] as String,
        book['summary'] as String,
        book['authors'] as String,
        book['category'] as String,
        book['isbn'] as String,
        book['language'] as String,
        book['totalPages'] as int,
        coverImage: book['coverImage'] as String,
      );
    }
  }

  Future<void> deleteAllBooks() async {
    final db =
        await database; // Υποθέτοντας ότι έχετε τη μέθοδο `database` για σύνδεση
    await db.delete('books'); // Διαγράφει όλα τα δεδομένα από τον πίνακα books
  }
}
