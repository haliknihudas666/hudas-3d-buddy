import 'package:flutter/material.dart';

class CustomColors {
  static const lightColors = ColorScheme(
    primary: Color(0xffFCE76A),
    secondary: Colors.white,
    brightness: Brightness.light,
    surface: Colors.white,
    error: Colors.red,
    onError: Colors.white,
    onPrimary: Colors.black,
    onSecondary: Colors.black,
    onSurface: Colors.black,
  );

  static const darkColors = ColorScheme(
    primary: Color.fromARGB(255, 143, 130, 55),
    secondary: Colors.black,
    brightness: Brightness.dark,
    surface: Color(0xff121212),
    error: Colors.red,
    onError: Colors.white,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.white,
  );
}
