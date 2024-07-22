import 'dart:io';

import 'package:chat_app/constants/theme/custom_snackbar.dart';
import 'package:chat_app/model/model/user_model.dart' as model;
import 'package:chat_app/model/services/firebase_service.dart';
import 'package:chat_app/routes/routes_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final Rxn<File?> _pickedImage = Rxn<File?>();
  File? get profilePhoto => _pickedImage.value;
  late Rx<User?> _user;
  User? get user => _user.value;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(FirebaseService.firebaseAuth.currentUser);
    _user.bindStream(FirebaseService.firebaseAuth.authStateChanges());
    ever(_user, _setInitialScreen);
  }

  void _setInitialScreen(User? user) {
    if (user == null) {
      Get.toNamed(RoutesHelper.loginScreen);
    } else {
      Get.toNamed(RoutesHelper.homeScreen);
    }
  }

  void pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      CustomSnackbar.showSuccess("Success", "Image Picked");
      _pickedImage.value = File(pickedImage.path);
    }
  }

  Future<String> _uploadToStorage(File image) async {
    Reference ref = FirebaseService.firebaseStorage
        .ref()
        .child("profilePicture")
        .child(FirebaseService.firebaseAuth.currentUser!.uid);

    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot snap = await uploadTask;
    String downloadURL = await snap.ref.getDownloadURL();
    return downloadURL;
  }

  void registerUser(
      String email, String username, String password, File? image) async {
    try {
      if (email.isNotEmpty &&
          username.isNotEmpty &&
          password.isNotEmpty &&
          image != null) {
        UserCredential cred =
            await FirebaseService.firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        String downloadURL = await _uploadToStorage(image);
        model.UserModel userModel = model.UserModel(
          email: email,
          name: username,
          profilePicture: downloadURL,
          uid: cred.user!.uid,
        );
        await FirebaseService.firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(userModel.toJson());
        CustomSnackbar.showSuccess(
            "Success", "You have been successfully registered");
      } else {
        CustomSnackbar.showError("Error", "Please complete all the feilds");
      }
    } catch (e) {
      CustomSnackbar.showError(
        "Error",
        e.toString(),
      );
    }
  }

  void login(
    String email,
    String password,
  ) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await FirebaseService.firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        print("Logged successfully");
        CustomSnackbar.showSuccess(
            "Success", "You have been successfully logged in");
      } else {
        CustomSnackbar.showError("Error", "Please complete all the feilds");
      }
    } catch (e) {
      CustomSnackbar.showError(
        "Error",
        e.toString(),
      );
    }
  }

  Future<void> signOut() async {
    await FirebaseService.firebaseAuth.signOut();
  }
}
