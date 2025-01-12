/*import 'package:flutter/material.dart';
import 'database/db_helper.dart'; // Import the DBHelper class
import 'library_screen.dart'; // Import the LibraryScreen

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Controllers for form fields
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  final DBHelper _dbHelper = DBHelper(); // Create an instance of DBHelper

  @override
  Widget build(BuildContext context) {
    // Getting the screen dimensions
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/library_background_login.png'), // Update with your background path
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Sign-Up Form
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily:
                            'KaushanScript-Regular', // Apply custom font here
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Form Fields with adjusted width and height
                    ...[
                      {
                        'label': 'First Name',
                        'controller': _firstNameController
                      },
                      {'label': 'Last Name', 'controller': _lastNameController},
                      {'label': 'Email', 'controller': _emailController},
                      {
                        'label': 'Birth Date',
                        'controller': _birthDateController
                      },
                      {
                        'label': 'Phone Number',
                        'controller': _phoneNumberController
                      },
                    ].map((field) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Container(
                          width: width *
                              0.9, // Adjust the width dynamically (90% of the screen width)
                          height: height *
                              0.05, // Adjust the height dynamically (5% of the screen height)
                          child: TextField(
                            controller:
                                field['controller'] as TextEditingController?,
                            decoration: InputDecoration(
                              labelText: field['label'] as String?,
                              labelStyle: const TextStyle(
                                fontFamily: 'KaushanScript-Regular',
                                fontSize: 16,
                              ),
                              filled: true,
                              fillColor: Colors.orange[100],
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 18.0, horizontal: 10.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),

                    // Password Field with eye icon to toggle visibility
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Container(
                        width: width *
                            0.9, // Adjust the width dynamically (90% of the screen width)
                        height: height *
                            0.05, // Adjust the height dynamically (5% of the screen height)
                        child: TextField(
                          controller: _passwordController,
                          obscureText:
                              !_isPasswordVisible, // Toggle password visibility
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: const TextStyle(
                              fontFamily: 'KaushanScript-Regular',
                              fontSize: 16,
                            ),
                            filled: true,
                            fillColor: Colors.orange[100],
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 18.0, horizontal: 10.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility // Eye open
                                    : Icons.visibility_off, // Eye closed
                                color: Colors.orange,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible =
                                      !_isPasswordVisible; // Toggle visibility
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Confirm Password Field with eye icon to toggle visibility
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Container(
                        width: width *
                            0.90, // Adjust the width dynamically (90% of the screen width)
                        height: height *
                            0.05, // Adjust the height dynamically (5% of the screen height)
                        child: TextField(
                          controller: _confirmPasswordController,
                          obscureText:
                              !_isConfirmPasswordVisible, // Toggle confirm password visibility
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            labelStyle: const TextStyle(
                              fontFamily: 'KaushanScript-Regular',
                              fontSize: 16,
                            ),
                            filled: true,
                            fillColor: Colors.orange[100],
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 18.0, horizontal: 10.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isConfirmPasswordVisible
                                    ? Icons.visibility // Eye open
                                    : Icons.visibility_off, // Eye closed
                                color: Colors.orange,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isConfirmPasswordVisible =
                                      !_isConfirmPasswordVisible; // Toggle visibility
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        // Collect user input from form fields
                        String firstName = _firstNameController.text;
                        String lastName = _lastNameController.text;
                        String email = _emailController.text;
                        String birthDate = _birthDateController.text;
                        String phoneNumber = _phoneNumberController.text;
                        String password = _passwordController.text;
                        String confirmPassword =
                            _confirmPasswordController.text;

                        // Validate the form fields
                        if (firstName.isEmpty ||
                            lastName.isEmpty ||
                            email.isEmpty ||
                            birthDate.isEmpty ||
                            phoneNumber.isEmpty ||
                            password.isEmpty ||
                            confirmPassword.isEmpty) {
                          _showErrorDialog('Please fill in all fields.');
                          return;
                        }

                        if (password != confirmPassword) {
                          _showErrorDialog('Passwords do not match.');
                          return;
                        }

                        // Call the insertUser method from DBHelper to insert the user into the database
                        bool success = await _dbHelper.insertUser(
                          firstName,
                          lastName,
                          email,
                          birthDate,
                          phoneNumber,
                          password,
                        );

                        if (success) {
                          // Navigate to the LibraryScreen after successful sign-up
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LibraryScreen(),
                            ),
                          );
                        } else {
                          _showErrorDialog(
                              'An error occurred, or the email is already taken.');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontFamily: 'KaushanScript-Regular',
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to show an error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
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
} //befort acountmanager
*/
import 'package:flutter/material.dart';
import 'account_manager.dart'; // Εισαγωγή του AccountManager
import 'library_screen.dart'; // Εισαγωγή της οθόνης βιβλιοθήκης

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Controllers for form fields
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Getting the screen dimensions
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/library_background_login.png'), // Update with your background path
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Sign-Up Form
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily:
                            'KaushanScript-Regular', // Apply custom font here
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Form Fields with adjusted width and height
                    ...[
                      {
                        'label': 'First Name',
                        'controller': _firstNameController
                      },
                      {'label': 'Last Name', 'controller': _lastNameController},
                      {'label': 'Email', 'controller': _emailController},
                      {
                        'label': 'Birth Date',
                        'controller': _birthDateController
                      },
                      {
                        'label': 'Phone Number',
                        'controller': _phoneNumberController
                      },
                    ].map((field) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Container(
                          width: width *
                              0.9, // Adjust the width dynamically (90% of the screen width)
                          height: height *
                              0.05, // Adjust the height dynamically (5% of the screen height)
                          child: TextField(
                            controller:
                                field['controller'] as TextEditingController?,
                            decoration: InputDecoration(
                              labelText: field['label'] as String?,
                              labelStyle: const TextStyle(
                                fontFamily: 'KaushanScript-Regular',
                                fontSize: 16,
                              ),
                              filled: true,
                              fillColor: Colors.orange[100],
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 18.0, horizontal: 10.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),

                    // Password Field with eye icon to toggle visibility
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Container(
                        width: width *
                            0.9, // Adjust the width dynamically (90% of the screen width)
                        height: height *
                            0.05, // Adjust the height dynamically (5% of the screen height)
                        child: TextField(
                          controller: _passwordController,
                          obscureText:
                              !_isPasswordVisible, // Toggle password visibility
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: const TextStyle(
                              fontFamily: 'KaushanScript-Regular',
                              fontSize: 16,
                            ),
                            filled: true,
                            fillColor: Colors.orange[100],
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 18.0, horizontal: 10.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.orange,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Confirm Password Field with eye icon to toggle visibility
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Container(
                        width: width *
                            0.90, // Adjust the width dynamically (90% of the screen width)
                        height: height *
                            0.05, // Adjust the height dynamically (5% of the screen height)
                        child: TextField(
                          controller: _confirmPasswordController,
                          obscureText:
                              !_isConfirmPasswordVisible, // Toggle confirm password visibility
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            labelStyle: const TextStyle(
                              fontFamily: 'KaushanScript-Regular',
                              fontSize: 16,
                            ),
                            filled: true,
                            fillColor: Colors.orange[100],
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 18.0, horizontal: 10.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isConfirmPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.orange,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isConfirmPasswordVisible =
                                      !_isConfirmPasswordVisible;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        // Collect user input from form fields
                        String firstName = _firstNameController.text;
                        String lastName = _lastNameController.text;
                        String email = _emailController.text;
                        String birthDate = _birthDateController.text;
                        String phoneNumber = _phoneNumberController.text;
                        String password = _passwordController.text;
                        String confirmPassword =
                            _confirmPasswordController.text;

                        // Validate the form fields
                        if (firstName.isEmpty ||
                            lastName.isEmpty ||
                            email.isEmpty ||
                            birthDate.isEmpty ||
                            phoneNumber.isEmpty ||
                            password.isEmpty ||
                            confirmPassword.isEmpty) {
                          _showErrorDialog('Please fill in all fields.');
                          return;
                        }

                        if (password != confirmPassword) {
                          _showErrorDialog('Passwords do not match.');
                          return;
                        }

                        // Έλεγχος αν το email υπάρχει ήδη
                        bool isEmailTaken = await _checkEmailExists(email);

                        if (isEmailTaken) {
                          _showErrorDialog('The email is already taken.');
                        } else {
                          // Αποθήκευση του λογαριασμού μέσω AccountManager
                          await AccountManager.saveAccount(email, password,
                              firstName, lastName, birthDate, phoneNumber);

                          // Καταχώρηση του χρήστη στο σύστημα
                          await AccountManager.setLoggedInUser(email);

                          // Μετάβαση στη σελίδα βιβλιοθήκης
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LibraryScreen(),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontFamily: 'KaushanScript-Regular',
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to show an error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
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

  // Helper method to check if email exists
  Future<bool> _checkEmailExists(String email) async {
    List<Account> accounts = await AccountManager.getAccounts();
    return accounts.any((account) => account.email == email);
  }
}
