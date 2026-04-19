// import 'package:drift_app/cubits/theme_cubit/theme_state.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class ThemeCubit extends Cubit<ThemeState> {
//   ThemeCubit() : super(ThemeState(ThemeMode.system)) {
//     loadTheme();
//   }

//   // Load saved theme preference
//   Future<void> loadTheme() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final isDark = prefs.getBool('isDarkMode');

//       if (isDark == null) {
//         emit(ThemeState(ThemeMode.system));
//       } else {
//         emit(ThemeState(isDark ? ThemeMode.dark : ThemeMode.light));
//       }
//     } catch (e) {
//       emit(ThemeState(ThemeMode.system));
//     }
//   }

//   // Toggle theme
//   Future<void> toggleTheme(bool isDark) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setBool('isDarkMode', isDark);
//       emit(ThemeState(isDark ? ThemeMode.dark : ThemeMode.light));
//     } catch (e) {
//       // Handle error silently or show message
//     }
//   }

//   // Set specific theme mode
//   Future<void> setThemeMode(ThemeMode mode) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();

//       if (mode == ThemeMode.dark) {
//         await prefs.setBool('isDarkMode', true);
//       } else if (mode == ThemeMode.light) {
//         await prefs.setBool('isDarkMode', false);
//       } else {
//         await prefs.remove('isDarkMode');
//       }

//       emit(ThemeState(mode));
//     } catch (e) {
//       // Handle error silently or show message
//     }
//   }
// }


import 'package:drift_app/cubits/theme_cubit/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeState> {
  // ✅ Start with null — means "not loaded yet"
  ThemeCubit() : super(ThemeState(null)) {
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkMode');

    if (isDark == null) {
      emit(ThemeState(ThemeMode.system));
    } else {
      emit(ThemeState(isDark ? ThemeMode.dark : ThemeMode.light));
    }
  }

  Future<void> toggleTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDark);
    emit(ThemeState(isDark ? ThemeMode.dark : ThemeMode.light));
  }
}