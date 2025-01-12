/*import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'my_profile.dart';
import 'library_screen.dart';
import 'my_goals.dart';
import 'scan.dart';
import 'database/db_helper.dart';

class MyReviewsPage extends StatefulWidget {
  const MyReviewsPage({super.key});

  @override
  State<MyReviewsPage> createState() => _MyReviewsPageState();
}

class _MyReviewsPageState extends State<MyReviewsPage> {
  final List<Map<String, dynamic>> _reviews = [];
  String firstName = "Chris"; // Default value for first name

  final DBHelper _dbHelper = DBHelper(); // Initialize DBHelper

  @override
  void initState() {
    super.initState();
    _loadReviews();
    _loadFirstName(); // Load first name dynamically
  }

  // Load first name from the database (just like in MyProfilePage)
  Future<void> _loadFirstName() async {
    final userData = await _dbHelper.getUserData(); // Fetch user data
    if (userData != null) {
      setState(() {
        firstName = userData['firstName'] ?? 'Chris'; // Use data from DB
      });
    }
  }

  // Add this to the _loadReviews method to support loading ratings as well
  Future<void> _loadReviews() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? storedReviews = prefs.getStringList('reviews');

    if (storedReviews != null) {
      setState(() {
        // Read reviews from SharedPreferences and load them
        _reviews.clear();
        for (var review in storedReviews) {
          final parts = review.split('||');
          if (parts.length == 3) {
            _reviews.add({
              'title': parts[0],
              'reviews': parts[1],
              'rating': int.tryParse(parts[2]) ?? 0, // Load rating
            });
          }
        }
      });
    }
  }

// Save reviews to SharedPreferences, including the rating
  Future<void> _saveReviews() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> reviewsToSave = _reviews.map((review) {
      return '${review['title']}||${review['reviews']}||${review['rating']}'; // Save the rating
    }).toList();

    await prefs.setStringList('reviews', reviewsToSave);
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
            child: SingleChildScrollView(
              // Προσθέσαμε το SingleChildScrollView για scrolling
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
                              'Hi, $firstName 👋', // Dynamic first name
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
                            const SizedBox(height: 40),
                            const Text(
                              'Welcome to your Reviews!',
                              style: TextStyle(
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
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyProfilePage(),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 28,
                          ),
                          onPressed: () {
                            _showAddReviewModal(context);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Display the saved reviews with stars
                  Wrap(
                    spacing: 10.0,
                    runSpacing: 10.0,
                    children: _reviews.map((review) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Προσθήκη του Book Title πριν από τα αστέρια
                              Row(
                                children: [
                                  const Text(
                                    'Book Title: ',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  // Εμφάνιση των αστεριών για κάθε κριτική
                                  Row(
                                    children: List.generate(5, (index) {
                                      return Icon(
                                        review['rating'] > index
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: Colors.yellow,
                                      );
                                    }),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  _showReviewDetails(context, review);
                                },
                                child: Container(
                                  height: 50,
                                  width: 300,
                                  decoration: BoxDecoration(
                                    color: const Color.fromRGBO(255, 152, 0, 1),
                                    borderRadius: BorderRadius.circular(15.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 5,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    review['title'],
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 10),
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              _deleteReview(review);
                            },
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
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
                            title: const Text('My Goals',
                                style: TextStyle(color: Colors.black)),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MyGoalsPage(),
                                ),
                              );
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.qr_code_scanner,
                                color: Colors.black),
                            title: const Text('Scan',
                                style: TextStyle(color: Colors.black)),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ScanPage(),
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

// Show the modal for adding or editing a review, with the ability to select a rating
  void _showAddReviewModal(BuildContext context,
      {Map<String, dynamic>? reviewToEdit}) {
    final TextEditingController _titleController = TextEditingController();
    final TextEditingController _reviewsController = TextEditingController();
    int _rating = 0; // Start with a rating of 0

    if (reviewToEdit != null) {
      _titleController.text = reviewToEdit['title'];
      _reviewsController.text = reviewToEdit['reviews'];
      _rating =
          reviewToEdit['rating'] ?? 0; // Set the existing rating if editing
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              color: Color.fromRGBO(230, 176, 95, 1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Add or Edit Review',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _titleController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Book Title',
                    labelStyle: const TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _reviewsController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Review',
                    labelStyle: const TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                  ),
                  maxLines: 4, // Allow multiple lines for reviews
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        _rating > index ? Icons.star : Icons.star_border,
                        color: Colors.yellow,
                      ),
                      onPressed: () {
                        setState(() {
                          _rating = index + 1; // Update rating based on index
                        });
                      },
                    );
                  }),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    final String title = _titleController.text.trim();
                    final String reviews = _reviewsController.text.trim();
                    if (title.isNotEmpty && reviews.isNotEmpty) {
                      setState(() {
                        if (reviewToEdit != null) {
                          reviewToEdit['title'] = title;
                          reviewToEdit['reviews'] = reviews;
                          reviewToEdit['rating'] = _rating;
                        } else {
                          _reviews.add({
                            'title': title,
                            'reviews': reviews,
                            'rating': _rating
                          });
                        }
                        _saveReviews(); // Save updated reviews
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _deleteReview(Map<String, dynamic> review) {
    setState(() {
      _reviews.remove(review);
      _saveReviews(); // Save updated reviews after deletion
    });
  }

  void _showReviewDetails(BuildContext context, Map<String, dynamic> review) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(review['title']),
          content: Text(review['reviews']),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showAddReviewModal(context, reviewToEdit: review);
              },
              child: const Text('Edit'),
            ),
          ],
        );
      },
    );
  }
}
*/
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'account_manager.dart';
import 'library_screen.dart';
import 'my_goals.dart';
import 'my_profile.dart';
import 'scan.dart';

