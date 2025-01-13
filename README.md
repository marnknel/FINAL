# Shelfscout

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# Shelfscout
## Οδηγίες Εγκατάστασης και Χρήσης της Εφαρμογής

Ακολουθήστε τα παρακάτω βήματα για να εγκαταστήσετε την εφαρμογή με χρήση του apk:

 1. Κατεβάστε το αρχείο εγκατάστασης (.apk)
 2. Ενεργοποιήστε την εγκατάσταση από άγνωστες πηγές από τις ρυθμίσεις της συσκευής σας.
 3. Αναζητήστε στην συσκευή σας στα κατεβασμένα αρχεία και πατήστε πάνω στον φάκελο .apk και ακολουθήστε τις οδηγίες εγκατάστασης.

Ακολουθήστε τα παρακάτω βήματα για να εγκαταστήσετε την εφαρμογή με χρήση του συμπιεσμένου αρχείου: (που βρίσκεται στο https://github.com/marnknel/FINAL_SHELFSCOUT)

1. Κατεβάστε το συμπιεσμένο αρχείο και εξάγετε τους φακέλους που βρίσκονται εκεί.
2. Κατεβάστε τις εκδόσεις Jdk 23 και Jdk 17 και τοποθετήστε τις σε διαφορετικά directories με μόνο λατινικούς χαρακτήρες. Προσθέστε τα αντίστοιχα path στις μεταβλητές περιβάλλοντος του συστήματος και το gradle properties το org.gradle.java.home= path_17_jdk, όπου path_17_jdk το path της εκδοσης 17 Jdk.
3. Οι εκδόσεις του SDK τις οποίες απαιτεί η εφαρμογή είναι Android 13.0 ΑPI 33 ("Tiramisu") και Android 15.0 ΑPI 35 ("VanillaIceCream").
4. Θα χρειαστεί να κατεβάσετε τα dependencies με την εντολή flutter pub get από το terminal στο directory του project. 
 
  Αρχικά, για να χρησιμοποιήσετε την εφαρμογή, θα πρέπει να φτιάξετε έναν χρήστη κάνοντας sign up. Μόλις βάλετε τα στοιχεία που ζητούνται θα δημιουργηθεί ένας προσωποποιημένος χρήστης και θα μπορέσετε να χρησιμοποίησετε την εφαρμογή. Στην αρχική οθόνη, θα μπορέσετε να προσθέσετε βιβλία που ανταποκρίνονται στα ενδιαφέροντά σας και που έχετε διαβάσει ώστε να αποκτήσετε μία ψηφιακή βιβλιοθήκη την οποία θα μπορείτε να ανατρέξετε οποιαδήποτε στιγμή θέλετε. Με την σελίδα AI, έχετε την ευκαιρία να συνομιλήσετε με ένα LLM για να βρείτε πληροφορίες για βιβλία που σας ενδιαφέρουν. Mπορείτε να σκανάρετε βιβλία και να περάσετε κάποια στοιχεία τους αυτόματα με την χρήση του scan όπου μπορείτε να φωτογραφίσετε το εξώφυλλο και το σύστημα θα αναγνωρίσει τον τίτλο και θα τον αποθηκεύσει. Στην περίπτωση που δεν είστε ευχαριστημένοι από το αποτέλεσμα μπορείτε να επεξεργαστείτε τις πληροφορίες. Ακόμα, έχετε την δυνατότητα να βάλετε προκλήσεις στον εαυτό σας και να θέσετε στόχους ανάγνωσης τους οποίους μπορείτε να προσθέσετε και να ενημερώσετε στην σελίδα goals. Στην σελίδα My info, στο προφίλ σας, θα μπορέσετε να επεξεργαστείτε τις πληροφορίες σας, ακόμα και να διαγράψετε τον λογαριασμό σας. Τέλος, η εφαρμογή στις σελίδες My Notes και My Reviews, σας επιτρέπουν να διατηρείτε σημειώσες για τα βιβλία αλλά και κριτικές.

Λόγω της πολιτικής της OpenAI το API για το AI δεν λειτουργεί εφόσον δημοσιεύτηκε σε κάποια πλατφόρμα όπως το GitHub, ωστόσο θα φροντίσουμε να λειτουργεί την ημέρα της επίδειξης.

# Dependencies:
  flutter:
    sdk: flutter
  confetti: ^0.7.0
  sqflite: ^2.0.0+3
  path_provider: ^2.0.11 
  path: ^1.8.3
  shared_preferences: ^2.0.11
  image_picker: ^0.8.4+3
  google_mlkit_text_recognition: ^0.14.0
  http: 1.2.2
  json_annotation: ^4.7.0
  cupertino_icons: ^1.0.8
