class Profile {
  final int? id;
  final String username;
  final String welcomeMessage;
  final String profileImage;
  final String notes;
  final String reviews;
  final String email;
  final String birthDate;
  final String phoneNumber;

  Profile({
    this.id,
    required this.username,
    required this.welcomeMessage,
    required this.profileImage,
    required this.notes,
    required this.reviews,
    required this.email,
    required this.birthDate,
    required this.phoneNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'welcomeMessage': welcomeMessage,
      'profileImage': profileImage,
      'notes': notes,
      'reviews': reviews,
      'email': email,
      'birthDate': birthDate,
      'phoneNumber': phoneNumber,
    };
  }

  static Profile fromMap(Map<String, dynamic> map) {
    return Profile(
      id: map['id'],
      username: map['username'],
      welcomeMessage: map['welcomeMessage'],
      profileImage: map['profileImage'],
      notes: map['notes'],
      reviews: map['reviews'],
      email: map['email'],
      birthDate: map['birthDate'],
      phoneNumber: map['phoneNumber'],
    );
  }
}