class MyReviewsPage extends StatefulWidget {
  @override
  _MyReviewsPageState createState() => _MyReviewsPageState();
}

class _MyReviewsPageState extends State<MyReviewsPage> {
  final TextEditingController _reviewController = TextEditingController();
  final TextEditingController _bookTitleController = TextEditingController();
  double _rating = 0; // Βαθμολογία (0-5)
  List<Map<String, dynamic>> _reviews =
      []; // Στοιχεία βιβλίου, review και rating
  Account? _loggedInUser;

  @override
  void initState() {
    super.initState();
    _loadLoggedInUserAndReviews();
  }

  Future<void> _loadLoggedInUserAndReviews() async {
    Account? user = await AccountManager.getLoggedInUser();
    if (user != null) {
      setState(() {
        _loggedInUser = user;
      });
      await _loadReviews();
    } else {
      Navigator.of(context).pop();
    }
  }

  Future<void> _loadReviews() async {
    if (_loggedInUser == null) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? reviewsJson = prefs.getString('reviews_${_loggedInUser!.email}');

    if (reviewsJson != null) {
      List<Map<String, dynamic>> reviewsList = List<Map<String, dynamic>>.from(
          (jsonDecode(reviewsJson) as List)
              .map((item) => Map<String, dynamic>.from(item)));
      setState(() {
        _reviews = reviewsList;
      });
    }
  }

