import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

// Κλάση Account για τη διαχείριση των λογαριασμών
class Account {
  var email;
  var password;
  var firstName;
  var lastName;
  var birthDate;
  var phoneNumber;

  Account({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.phoneNumber,
  });

  // Μέθοδος για να δημιουργήσεις έναν Account από ένα Map
  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      email: map['email'],
      password: map['password'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      birthDate: map['birthDate'],
      phoneNumber: map['phoneNumber'],
    );
  }

  // Μέθοδος για να μετατρέψεις τον Account σε Map
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'birthDate': birthDate,
      'phoneNumber': phoneNumber,
    };
  }
}

class AccountManager {
  // Αποθήκευση ενός νέου λογαριασμού
  static Future<void> saveAccount(
      String email,
      String password,
      String firstName,
      String lastName,
      String birthDate,
      String phoneNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accountsJson = prefs.getString('accounts');

    List<Account> accounts = accountsJson != null
        ? List<Account>.from(
            jsonDecode(accountsJson).map((account) => Account.fromMap(account)),
          )
        : [];

    // Προσθήκη νέου λογαριασμού στη λίστα
    accounts.add(Account(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
      birthDate: birthDate,
      phoneNumber: phoneNumber,
    ));

    // Αποθήκευση της λίστας λογαριασμών
    prefs.setString('accounts',
        jsonEncode(accounts.map((account) => account.toMap()).toList()));
  }

  // Επαλήθευση αν το email/password είναι σωστά και επιστροφή του πλήρους Account με τα δεδομένα του χρήστη
  static Future<Account?> validateAccount(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accountsJson = prefs.getString('accounts');

    if (accountsJson != null) {
      List<Account> accounts = List<Account>.from(
          jsonDecode(accountsJson).map((account) => Account.fromMap(account)));

      // Έλεγχος αν το email και το password ταιριάζουν με κάποιο λογαριασμό
      for (var account in accounts) {
        if (account.email == email && account.password == password) {
          return account; // Επιστρέφει το πλήρες Account με όλα τα δεδομένα
        }
      }
    }
    return null; // Επιστρέφει null αν δεν βρεθεί το email και το password
  }

  // Ανάκτηση όλων των αποθηκευμένων λογαριασμών
  static Future<List<Account>> getAccounts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accountsJson = prefs.getString('accounts');

    if (accountsJson != null) {
      return List<Account>.from(
          jsonDecode(accountsJson).map((account) => Account.fromMap(account)));
    }
    return [];
  }

  // Ανάκτηση του πρώτου αποθηκευμένου λογαριασμού (για αυτόματη σύνδεση)
  static Future<void> setLoggedInUser(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('loggedInUser', email);
  }

  static Future<Account?> getLoggedInUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('loggedInUser');

    if (email != null) {
      List<Account> accounts = await getAccounts();
      try {
        return accounts.firstWhere((account) => account.email == email);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static Future<void> updateAccount(Account updatedAccount) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Account> accounts = await getAccounts();

    // Βρες και ενημέρωσε τον λογαριασμό
    int index =
        accounts.indexWhere((account) => account.email == updatedAccount.email);
    if (index != -1) {
      // Ενημέρωσε τον λογαριασμό
      accounts[index] = updatedAccount;

      // Αποθήκευσε τους ενημερωμένους λογαριασμούς
      prefs.setString('accounts',
          jsonEncode(accounts.map((account) => account.toMap()).toList()));
    }
  }

  // Μέθοδος για να διαγράψουμε έναν λογαριασμό
  static Future<void> deleteAccount(Account account) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accountsJson = prefs.getString('accounts');

    if (accountsJson != null) {
      List<Account> accounts = List<Account>.from(
        jsonDecode(accountsJson).map((account) => Account.fromMap(account)),
      );

      // Διαγραφή του λογαριασμού από τη λίστα
      accounts.removeWhere(
          (existingAccount) => existingAccount.email == account.email);

      // Αποθήκευση ξανά των ενημερωμένων λογαριασμών
      prefs.setString('accounts',
          jsonEncode(accounts.map((account) => account.toMap()).toList()));

      // Διαγραφή του αποθηκευμένου email του loggedInUser αν το email του διαγραμμένου λογαριασμού είναι το ίδιο
      String? loggedInUserEmail = prefs.getString('loggedInUser');
      if (loggedInUserEmail == account.email) {
        await prefs.remove('loggedInUser');
      }
    }
  }

  // Αποθήκευση εικόνας για έναν χρήστη
  static Future<void> saveUserImages(
      String email, List<String> imagePaths) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('userImages_$email', imagePaths);
  }

  // Ανάκτηση εικόνων για έναν χρήστη
  static Future<List<String>> getUserImages(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('userImages_$email') ?? [];
  }

  // Διαγραφή εικόνας ενός χρήστη
  static Future<void> deleteUserImages(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userImages_$email');
  }

  // Ανάκτηση των κατηγοριών για έναν χρήστη (μετατροπή σε Map<String, List<File?>>)
  static Future<Map<String, List<File?>>> getUserCategories(
      String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Ανάκτηση των καταχωρημένων κατηγοριών ως String List
    List<String>? categories = prefs.getStringList('userCategories_$email');
    Map<String, List<File?>> categoriesMap = {};

    if (categories != null) {
      // Μετατροπή των categories σε Map<String, List<File?>> (αναλόγως του τρόπου αποθήκευσης)
      for (var category in categories) {
        // Εδώ μπορείς να χειριστείς πως να μετατρέψεις την κατηγορία σε List<File?>
        categoriesMap[category] =
            []; // Απλώς φτιάχνουμε μια κενή λίστα για κάθε κατηγορία προς το παρόν
      }
    }

    return categoriesMap;
  }

// Αποθήκευση κατηγοριών για έναν χρήστη (μετατροπή Map<String, List<File?>> σε String List)
  static Future<void> saveUserCategories(
      String email, Map<String, List<File?>> categories) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> categoryList = [];

    categories.forEach((category, files) {
      // Μετατροπή κάθε κατηγορίας σε String, μπορείς να βάλεις το όνομα της κατηγορίας ή άλλο format
      categoryList.add(category);
    });

    prefs.setStringList('userCategories_$email', categoryList);
  }
}
