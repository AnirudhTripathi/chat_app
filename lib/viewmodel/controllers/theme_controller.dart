// import 'package:flutter/material.dart';
// import 'package:get/get.dart'; 

// class ThemeController extends GetxController {
//   var isDarkMode = false.obs;

//   @override
//   void onInit() {
//     super.onInit();

//     // Get the current brightness mode from MediaQuery
//     var brightness = MediaQuery.platformBrightnessOf(Get.context!); 
//     isDarkMode.value = brightness == Brightness.dark; 
//   }

//   void switchTheme() {
//     isDarkMode.value = !isDarkMode.value;
//     Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
//   }
// }