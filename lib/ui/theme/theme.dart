import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    background: Colors.white,
    primary: Colors.black87,
    secondary: Colors.lightBlueAccent,
    tertiary: Colors.white
  )
);

ThemeData darkMode = ThemeData(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
        background: Colors.black45,
        primary: Colors.white54,
        secondary: Colors.brown,
        tertiary: Colors.white60
    )
);