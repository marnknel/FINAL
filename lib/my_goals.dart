import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'account_manager.dart';
import 'scan.dart';
import 'library_screen.dart';
import 'my_profile.dart';

class MyGoalsPage extends StatefulWidget {
  const MyGoalsPage({super.key});

  @override
  State<MyGoalsPage> createState() => _MyGoalsPageState();
}

class _MyGoalsPageState extends State<MyGoalsPage> {
  String firstName =
      'Chris'; // Default value, will be replaced by the user's actual first name
  List<Map<String, dynamic>> _goals = [];
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Φόρτωση δεδομένων χρήστη κατά την εκκίνηση
    // Initialize the ConfettiController only when the widget is created.
    _startDailyCountdown();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 10));
    _loadGoals(); // Load the goals from SharedPreferences
  }

  @override
  void dispose() {
    // Ensure to dispose of the controller when the widget is destroyed
    _confettiController.dispose();
    super.dispose();
  }

  // Load user data (assuming you have a method like this)
  Future<void> _loadUserData() async {
    Account? user = await AccountManager.getLoggedInUser();
    if (user != null) {
      setState(() {
        firstName = user.firstName;
      });
    }
  }

  Future<void> _loadGoals() async {
    final userAccount = await AccountManager.getLoggedInUser();
    if (userAccount != null) {
      final prefs = await SharedPreferences.getInstance();
      final goalsKey =
          'goals_${userAccount.email}'; // Unique key for this user's goals
      final goalsData = prefs.getString(goalsKey);
      if (goalsData != null) {
        final List<dynamic> goalsList = json.decode(goalsData);
        setState(() {
          _goals =
              goalsList.map((goal) => Map<String, dynamic>.from(goal)).toList();
        });
      }
    }
  }

  // Save goals to SharedPreferences
  Future<void> _saveGoals() async {
    final userAccount = await AccountManager.getLoggedInUser();
    if (userAccount != null) {
      final prefs = await SharedPreferences.getInstance();
      final goalsKey =
          'goals_${userAccount.email}'; // Unique key for this user's goals
      final goalsData = json.encode(_goals);
      prefs.setString(goalsKey, goalsData);
    }
  }

  void _startDailyCountdown() {
    Timer.periodic(const Duration(days: 1), (timer) {
      setState(() {
        for (var goal in _goals) {
          if (goal['daysCounter'] > 0) {
            goal['daysCounter'] -= 1;
          }

          // Check if daysCounter has reached zero
          if (goal['daysCounter'] == 0 && goal['percentage'] < 100) {
            // Show a message
            Future.delayed(Duration.zero, () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Goal Not Completed'),
                    content: Text(
                        'Goal "${goal['title']}" is not completed. Try again!'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            });
          }
        }
      });
    });
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
              mainAxisAlignment: MainAxisAlignment.center, // Centers vertically
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Centers horizontally
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
                                  blurRadius: 4.0,
                                  color: Color.fromARGB(255, 116, 112, 112),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),
                          const Text(
                            'Welcome to your Reading Goals',
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.add,
                          color: Color.fromARGB(255, 255, 255, 255),
                          size: 30,
                        ),
                        onPressed: () {
                          _showAddGoalModal(context);
                        },
                      ),
                      const Text(
                        'Add a new goal',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
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
                ),
                const SizedBox(height: 15),

                // Wrap only the list of goals in SingleChildScrollView to make it scrollable
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0), // Padding on left and right
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment
                            .center, // Vertically centers the children
                        crossAxisAlignment: CrossAxisAlignment
                            .center, // Horizontally centers the children
                        children: _goals.map((goal) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment
                                .center, // Centers each item horizontally
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _showEditGoalModal(context, goal);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .center, // Centers the Row items
                                  children: [
                                    // Circular progress indicator
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        SizedBox(
                                          height: 50,
                                          width: 50,
                                          child: CircularProgressIndicator(
                                            value: goal['percentage'] / 100,
                                            backgroundColor:
                                                Colors.grey.shade300,
                                            color: Colors.orange,
                                            strokeWidth: 6,
                                          ),
                                        ),
                                        Text(
                                          '${goal['percentage']}%',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 15),
                                    // Goal text and delete button
                                    Container(
                                      height: 55,
                                      width: 220,
                                      decoration: BoxDecoration(
                                        color: Colors.orange,
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.2),
                                            blurRadius: 5,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        goal['title'],
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                      ),
                                      onPressed: () {
                                        _deleteGoal(goal);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                  height: 12), // Add space between goal items
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.blue,
                Colors.green,
                Colors.red,
                Colors.yellow
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
                            leading: const Icon(Icons.qr_code_scanner),
                            title: const Text(
                              'Scan',
                              style: TextStyle(
                                fontFamily:
                                    'KaushanScript-Regular', // Αντικατάστησε το με το όνομα της γραμματοσειράς σου
                                fontSize:
                                    16, // Προσαρμογή μεγέθους γραμματοσειράς
                                fontWeight: FontWeight
                                    .bold, // Προσαρμογή πάχους γραμματοσειράς (αν χρειάζεται)
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ScanPage(),
                                ),
                              );
                            },
                          )
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

  void _showAddGoalModal(BuildContext context) {
    final TextEditingController _titleController = TextEditingController();
    final TextEditingController _totalBooksController = TextEditingController();
    final TextEditingController _daysCounterController =
        TextEditingController();
    final TextEditingController _booksReadController = TextEditingController();

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
              color: Colors.orange,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add a New Goal',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Goal Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _totalBooksController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Total Number of Books',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _daysCounterController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Days to Complete Goal',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _booksReadController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Books Read So Far',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    final String title = _titleController.text.trim();
                    final String totalBooksText =
                        _totalBooksController.text.trim();
                    final String daysCounterText =
                        _daysCounterController.text.trim();
                    final String booksReadText =
                        _booksReadController.text.trim();

                    if (title.isNotEmpty &&
                        totalBooksText.isNotEmpty &&
                        daysCounterText.isNotEmpty &&
                        booksReadText.isNotEmpty) {
                      final int totalBooks = int.tryParse(totalBooksText) ?? 0;
                      final int daysCounter =
                          int.tryParse(daysCounterText) ?? 0;
                      final int booksRead = int.tryParse(booksReadText) ?? 0;

                      if (totalBooks > 0 && daysCounter > 0 && booksRead >= 0) {
                        final double percentage =
                            (booksRead / totalBooks * 100).clamp(0, 100);

                        setState(() {
                          _goals.add({
                            'title': title,
                            'totalBooks': totalBooks, // Correct key
                            'daysCounter': daysCounter,
                            'booksRead': booksRead, // Correct key
                            'percentage': percentage.round(),
                          });
                          _saveGoals(); // Save updated goals
                          if (percentage == 100) {
                            _confettiController.play(); // Trigger confetti
                          }
                        });
                        Navigator.pop(context); // Close the modal
                      }
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

  // Function to delete a goal
  void _deleteGoal(Map<String, dynamic> goal) {
    setState(() {
      _goals.remove(goal);
      _saveGoals(); // Save updated goals after deletion
    });
  }

  void _showEditGoalModal(BuildContext context, Map<String, dynamic> goal) {
    final TextEditingController _titleController =
        TextEditingController(text: goal['title']);
    final TextEditingController _numBooksController = TextEditingController(
        text: goal['totalBooks'].toString()); // Use 'totalBooks'
    final TextEditingController _daysCounterController =
        TextEditingController(text: goal['daysCounter'].toString());
    final TextEditingController _booksCounterController = TextEditingController(
        text: goal['booksRead'].toString()); // Use 'booksRead'

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
              color: Colors.orange,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Edit Goal',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Goal Title',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _numBooksController,
                  decoration: const InputDecoration(
                    labelText: 'Total Number of Books',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _daysCounterController,
                  decoration: const InputDecoration(
                    labelText: 'Days to Complete Goal',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _booksCounterController,
                  decoration: const InputDecoration(
                    labelText: 'Books Read So Far',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      goal['title'] = _titleController.text;
                      goal['totalBooks'] = int.parse(_numBooksController
                          .text); // Correct key for totalBooks
                      goal['daysCounter'] =
                          int.parse(_daysCounterController.text);
                      goal['booksRead'] = int.parse(_booksCounterController
                          .text); // Correct key for booksRead

                      // Recalculate percentage
                      goal['percentage'] =
                          ((goal['booksRead'] / goal['totalBooks']) * 100)
                              .round();

                      _saveGoals(); // Save updated goals
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Save Changes'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
