import 'package:flutter/material.dart';
import 'library_screen.dart';
import 'my_goals.dart';
import 'scan.dart';
import 'my_profile.dart';
import 'account_manager.dart';
import 'screen2.dart';

class MyInfoPage extends StatefulWidget {
  const MyInfoPage({super.key});

  @override
  _MyInfoPageState createState() => _MyInfoPageState();
}

class _MyInfoPageState extends State<MyInfoPage> {
  late Account _account;
  bool _isLoading = true; // Flag for loading state

  @override
  void initState() {
    super.initState();
    _initializeProfile();
  }

  Future<void> _initializeProfile() async {
    Account? loggedInAccount = await AccountManager.getLoggedInUser();
    setState(() {
      _account = loggedInAccount ??
          Account(
            email: '',
            password: '',
            firstName: '',
            lastName: '',
            birthDate: '',
            phoneNumber: '',
          );
      _isLoading = false;
    });
  }

  Future<void> _updateField(String field, String newValue) async {
    if (newValue.isEmpty) {
      _showErrorDialog('Field cannot be empty');
      return;
    }

    // Update the corresponding field
    setState(() {
      switch (field) {
        case 'Email':
          _account.email = newValue;
          break;
        case 'Password':
          _account.password = newValue;
          break;
        case 'First name':
          _account.firstName = newValue;
          break;
        case 'Last name':
          _account.lastName = newValue;
          break;
        case 'Birth Date':
          _account.birthDate = newValue;
          break;
        case 'Phone Number':
          _account.phoneNumber = newValue;
          break;
      }
    });

    await AccountManager.updateAccount(_account);
  }

  // Show an error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text('OK')),
        ],
      ),
    );
  }

  // Method for deleting the account
  Future<void> _deleteAccount() async {
    await AccountManager.deleteAccount(_account);

    // Navigate back to LibraryScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Screen2()),
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
                image: AssetImage('assets/images/library_background_main.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Text(
                          'Hi, ${_account.firstName.isNotEmpty ? _account.firstName : 'User'} 👋',
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
                  Align(
                    alignment: Alignment.centerRight,
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
                        backgroundImage:
                            AssetImage('assets/images/profil_image.png'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Welcome to your Infos!',
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
                  const SizedBox(height: 32),
                  ..._buildInfoFields(),
                  const SizedBox(height: 40),
                  // Delete account button
                  Center(
                    child: ElevatedButton(
                      onPressed: () => _showDeleteAccountDialog(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Delete Account',
                        style: TextStyle(
                          fontSize: 16,
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
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // Bottom navigation bar widget
  Widget _buildBottomNavigationBar() {
    return Container(
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
                builder: (context) {
                  return Container(
                    color: const Color.fromRGBO(255, 224, 178, 1),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.flag, color: Colors.black),
                          title: const Text('My Goals',
                              style: TextStyle(color: Colors.black)),
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
                          leading: const Icon(Icons.qr_code_scanner,
                              color: Colors.black),
                          title: const Text('Scan',
                              style: TextStyle(color: Colors.black)),
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
                MaterialPageRoute(builder: (context) => const LibraryScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyProfilePage()),
              );
            },
          ),
        ],
      ),
    );
  }

  // Method for displaying a dialog confirming account deletion
  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text('Are you sure you want to delete your account?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              _deleteAccount();
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildInfoFields() {
    return [
      _buildField('First name', _account.firstName),
      _buildField('Last name', _account.lastName),
      _buildField('Email', _account.email),
      _buildField('Birth Date', _account.birthDate),
      _buildField('Phone Number', _account.phoneNumber),
      _buildField('Password', _account.password),
    ];
  }

  Widget _buildField(String fieldName, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: GestureDetector(
        onTap: () => _editField(fieldName, value),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              fieldName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 50),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method for editing the field values
  Future<void> _editField(String fieldName, String currentValue) async {
    TextEditingController controller =
        TextEditingController(text: currentValue);
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit $fieldName'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: fieldName),
          ),
          actions: <Widget>[
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel')),
            TextButton(
              onPressed: () {
                _updateField(fieldName, controller.text);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
