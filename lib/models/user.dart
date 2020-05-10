import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String displayName;
  final String phoneNumber;
  final String photoUrl;
  final String bio;
  final String email;

  User({
    this.id,
    this.displayName,
    this.phoneNumber,
    this.photoUrl,
    this.bio,
    this.email,
  });

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      id: doc['id'],
      displayName: doc['displayName'],
      phoneNumber: doc['phoneNumber'],
      photoUrl: doc['photoUrl'],
      bio: doc['bio'],
      email: doc['email'],
    );
  }
}
