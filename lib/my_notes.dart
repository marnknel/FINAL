import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'account_manager.dart';
import 'library_screen.dart';
import 'my_goals.dart';
import 'my_profile.dart';
import 'scan.dart';

class MyNotesPage extends StatefulWidget {
  @override
  _MyNotesPageState createState() => _MyNotesPageState();
}

class _MyNotesPageState extends State<MyNotesPage> {
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _bookTitleController = TextEditingController();
  List<Map<String, String>> _notes = []; // List to store book title and note
  Account? _loggedInUser;

  @override
  void initState() {
    super.initState();
    _loadLoggedInUserAndNotes();
  }

  Future<void> _loadLoggedInUserAndNotes() async {
    Account? user = await AccountManager.getLoggedInUser();
    if (user != null) {
      setState(() {
        _loggedInUser = user;
      });
      await _loadNotes();
    } else {
      Navigator.of(context).pop();
    }
  }

  Future<void> _loadNotes() async {
    if (_loggedInUser == null) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? notesJson = prefs.getString('notes_${_loggedInUser!.email}');

    if (notesJson != null) {
      List<Map<String, String>> notesList = List<Map<String, String>>.from(
          (jsonDecode(notesJson) as List)
              .map((item) => Map<String, String>.from(item)));
      setState(() {
        _notes = notesList;
      });
    }
  }

  Future<void> _saveNotes() async {
    if (_loggedInUser == null) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('notes_${_loggedInUser!.email}', jsonEncode(_notes));
  }

  void _addNote() {
    String bookTitle = _bookTitleController.text.trim();
    String note = _noteController.text.trim();
    if (bookTitle.isNotEmpty && note.isNotEmpty) {
      setState(() {
        _notes.add({'title': bookTitle, 'note': note});
      });
      _bookTitleController.clear();
      _noteController.clear();
      _saveNotes();
    }
  }

  void _deleteNoteAt(int index) {
    setState(() {
      _notes.removeAt(index);
    });
    _saveNotes();
  }

  void _showAddNoteDialog({String initialTitle = '', String initialNote = ''}) {
    // Ορισμός αρχικών τιμών στους controllers
    _bookTitleController.text = initialTitle;
    _noteController.text = initialNote;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add a New Note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _bookTitleController,
                decoration: const InputDecoration(labelText: 'Book Title'),
              ),
              TextField(
                controller: _noteController,
                decoration: const InputDecoration(labelText: 'Note'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _addNote();
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showEditNoteDialog(BuildContext context, int index) {
    final note = _notes[index];
    final titleController = TextEditingController(text: note['title']);
    final contentController = TextEditingController(
        text: note['note']); // Εδώ αλλάξαμε το 'content' σε 'note'

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(labelText: 'Content'),
                maxLines: 5,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _updateNote(
                  index,
                  titleController.text,
                  contentController.text,
                );
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showNoteForEditing(int index) {
    final note = _notes[index];
    final initialTitle = note['title'] ?? '';
    final initialNote = note['note'] ?? '';

    _showAddNoteDialog(initialTitle: initialTitle, initialNote: initialNote);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/library_background_main.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.start, // Align text to the left
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Personalized Greeting
                            Text(
                              'Hi, ${_loggedInUser?.firstName ?? 'User'} 👋',
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Lobster-Regular',
                                shadows: [
                                  Shadow(
                                    offset: Offset(2, 2),
                                    blurRadius: 4.0,
                                    color: Color.fromARGB(255, 116, 112, 112),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Welcome to your Notes!',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Lobster-Regular',
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    offset: Offset(2, 2),
                                    blurRadius: 4.0,
                                    color: Color.fromARGB(255, 116, 112, 112),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                      // Profile Image Positioned on the Right
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MyProfilePage(),
                            ),
                          );
                        },
                        child: const CircleAvatar(
                          radius: 25,
                          backgroundImage:
                              AssetImage('assets/images/profil_image.png'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                // Wrap the ListView.builder with SingleChildScrollView
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Column(
                        children: _notes.map((note) {
                          int index = _notes.indexOf(note);
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    _showEditNoteDialog(context, index);
                                  },
                                  child: Container(
                                    width: 280,
                                    height: 45,
                                    padding: const EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      color: Colors.orange,
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: Text(
                                      note['title'] ?? '',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.white),
                                  onPressed: () {
                                    _deleteNoteAt(index);
                                  },
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Profile Image Positioned Further Down and Right
          /* Positioned(
            top: 90,
            right: 14,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyProfilePage(),
                  ),
                );
              },
              child: const CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage('assets/images/profil_image.png'),
              ),
            ),
          ),*/
          // Add Button Positioned Below Profile Image (keeping the same position on the right)
          Positioned(
            top: 175,
            right: 30,
            child: IconButton(
              icon: const Icon(Icons.add, color: Colors.white, size: 40),
              onPressed: _showAddNoteDialog,
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      color: const Color.fromRGBO(255, 224, 178, 1),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.flag),
                            title: const Text('My Goals',
                                style:
                                    TextStyle(fontFamily: 'Lobster-Regular')),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MyGoalsPage(),
                                ),
                              );
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.qr_code_scanner),
                            title: const Text('Scan',
                                style:
                                    TextStyle(fontFamily: 'Lobster-Regular')),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ScanPage(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.home, color: Colors.white),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LibraryScreen(),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _updateNote(int index, String newTitle, String newNote) async {
    setState(() {
      _notes[index]['title'] = newTitle;
      _notes[index]['note'] = newNote; // Εδώ αλλάξαμε το 'content' σε 'note'
    });

    if (_loggedInUser != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String email = _loggedInUser!.email;
      String notesJson = jsonEncode(_notes);
      await prefs.setString('notes_$email', notesJson);
    }
  }
}
