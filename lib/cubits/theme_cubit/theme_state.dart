// import 'package:flutter/material.dart';

// class ThemeState {
//   final ThemeMode themeMode;

//   ThemeState(this.themeMode);
// }

import 'package:flutter/material.dart';

class ThemeState {
  final ThemeMode? themeMode; // ✅ nullable now

  ThemeState(this.themeMode);

  bool get isLoaded => themeMode != null;
}