import 'package:flutter/material.dart';
import 'signup_screen.dart'; // Import the Sign-Up Screen
import 'login_screen.dart'; // Import the Login Screen

class Screen2 extends StatelessWidget {
  const Screen2({super.key});

  @override
  Widget build(BuildContext context) {
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
          // Buttons and Title
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title
                const Text(
                  'SHELFSCOUT!',
                  style: TextStyle(
                    fontSize: 40,
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.bold,
                    fontFamily:
                        'KaushanScript-Regular', // Custom FontA applied here
                    shadows: [
                      Shadow(
                        offset: Offset(2, 2),
                        blurRadius: 4.0,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                    height: 90), // Spacing between the title and the button
                // Sign-Up Button
                ElevatedButton(
                  onPressed: () {
                    // Navigate to Sign-Up Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 100, vertical: 7), // Larger button size
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 24, // Larger font size
                      fontFamily: 'KaushanScript-Regular', // FontA applied
                      color: Color.fromARGB(255, 19, 17, 17),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Log-In Button
                ElevatedButton(
                  onPressed: () {
                    // Navigate to Login Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(255, 152, 0, 1),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 100, vertical: 7), // Larger button size
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                  child: const Text(
                    'Log In',
                    style: TextStyle(
                      fontSize: 24, // Larger font size
                      fontFamily: 'KaushanScript-Regular', // FontA applied
                      color: Color.fromARGB(255, 12, 10, 10),
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
