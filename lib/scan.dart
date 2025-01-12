import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'library_screen.dart';
import 'my_goals.dart';
import 'my_profile.dart';
import 'account_manager.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart'; // Εισαγωγή του ML Kit Text Recognition
import 'package:shared_preferences/shared_preferences.dart';
import 'book_info.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  bool _showBox = false; // Flag to control the visibility of the bordered box
  bool _showImageOptions = false; // Flag to control image picker options
  File? _imageFile; // Variable to store the picked image file
  String firstName =
      'Chris'; // Default value, will be replaced by the user's actual first name

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    _loadSavedImage(); // Load saved image from SharedPreferences
    _loadUserData(); // Φόρτωση δεδομένων χρήστη κατά την εκκίνηση
  }

  Future<void> _loadUserData() async {
    Account? user = await AccountManager.getLoggedInUser();
    if (user != null) {
      setState(() {
        firstName = user.firstName; // Ενημέρωση του firstName
      });
    }
  }

  Future<void> _loadSavedImage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedImagePath = prefs.getString('savedImagePath');
    if (savedImagePath != null) {
      final file = File(savedImagePath);
      if (await file.exists()) {
        setState(() {
          _imageFile = file;
          _showBox = true;
        });
      }
    }
  }

  Future<void> _deleteImage() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('savedImagePath'); // Remove the saved image path

    setState(() {
      _imageFile = null;
      _showBox = false;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      final file = File(pickedFile.path);

      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('savedImagePath', file.path);

      setState(() {
        _imageFile = file;
        _showBox = true;
      });
    }
  }

// Inside _processImage function
  Future<void> _processImage(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final textRecognizer = TextRecognizer();

    try {
      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Recognized Text'),
            content: SingleChildScrollView(
              child: SelectableText(
                recognizedText.text, // Allows copying the text
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                },
                child: const Text('OK'),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to the BookInfoPage after saving
                  _saveImageAndText(recognizedText.text);

                  Navigator.pop(context); // Close dialog
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookInfoPage(
                        bookTitle: recognizedText.text,
                        bookImage: imageFile, // Pass the image file
                      ),
                    ),
                  );
                },
                child: const Text('Save'),
              ),
              TextButton(
                onPressed: () {
                  _deleteImage();
                  Navigator.pop(context); // Delete and close dialog
                },
                child: const Text('Delete'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Error during text recognition: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to process image: $e')),
      );
    } finally {
      textRecognizer.close();
    }
  }

  Future<void> _saveImageAndText(String recognizedText) async {
    final prefs = await SharedPreferences.getInstance();
    if (_imageFile != null) {
      prefs.setString('savedImagePath', _imageFile!.path);
      prefs.setString('recognizedText', recognizedText);
      setState(() {
        _showBox = true;
      });
    }
  }

  // Display options for picking an image
  Future<void> _showImagePickerOptions() async {
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
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Photo'),
                onTap: () async {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hi, $firstName 👋',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Lobster-Regular',
                              shadows: [
                                Shadow(
                                  offset: Offset(2, 2),
                                  blurRadius: 2.0,
                                  color: Color.fromARGB(255, 116, 112, 112),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 35),
                          const Padding(
                            padding: EdgeInsets.only(left: 40.0),
                            child: Text(
                              'Scan Book',
                              style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.normal,
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontFamily: 'Lobster-Regular',
                                shadows: [
                                  Shadow(
                                    offset: Offset(2, 2),
                                    blurRadius: 2.0,
                                    color: Color.fromARGB(255, 116, 112, 112),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
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
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 150.0),
                    child: Center(
                      child: _showBox
                          ? Positioned(
                              top: 100,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: CustomPaint(
                                        painter: CornerBorderPainter(),
                                      ),
                                    ),
                                    FractionallySizedBox(
                                      widthFactor: 0.7,
                                      heightFactor: 0.8,
                                      alignment: Alignment.center,
                                      child: GestureDetector(
                                        onTap: () {
                                          if (_imageFile != null) {
                                            _processImage(_imageFile!);
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: _imageFile != null
                                              ? ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  child: Image.file(
                                                    _imageFile!,
                                                    fit: BoxFit.cover,
                                                  ),
                                                )
                                              : Container(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 550,
            right: 20,
            child: IconButton(
              onPressed: () {
                setState(() {
                  _showImageOptions = !_showImageOptions;
                  if (_showImageOptions) {
                    _showImagePickerOptions();
                  }
                });
              },
              icon: const Icon(
                Icons.add,
                color: Color.fromARGB(255, 251, 251, 251),
              ),
              iconSize: 35.0, // Αυξάνει το μέγεθος του εικονιδίου
              padding: const EdgeInsets.all(8.0), // Προσαρμόζει την περιοχή αφής
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
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

class CornerBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(0, 0), Offset(0, 20), paint);
    canvas.drawLine(Offset(0, 0), Offset(20, 0), paint);

    canvas.drawLine(Offset(size.width, 0), Offset(size.width - 20, 0), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, 20), paint);

    canvas.drawLine(Offset(0, size.height), Offset(0, size.height - 20), paint);
    canvas.drawLine(Offset(0, size.height), Offset(20, size.height), paint);

    canvas.drawLine(Offset(size.width, size.height),
        Offset(size.width - 20, size.height), paint);
    canvas.drawLine(Offset(size.width, size.height),
        Offset(size.width, size.height - 20), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
