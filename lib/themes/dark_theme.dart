// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    background: Color(0xff021024),  //background 0xff04091C
    surface: Color(0xff052659),    // cards background 0xff101321 0xff0F225E
    secondary: Color(0xff0F225E),
    primary: Color(0xff0D46F2),   // most used color 0xff0D46F2  052659
    onSurface: Color(0xffC1E8FF),// text color 0xff94A3B8
    surfaceContainer: Color(0xff4A6679)
    
  ),
);
