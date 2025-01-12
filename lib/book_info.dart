import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'library_screen.dart';
import 'my_goals.dart';
import 'scan.dart';

class BookInfoPage extends StatefulWidget {
  final String bookTitle;
  final File? bookImage;

  const BookInfoPage({
    super.key,
    required this.bookTitle,
    this.bookImage,
  });

  @override
  _BookInfoPageState createState() => _BookInfoPageState();
}

class _BookInfoPageState extends State<BookInfoPage> {
  bool isFavorite = false; // Check if the heart is red
  int rating = 0; // Rating (1-5 stars)

  void updateRating(int index) {
    setState(() {
      rating =
          index + 1; // Set rating to the tapped star and all previous stars
      // Αποθήκευση της αξιολόγησης στο SharedPreferences
      SharedPreferences.getInstance().then((prefs) {
        prefs.setInt('${widget.bookTitle}_rating', rating);
      });
    });
  }

  Future<void> _checkIfFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    bool storedFavoriteStatus =
        prefs.getBool('${widget.bookTitle}_isFavorite') ?? false;

    setState(() {
      isFavorite =
          storedFavoriteStatus; // Χρησιμοποιούμε το storedFavoriteStatus
    });
  }

  void toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    // Αλλαγή κατάστασης αγαπημένου βιβλίου
    setState(() {
      isFavorite = !isFavorite;
    });

    // Αποθήκευση της νέας κατάστασης στο SharedPreferences
    await prefs.setBool('${widget.bookTitle}_isFavorite', isFavorite);

    // Εμφάνιση snack bar για επιβεβαίωση
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isFavorite
              ? 'The book has been added to favorites!'
              : 'The book has been removed from favorites',
          style: const TextStyle(fontFamily: 'Lobster-Regular'),
        ),
        backgroundColor: isFavorite ? Colors.green : Colors.red,
      ),
    );
  }

  final TextEditingController titleController = TextEditingController();
  final TextEditingController summaryController = TextEditingController();
  final TextEditingController authorsController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController isbnController = TextEditingController();
  final TextEditingController languageController = TextEditingController();
  final TextEditingController pagesController = TextEditingController();
  final TextEditingController currentPageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadBookInfo();
    _checkIfFavorite(); // Έλεγχος αν είναι στα αγαπημένα
  }

  Future<void> loadBookInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      titleController.text = prefs.getString('${widget.bookTitle}_title') ?? '';
      summaryController.text =
          prefs.getString('${widget.bookTitle}_summary') ?? '';
      authorsController.text =
          prefs.getString('${widget.bookTitle}_authors') ?? '';
      categoryController.text =
          prefs.getString('${widget.bookTitle}_category') ?? '';
      isbnController.text = prefs.getString('${widget.bookTitle}_isbn') ?? '';
      languageController.text =
          prefs.getString('${widget.bookTitle}_language') ?? '';
      pagesController.text = prefs.getString('${widget.bookTitle}_pages') ?? '';
      currentPageController.text =
          prefs.getString('${widget.bookTitle}_currentPage') ?? '';
      // Φόρτωση του rating και favorite από το SharedPreferences
      rating = prefs.getInt('${widget.bookTitle}_rating') ?? 0;
      isFavorite = prefs.getBool('${widget.bookTitle}_isFavorite') ?? false;
    });
  }

  Future<void> saveBookInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('${widget.bookTitle}_title', titleController.text);
    await prefs.setString(
        '${widget.bookTitle}_summary', summaryController.text);
    await prefs.setString(
        '${widget.bookTitle}_authors', authorsController.text);
    await prefs.setString(
        '${widget.bookTitle}_category', categoryController.text);
    await prefs.setString('${widget.bookTitle}_isbn', isbnController.text);
    await prefs.setString(
        '${widget.bookTitle}_language', languageController.text);
    await prefs.setString('${widget.bookTitle}_pages', pagesController.text);
    await prefs.setString(
        '${widget.bookTitle}_currentPage', currentPageController.text);
    // Αποθήκευση rating και favorite status
    await prefs.setInt('${widget.bookTitle}_rating', rating);
    await prefs.setBool('${widget.bookTitle}_isFavorite', isFavorite);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/library_background_main.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Main Content
          SafeArea(
            child: Column(
              children: [
                // AppBar Section - Εδώ αφαιρέσαμε το IconButton για την προσθήκη και τη διαγραφή
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          titleController.text.isNotEmpty
                              ? titleController.text
                              : widget.bookTitle,
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
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Book cover section
                Container(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: 150,
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2.0),
                      borderRadius: BorderRadius.circular(8.0),
                      image: widget.bookImage != null
                          ? DecorationImage(
                              image: FileImage(widget.bookImage!),
                              fit: BoxFit.cover)
                          : const DecorationImage(
                              image: AssetImage('assets/images/book_cover.png'),
                              fit: BoxFit.cover),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Favorite Icon
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.white,
                  ),
                  onPressed: toggleFavorite,
                ),
                // Star Rating
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        Icons.star,
                        color: index < rating
                            ? Colors.yellow
                            : Colors
                                .white, // Yellow for selected stars, white otherwise
                      ),
                      onPressed: () => updateRating(
                          index), // Update rating when star is tapped
                    );
                  }),
                ),
                const SizedBox(height: 20),
                // Book details section
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView(
                      children: [
                        buildTextField(
                            controller: titleController, label: 'Book Title:'),
                        buildTextField(
                            controller: summaryController,
                            label: 'Book Summary:'),
                        buildTextField(
                            controller: authorsController, label: 'Authors:'),
                        buildTextField(
                            controller: categoryController, label: 'Category:'),
                        buildTextField(
                            controller: isbnController, label: 'ISBN:'),
                        buildTextField(
                            controller: languageController, label: 'Language:'),
                        buildTextField(
                            controller: pagesController, label: 'Book Pages:'),
                        buildTextField(
                            controller: currentPageController,
                            label: 'Current Page:'),
                      ],
                    ),
                  ),
                ),
              ],
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
                            leading:
                                const Icon(Icons.flag, color: Colors.black),
                            title: const Text(
                              'My Goals',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Lobster-Regular'),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MyGoalsPage()),
                              );
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.qr_code_scanner,
                                color: Colors.black),
                            title: const Text(
                              'Scan',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Lobster-Regular'),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ScanPage()),
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
                      builder: (context) => const LibraryScreen()),
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

  // Helper method for text fields
  Widget buildTextField(
      {required TextEditingController controller, required String label}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.yellow),
        ),
      ),
      onChanged: (_) => saveBookInfo(),
    );
  }
}
