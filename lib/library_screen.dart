import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Για τη χρήση File
import 'account_manager.dart'; // Το αρχείο για τη διαχείριση των λογαριασμών
import 'my_profile.dart';
import 'my_goals.dart';
import 'scan.dart';
import 'book_info.dart';
import 'ai_page.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final ImagePicker _picker = ImagePicker();
  List<File?> _bookImages = [];
  String firstName =
      'Chris'; // Default value, θα αντικατασταθεί από τον λογαριασμό χρήστη

  int _colorIndexA = 0;
  int _colorIndexI = 1;
  final List<Color> _colorList = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
  ];

  @override
  void initState() {
    super.initState();
    _initializeProfile();
    _loadUserImages();
    _startColorChange();
  }

  Future<void> _initializeProfile() async {
    final userAccount = await AccountManager.getLoggedInUser();
    if (userAccount != null) {
      setState(() {
        firstName = userAccount.firstName ?? 'Chris';
      });
    }
  }

  Future<void> _loadUserImages() async {
    final userAccount = await AccountManager.getLoggedInUser();
    if (userAccount != null) {
      final imagePaths = await AccountManager.getUserImages(userAccount.email);
      setState(() {
        _bookImages = imagePaths.isNotEmpty
            ? imagePaths
                .map((path) => path != null ? File(path) : null)
                .toList()
            : [];
      });
    }
  }

  // Method to add books to the library
  void _addBookToLibrary(File bookImage) {
    setState(() {
      _bookImages.add(bookImage); // Add the book to the library
    });
    _saveUserImages(); // Optionally save the images if required
  }

  Future<void> _saveUserImages() async {
    final userAccount = await AccountManager.getLoggedInUser();
    if (userAccount != null) {
      // Εδώ παίρνουμε το email από τον συνδεδεμένο χρήστη
      final email = userAccount.email;
      // Δημιουργούμε την λίστα των εικόνων που θα αποθηκευτούν, χωρίς null values
      final imagePaths = _bookImages
          .map((file) => file?.path)
          .where((path) => path != null)
          .cast<String>()
          .toList();
      // Καλούμε την μέθοδο για αποθήκευση των εικόνων
      await AccountManager.saveUserImages(email, imagePaths);
    }
  }

  void _startColorChange() {
    Timer.periodic(const Duration(milliseconds: 600), (timer) {
      setState(() {
        _colorIndexA = (_colorIndexA + 1) % _colorList.length;
        _colorIndexI = (_colorIndexI + 1) % _colorList.length;
      });
    });
  }

  Future<void> _showImagePickerOptions({int? index}) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: const Color.fromRGBO(255, 224, 178, 1),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('Pick Image from Gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedFile =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() {
                      if (index != null && _bookImages[index] == null) {
                        _bookImages[index] = File(pickedFile.path);
                      } else {
                        _bookImages.add(File(pickedFile.path));
                      }
                    });
                    await _saveUserImages();
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Photo'),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedFile =
                      await _picker.pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    setState(() {
                      if (index != null && _bookImages[index] == null) {
                        _bookImages[index] = File(pickedFile.path);
                      } else {
                        _bookImages.add(File(pickedFile.path));
                      }
                    });
                    await _saveUserImages();
                  }
                },
              ),
              if (index != null && _bookImages[index] != null) ...[
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text('Remove Image'),
                  onTap: () async {
                    Navigator.pop(context);
                    setState(() {
                      _bookImages[index] = null;
                    });
                    await _saveUserImages();
                  },
                ),
              ],
              if (index != null) ...[
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.delete_forever),
                  title: const Text('Delete Entire Book'),
                  onTap: () async {
                    Navigator.pop(context);
                    setState(() {
                      _bookImages.removeAt(index);
                    });
                    await _saveUserImages();
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Hi, $firstName 👋\nExplore the ShelfScout',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Lobster-Regular',
                          shadows: [
                            Shadow(
                              offset: Offset(2, 2),
                              blurRadius: 5.0,
                              color: Color.fromARGB(255, 116, 112, 112),
                            ),
                          ],
                        ),
                      ),
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
                          backgroundImage: AssetImage(
                            'assets/images/profil_image.png',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'My Library',
                    style: TextStyle(
                      fontSize: 20,
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
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: _bookImages.length + 1,
                    itemBuilder: (context, index) {
                      if (index == _bookImages.length) {
                        return GestureDetector(
                          onTap: _showImagePickerOptions,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        );
                      } else {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookInfoPage(
                                  bookTitle: 'Book Title ${index + 1}',
                                  bookImage: _bookImages[index]!,
                                ),
                              ),
                            );
                          },
                          onLongPress: () =>
                              _showImagePickerOptions(index: index),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(10),
                              image: _bookImages[index] != null
                                  ? DecorationImage(
                                      image: FileImage(_bookImages[index]!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: _bookImages[index] == null
                                ? const Center(
                                    child: Text(
                                      'No Image',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  )
                                : null,
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AiPage(),
            ),
          );
        },
        backgroundColor: Colors.white.withOpacity(0.8),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'A',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: _colorList[_colorIndexA],
                ),
              ),
              TextSpan(
                text: 'I',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: _colorList[_colorIndexI],
                ),
              ),
            ],
          ),
        ),
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
                            title: const Text(
                              'My Goals',
                              style: TextStyle(fontFamily: 'Lobster-Regular'),
                            ),
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
                            title: const Text(
                              'Scan',
                              style: TextStyle(fontFamily: 'Lobster-Regular'),
                            ),
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
}
