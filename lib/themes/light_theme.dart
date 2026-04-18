// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    background: Color(0xffDEEBF7),  // background  — light inverse of #021024
    surface: Color(0xffC8D9F5),     // cards background — light inverse of #052659
    primary: Color(0xff0D46F2),     // most used color — identical to dark theme
    onSurface: Color(0xff021024),   // text color — dark navy, inverse of #C1E8FF
    surfaceContainer: Color(0xff8A9BAA), // light inverse of #4A6679
  ),
);