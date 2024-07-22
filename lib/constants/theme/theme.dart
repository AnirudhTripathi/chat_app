import 'package:chat_app/constants/colors/app_pallete.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightMode = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
        background: AppPallete.lightBackgroundColor,
        primary: AppPallete.lightPrimaryColor,
        secondary: AppPallete.lightSecondaryColor,
        tertiary: AppPallete.lightTertiaryColor,
        inversePrimary: AppPallete.lightInversePrimaryColor),
  );

  static final ThemeData darkMode = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
        background: Color.fromARGB(255, 0, 0, 0),
        primary: Color.fromARGB(255, 162, 162, 162),
        secondary: Color.fromARGB(255, 58, 58, 58),
        tertiary: Color.fromARGB(255, 85, 85, 85),
        inversePrimary: Color.fromARGB(255, 255, 255, 255)),
  );
}