  Future<void> _saveReviews() async {
    if (_loggedInUser == null) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'reviews_${_loggedInUser!.email}', jsonEncode(_reviews));
  }

  void _addReview() {
    String bookTitle = _bookTitleController.text.trim();
    String review = _reviewController.text.trim();
    if (bookTitle.isNotEmpty && review.isNotEmpty && _rating > 0) {
      setState(() {
        _reviews.add({
          'title': bookTitle,
          'review': review,
          'rating': _rating, // Αποθήκευση rating
        });
      });
      _bookTitleController.clear();
      _reviewController.clear();
      _rating = 0; // Επαναφορά rating
      _saveReviews();
    }
  }

  void _deleteReviewAt(int index) {
    setState(() {
      _reviews.removeAt(index);
    });
    _saveReviews();
  }

  void _showAddReviewDialog(
      {String initialTitle = '',
      String initialReview = '',
      double initialRating = 0}) {
    _bookTitleController.text = initialTitle;
    _reviewController.text = initialReview;
    _rating = initialRating;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add a New Review'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _bookTitleController,
                decoration: const InputDecoration(labelText: 'Book Title'),
              ),
              TextField(
                controller: _reviewController,
                decoration: const InputDecoration(labelText: 'Review'),
                maxLines: 5,
              ),
              const SizedBox(height: 10),
              // Rating stars
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < _rating ? Icons.star : Icons.star_border,
                      color: Colors.orange,
                    ),
                    onPressed: () {
                      setState(() {
                        _rating = index + 1.0;
                      });
                    },
                  );
                }),
              ),
              Text('Rating: $_rating',
                  style: const TextStyle(color: Colors.black)),
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
                _addReview();
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showEditReviewDialog(BuildContext context, int index) {
    final review = _reviews[index];
    final titleController = TextEditingController(text: review['title']);
    final contentController = TextEditingController(text: review['review']);
    double initialRating = review['rating'] ?? 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Review'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(labelText: 'Review'),
                maxLines: 5,
              ),
              const SizedBox(height: 10),
              // Rating stars
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < initialRating ? Icons.star : Icons.star_border,
                      color: Colors.orange,
                    ),
                    onPressed: () {
                      setState(() {
                        initialRating = index + 1.0;
                      });
                    },
                  );
                }),
              ),
              Text('Rating: $initialRating',
                  style: const TextStyle(color: Colors.black)),
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
                _updateReview(
                  index,
                  titleController.text,
                  contentController.text,
                  initialRating,
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

  void _updateReview(
      int index, String newTitle, String newReview, double newRating) async {
    setState(() {
      _reviews[index]['title'] = newTitle;
      _reviews[index]['review'] = newReview;
      _reviews[index]['rating'] = newRating;
    });

    if (_loggedInUser != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String email = _loggedInUser!.email;
      String reviewsJson = jsonEncode(_reviews);
      await prefs.setString('reviews_$email', reviewsJson);
    }
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
                // Fixed Header Section
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                              'Welcome to your Reviews!',
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
                // Scrollable Review List
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 30.0),
                      child: Column(
                        children: _reviews.map((review) {
                          int index = _reviews.indexOf(review);
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Row for Book Title container and Trash icon
                                Row(
                                  children: [
                                    // 'Book Title:' label
                                    Text(
                                      'Book Title:',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(
                                        width:
                                            10), // Space between label and stars

                                    // Rating stars (shown under the title)
                                    Row(
                                      children: List.generate(5, (index) {
                                        return Icon(
                                          index < (review['rating'] ?? 0)
                                              ? Icons.star
                                              : Icons.star_border,
                                          color: Colors.orange,
                                        );
                                      }),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    // Orange container with Book Title
                                    InkWell(
                                      onTap: () {
                                        _showEditReviewDialog(context, index);
                                      },
                                      child: Container(
                                        width:
                                            270, // Adjusted width to accommodate the text
                                        height: 45,
                                        padding: const EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                          color: Colors.orange,
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        child: Text(
                                          review['title'] ?? '',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    // Trash icon
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.white),
                                      onPressed: () {
                                        _deleteReviewAt(index);
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                    height:
                                        10), // Space between title+trash row and rating row
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
          Positioned(
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
          ),
          Positioned(
            top: 175,
            right: 30,
            child: IconButton(
              icon: const Icon(Icons.add,
                  size: 40, color: Color.fromARGB(255, 255, 255, 255)),
              onPressed: () {
                _showAddReviewDialog();
              },
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
}
