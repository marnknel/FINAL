import 'dart:math';
import 'package:flutter/material.dart';
import 'account_manager.dart'; // Χρήση του AccountManager

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _newPassword = '';

  // Λειτουργία για δημιουργία τυχαίου κωδικού πρόσβασης
  String _generateRandomPassword() {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*()_+';
    Random random = Random();
    return List.generate(12, (index) => chars[random.nextInt(chars.length)])
        .join();
  }

  // Λειτουργία για επαναφορά κωδικού πρόσβασης
  // Λειτουργία για επαναφορά κωδικού πρόσβασης
  void _resetPassword() async {
    String email = _emailController.text.trim();
    String phone = _phoneController.text.trim();

    if (email.isEmpty || phone.isEmpty) {
      _showErrorDialog('Please enter both email and phone number.');
      return;
    }

    // Ανάκτηση λογαριασμού με βάση το email και το τηλέφωνο
    List<Account> accounts = await AccountManager.getAccounts();
    Account? userAccount;
    try {
      userAccount = accounts.firstWhere(
        (account) => account.email == email && account.phoneNumber == phone,
        orElse: () => throw StateError('No matching account found'),
      );
    } catch (e) {
      userAccount = null;
    }

    if (userAccount != null) {
      // Δημιουργία νέου τυχαίου κωδικού πρόσβασης
      _newPassword = _generateRandomPassword();

      // Ενημέρωση του κωδικού πρόσβασης
      userAccount.password = _newPassword;
      await AccountManager.updateAccount(userAccount);

      // Εμφάνιση επιτυχούς μηνύματος με τον νέο κωδικό πρόσβασης
      _showSuccessDialog(
          'Your password has been reset successfully. Your new password is: $_newPassword');
    } else {
      _showErrorDialog('No user found with this email and phone number.');
    }
  }

  // Εμφάνιση μηνύματος λάθους
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Error',
            style: TextStyle(fontFamily: 'Roboto'),
          ),
          content: Text(
            message,
            style: const TextStyle(fontFamily: 'Roboto'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'OK',
                style: TextStyle(fontFamily: 'Roboto'),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Εμφάνιση μηνύματος επιτυχίας
  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Success',
            style: TextStyle(fontFamily: 'Roboto'),
          ),
          content: Text(
            message,
            style: const TextStyle(fontFamily: 'Roboto'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'OK',
                style: TextStyle(fontFamily: 'Roboto'),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context); // Επιστροφή στην οθόνη login
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
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/library_background_login.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Back Button Positioned at the Top Left
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
              onPressed: () {
                Navigator.pop(context); // Go back to the previous screen
              },
            ),
          ),

          // Main Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Forgot Password?',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'KaushanScript-Regular',
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
                    hintText: 'Enter Email',
                    hintStyle: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'KaushanScript-Regular',
                    ),
                    fillColor: const Color.fromRGBO(255, 224, 178, 1),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // Phone Number TextField
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    hintText: 'Enter phone number',
                    hintStyle: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'KaushanScript-Regular',
                    ),
                    fillColor: const Color.fromRGBO(255, 224, 178, 1),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Submit Button
                ElevatedButton(
                  onPressed: _resetPassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontFamily: 'KaushanScript-Regular',
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










/*import 'dart:math';
import 'package:flutter/material.dart';
import 'database/db_helper.dart'; // Υποθέτουμε ότι έχεις έναν DBHelper για τη βάση δεδομένων

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _newPassword = '';

  // Function to generate a random password
  String _generateRandomPassword() {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*()_+';
    Random random = Random();
    return List.generate(12, (index) => chars[random.nextInt(chars.length)])
        .join();
  }

  // Function to handle password reset
  void _resetPassword() async {
    String email = _emailController.text;
    String phone = _phoneController.text;

    if (email.isEmpty || phone.isEmpty) {
      _showErrorDialog('Please enter both email and phone number.');
      return;
    }

    final dbHelper = DBHelper();
    bool userExists = await dbHelper.checkUserExists(email, phone);

    if (userExists) {
      // Generate a new random password
      _newPassword = _generateRandomPassword();

      // Update the user's password in the database
      bool isUpdated =
          await dbHelper.updateUserPassword(email, phone, _newPassword);

      if (isUpdated) {
        _showSuccessDialog('Your new password is: $_newPassword');
      } else {
        _showErrorDialog('Failed to update password. Please try again.');
      }
    } else {
      _showErrorDialog('No user found with this email and phone number.');
    }
  }

  // Show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Error',
            style: TextStyle(fontFamily: 'Roboto'),
          ),
          content: Text(
            message,
            style: const TextStyle(fontFamily: 'Roboto'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'OK',
                style: TextStyle(fontFamily: 'Roboto'),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Show success dialog
  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Success',
            style: TextStyle(fontFamily: 'Roboto'),
          ),
          content: Text(
            message,
            style: const TextStyle(fontFamily: 'Roboto'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'OK',
                style: TextStyle(fontFamily: 'Roboto'),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context); // Navigate back to login screen
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
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/library_background_login.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Back Button Positioned at the Top Left
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
              onPressed: () {
                Navigator.pop(context); // Go back to the previous screen
              },
            ),
          ),

          // Main Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Forgot Password?',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'KaushanScript-Regular',
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
                    hintText: 'Enter Email',
                    hintStyle: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'KaushanScript-Regular',
                    ),
                    fillColor: const Color.fromRGBO(255, 224, 178, 1),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // Phone Number TextField
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    hintText: 'Enter phone number',
                    hintStyle: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'KaushanScript-Regular',
                    ),
                    fillColor: const Color.fromRGBO(255, 224, 178, 1),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Submit Button
                ElevatedButton(
                  onPressed: _resetPassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontFamily: 'KaushanScript-Regular',
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
*/