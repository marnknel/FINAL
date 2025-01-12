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
          /*Positioned(
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
