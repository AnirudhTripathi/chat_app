import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  static final firebaseAuth = FirebaseAuth.instance;
  static final firebaseStorage = FirebaseStorage.instance;
  static final firestore = FirebaseFirestore.instance;
}
