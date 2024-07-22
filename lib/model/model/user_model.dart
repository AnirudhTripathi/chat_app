// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:convert';
// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String name;
  String email;
  String uid;
  String profilePicture;

  UserModel({
    required this.name,
    required this.email,
    required this.uid,
    required this.profilePicture,
  });

  Map<String, dynamic> toJson() => {
        "name": name,
        "profilePicture": profilePicture,
        "email": email,
        "uid": uid,
      };
  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
      name: snapshot["name"],
      email: snapshot["email"],
      uid: snapshot["uid"],
      profilePicture: snapshot["profilePicture"],
    );
  }
}
