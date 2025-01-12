/*import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'library_screen.dart'; // Import the Library Screen
import 'Forgot Password.dart'; // Import the Forgot Password Screen
import 'database/db_helper.dart'; // Import the DBHelper class

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isChecked = false; // Variable to track checkbox state
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Function to attempt login
  void _attemptLogin() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    // Check if the fields are not empty
    if (email.isEmpty || password.isEmpty) {
      _showErrorDialog('Please enter both email and password.');
      return; // Stop further processing if fields are empty
    }

    // Call validateUser to check credentials
    final dbHelper = DBHelper();
    bool isValidUser = await dbHelper.validateUser(email, password);

    if (isValidUser) {
      // Save the credentials if "Remember Me" is checked
      if (_isChecked) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('email', email);
        prefs.setString('password', password);
      }

      // If valid credentials, navigate to LibraryScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LibraryScreen()),
      );
    } else {
      // If invalid credentials, show error and allow retry
      _showErrorDialog('Email or password is incorrect.');
    }
  }

  // Check if credentials are saved in SharedPreferences
  void _checkSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedEmail = prefs.getString('email');
    String? savedPassword = prefs.getString('password');

    if (savedEmail != null && savedPassword != null) {
      // Set the saved email and password in the text fields
      _emailController.text = savedEmail;
      _passwordController.text = savedPassword;
      setState(() {
        _isChecked = true; // Keep "Remember me" checkbox checked
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _checkSavedCredentials(); // Check for saved credentials on startup
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
                image: AssetImage('assets/images/library_background_login.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title Text - "Shelfcout"
                const Text(
                  'SHELFSCOUT!',
                  style: TextStyle(
                    fontSize: 40,
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.bold,
                    fontFamily:
                        'KaushanScript-Regular', // Custom Font applied here
                    shadows: [
                      Shadow(
                        offset: Offset(2, 2),
                        blurRadius: 5.0,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Email TextField
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: const TextStyle(
                        fontFamily: 'KaushanScript-Regular', fontSize: 16),
                    fillColor: const Color.fromRGBO(255, 224, 178, 1),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Password TextField
                TextField(
                  controller: _passwordController,
                  obscureText: true, // Ensuring password is hidden
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: const TextStyle(
                        fontFamily: 'KaushanScript-Regular', fontSize: 16),
                    fillColor: const Color.fromRGBO(255, 224, 178, 1),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Login Button
                ElevatedButton(
                  onPressed: _attemptLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                  child: const Text(
                    "Let's begin!",
                    style: TextStyle(
                      fontFamily: 'KaushanScript-Regular',
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Remember me and Forgot Password in the same line
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Remember me checkbox
                    Row(
                      children: [
                        Checkbox(
                          value: _isChecked, // Use the checkbox state
                          onChanged: (bool? value) {
                            setState(() {
                              _isChecked =
                                  value ?? false; // Update checkbox state
                            });
                          },
                          activeColor: Colors.white, // White color when checked
                          checkColor:
                              Colors.black, // Black color for the checkmark
                        ),
                        const Text(
                          'Remember me',
                          style: TextStyle(
                            color: Colors.white, // White text color
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),

                    // Forgot Password Button
                    TextButton(
                      onPressed: () {
                        // Navigate to Forgot Password Screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ForgotPasswordScreen()),
                        );
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white, // White text color
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'library_screen.dart'; // Import the Library Screen
import 'Forgot Password.dart'; // Import the Forgot Password Screen
import 'account_manager.dart'; // Import the Account Manager

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false; // Checkbox "Remember Me"
  List<Map<String, String>> _savedAccounts = []; // List of saved accounts
  bool _isPasswordVisible = false; // State for the visibility of the password

  @override
  void initState() {
    super.initState();
    _loadSavedAccounts(); // Load saved accounts on initialization
  }

  Future<void> _loadSavedAccounts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? emails = prefs.getStringList('saved_emails');
    List<String>? passwords = prefs.getStringList('saved_passwords');

    if (emails != null && passwords != null) {
      setState(() {
        _savedAccounts = List.generate(emails.length, (index) {
          return {'email': emails[index], 'password': passwords[index]};
        });
      });
    }
  }

  Future<void> _saveAccount(String email, String password) async {
    setState(() {
      // Update password if account exists, otherwise add it
      bool accountExists = false;
      for (var account in _savedAccounts) {
        if (account['email'] == email) {
          account['password'] = password;
          accountExists = true;
          break;
        }
      }
      if (!accountExists) {
        _savedAccounts.add({'email': email, 'password': password});
      }
    });

    // Save updated accounts to SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> emails =
        _savedAccounts.map((account) => account['email']!).toList();
    List<String> passwords =
        _savedAccounts.map((account) => account['password']!).toList();
    prefs.setStringList('saved_emails', emails);
    prefs.setStringList('saved_passwords', passwords);
  }

  void _showSavedAccountsDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(10),
          height: _savedAccounts.isNotEmpty
              ? 150
              : MediaQuery.of(context).size.height * 0.3,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: Color.fromRGBO(255, 161, 79, 0.5),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select an Account',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 7),
              _savedAccounts.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: _savedAccounts.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 5),
                            title: Text(_savedAccounts[index]['email']!),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _confirmDeleteAccount(index);
                              },
                            ),
                            onTap: () {
                              _emailController.text =
                                  _savedAccounts[index]['email']!;
                              _passwordController.text =
                                  _savedAccounts[index]['password']!;
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                    )
                  : const Text('No saved accounts available.'),
            ],
          ),
        );
      },
    );
  }

  void _confirmDeleteAccount(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text(
              'Are you sure you want to delete this account from easy access?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                _deleteAccount(index);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteAccount(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _savedAccounts.removeAt(index);
    });

    List<String> emails =
        _savedAccounts.map((account) => account['email']!).toList();
    List<String> passwords =
        _savedAccounts.map((account) => account['password']!).toList();
    prefs.setStringList('saved_emails', emails);
    prefs.setStringList('saved_passwords', passwords);
  }

  void _attemptLogin() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showErrorDialog('Please enter both email and password.');
      return;
    }

    Account? account = await AccountManager.validateAccount(email, password);

    if (account != null) {
      await AccountManager.setLoggedInUser(email);

      if (_rememberMe) {
        await _saveAccount(email, password);
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LibraryScreen()),
      );
    } else {
      _showErrorDialog('Email or password is incorrect.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
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
                image: AssetImage('assets/images/library_background_login.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'SHELFSCOUT!',
                  style: TextStyle(
                    fontSize: 40,
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'KaushanScript-Regular',
                    shadows: [
                      Shadow(
                          offset: Offset(2, 2),
                          blurRadius: 5.0,
                          color: Colors.black),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: const TextStyle(
                        fontFamily: 'KaushanScript-Regular', fontSize: 16),
                    fillColor: const Color.fromRGBO(255, 224, 178, 1),
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0)),
                  ),
                  onTap: _showSavedAccountsDialog,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: const TextStyle(
                        fontFamily: 'KaushanScript-Regular', fontSize: 16),
                    fillColor: const Color.fromRGBO(255, 224, 178, 1),
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0)),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: const Color.fromRGBO(255, 161, 79, 1),
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (bool? value) {
                        setState(() {
                          _rememberMe = value!;
                        });
                      },
                    ),
                    const Text(
                      'Remember Me',
                      style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontFamily: 'KaushanScript-Regular'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _attemptLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(255, 161, 79, 1),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0)),
                  ),
                  child: const Text(
                    'LOGIN',
                    style: TextStyle(
                        fontSize: 18, fontFamily: 'KaushanScript-Regular'),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ForgotPasswordScreen()),
                    );
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'KaushanScript-Regular',
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
