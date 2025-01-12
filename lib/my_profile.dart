import 'package:flutter/material.dart';
import 'library_screen.dart';
import 'my_goals.dart';
import 'scan.dart';
import 'my_info.dart';
import 'my_reviews.dart';
import 'my_notes.dart';
import 'account_manager.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  String firstName = 'Chris'; // Default value
  Account? loggedInAccount;

  @override
  void initState() {
    super.initState();
    _initializeProfileFromSharedPreferences();
  }

  Future<void> _initializeProfileFromSharedPreferences() async {
    // Ανάκτηση του λογαριασμού που είναι συνδεδεμένος
    Account? account = await AccountManager.getLoggedInUser();
    if (account != null) {
      setState(() {
        firstName = account.firstName;
        loggedInAccount = account;
      });
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
          // Main Content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Column for "Hi, {firstName}" and "Profile" with spacing
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
                          const SizedBox(
                              height:
                                  50), // Reduced the height between the text and the next line
                          const Text(
                            'Welcome to Profile!',
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
                      // Circular profile image turned into a button
                      InkWell(
                        onTap: () {
                          // Navigate to the profile page when tapped
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
                // Directly under the "Welcome to Profile!" text
                const SizedBox(height: 80), // Reduced the space

                // Center the buttons and ensure equal spacing and sizes
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.start, // Start from the top
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // My Info Button
                        SizedBox(
                          width: double
                              .infinity, // Makes the button take up full width
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MyInfoPage(),
                                ),
                              );
                            },
                            child: const Text(
                              'My Infos',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                            height: 80), // Reduced the spacing between buttons

                        // My Reviews Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MyReviewsPage(),
                                ),
                              );
                            },
                            child: const Text(
                              'My Reviews',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                            height: 80), // Reduced the spacing between buttons

                        // My Notes Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MyNotesPage(),
                                ),
                              );
                            },
                            child: const Text(
                              'My Notes',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
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
            // Burger menu with popup options
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
            // Home button
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
            // Back button
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
