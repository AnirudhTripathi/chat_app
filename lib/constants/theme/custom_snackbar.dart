import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSnackbar {
  static void showSuccess(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.green.shade300,
      colorText: Colors.black,
      snackPosition: SnackPosition.TOP,
    );
  }

  static void showError(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.red,
      colorText: Colors.black,
      snackPosition: SnackPosition.TOP,
    );
  }
}
