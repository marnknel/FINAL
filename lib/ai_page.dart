import 'package:flutter/material.dart';
import 'openai_api.dart'; // Εισαγωγή της υπηρεσίας OpenAI
import 'my_goals.dart';
import 'scan.dart';
import 'my_profile.dart';
import 'library_screen.dart';
import 'account_manager.dart';

class AiPage extends StatefulWidget {
  const AiPage({super.key});

  @override
  _AiPageState createState() => _AiPageState();
}

class _AiPageState extends State<AiPage> {
  late Account _account;
  bool _isLoading = true; // Flag for loading state

  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = [];
  final OpenAIService _openAIService = OpenAIService(
      apiKey:
          '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'); // Εισαγωγή του API Key

  @override
  void initState() {
    super.initState();
    _loadLoggedInUser(); // Φόρτωσε τα δεδομένα του χρήστη
  }

  Future<void> _loadLoggedInUser() async {
    try {
      Account? loggedInUser = await AccountManager.getLoggedInUser();
      if (loggedInUser != null) {
        setState(() {
          _account = loggedInUser; // Ενημέρωσε τα δεδομένα του χρήστη
          _isLoading = false; // Τέλος της φόρτωσης
        });
      } else {
        // Αν δεν υπάρχει logged-in user, εμφάνισε μια προεπιλεγμένη οθόνη
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false; // Ακόμα και αν υπάρξει λάθος, σταματά η φόρτωση
      });
      debugPrint('Error loading user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // New background image
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
                      // Personalized greeting
                      Text(
                        'Hi, ${_account.firstName} 👋',
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
                      // Profile button
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
                const SizedBox(height: 10),
                // Welcome message
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      // Book icon
                      Icon(
                        Icons.book, // Book icon
                        size: 30.0,
                        color: Color.fromRGBO(236, 170, 0, 1.0), // Icon color
                      ),
                      const SizedBox(
                          width: 8), // Space between the icon and the text
                      // Text "Ask anything!"
                      Text(
                        'Ask anything!',
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
                ),
                const SizedBox(height: 10),
                // Chat messages list
                Expanded(
                  child: ListView.builder(
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          _messages[index],
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    },
                  ),
                ),
                // Input field and send button
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Say something...',
                            hintStyle: const TextStyle(color: Colors.white70),
                            filled: true,
                            fillColor: Colors.black54,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send, color: Colors.white),
                        onPressed: _sendMessage,
                      ),
                    ],
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

  // Μέθοδος για την αποστολή μηνύματος στο AI και εμφάνιση της απάντησης
  Future<void> _sendMessage() async {
    final prompt = _controller.text.trim();
    if (prompt.isEmpty) return;

    setState(() {
      _messages.add('Εσύ: $prompt');
    });

    _controller.clear();

    try {
      // Στείλε το μήνυμα στο AI
      final response = await _openAIService.getResponse(prompt);
      setState(() {
        _messages.add('AI: $response');
      });
    } catch (error) {
      setState(() {
        _messages.add('AI: Σφάλμα στην επικοινωνία με το API');
        print('Σφάλμα API: $error');
      });
    }
  }
}

//'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'); // Εισαγωγή του API Key