import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService extends ChangeNotifier {
  bool _isPinkTheme = false;

  ThemeService() {
    _loadTheme();
  }

  bool get isPinkTheme => _isPinkTheme;

  ThemeData get blueTheme => ThemeData(
        primaryColor: const Color(0xFFA7C7E7),
        scaffoldBackgroundColor: const Color(0xFFF0F8FF),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFA7C7E7),
          primary: const Color(0xFFA7C7E7),
          secondary: const Color(0xFF6FA3D1),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFA7C7E7),
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF6FA3D1),
        ),
      );

  ThemeData get pinkTheme => ThemeData(
        primaryColor: const Color(0xFFFFB6C1),
        scaffoldBackgroundColor: const Color(0xFFFFF0F5),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFB6C1),
          primary: const Color(0xFFFFB6C1),
          secondary: const Color(0xFFFF69B4),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFFB6C1),
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFFF69B4),
        ),
      );

  ThemeData get currentTheme => _isPinkTheme ? pinkTheme : blueTheme;

  Future<void> toggleTheme() async {
    _isPinkTheme = !_isPinkTheme;
    await _saveTheme();
    notifyListeners();
  }

  Future<void> _saveTheme() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isPinkTheme', _isPinkTheme);
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isPinkTheme = prefs.getBool('isPinkTheme') ?? false;
    notifyListeners();
  }
}
